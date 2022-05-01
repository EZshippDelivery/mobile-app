import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:ezshipp/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../APIs/my_orderlist.dart';
import '../APIs/new_orderlist.dart';
import '../APIs/profile.dart';
import '../APIs/update_profile.dart';
import '../utils/http_requests.dart';
import '../utils/variables.dart';

class BikerController extends ChangeNotifier {
  DateTime start = DateTime.now().subtract(const Duration(days: 7)), end = DateTime.now();
  List<NewOrderList> newOrderList = [], acceptedList = [], deliveredList = [];
  BitmapDescriptor? originMarker, destinationMarker, driverMarker;
  Marker? pickmark, dropmark, driver;
  DecorationImage? decorationImage;
  Profile? riderProfile;
  Timer? timer, timer1;

  double latitude = 0, longitude = 0;
  bool isOnline = false, isLastPage = false, isLastPage1 = false, isLastPage2 = false;
  bool loading = true, loading2 = true, loading3 = true;
  String fullName = "", name = "";
  int pagenumber = 1, pagenumber1 = 1;
  int index = 0;

  offLineMode(bool mounted, BuildContext context, bool value, {bool fromhomepage = false}) async {
    if (!mounted) return;
    if (value) {
      timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
        await getCurrentlocations();
        final response = await HTTPRequest.putRequest(
            Variables.uri(path: "/biker/onoff/${Variables.driverId}"),
            jsonEncode(
                {"driverId": Variables.driverId, "latitude": latitude, "longitude": longitude, "onlineMode": value}));
        if (!mounted) return;
        Variables.returnResponse(context, response, onlinemode: true);
      });
      Variables.showtoast(context, "You are in online mode ", Icons.info_outline_rounded);
    } else {
      if (timer != null) timer!.cancel();
      await getCurrentlocations();
      final response = await HTTPRequest.putRequest(
          Variables.uri(path: "/biker/onoff/${Variables.driverId}"),
          jsonEncode(
              {"driverId": Variables.driverId, "latitude": latitude, "longitude": longitude, "onlineMode": value}));
      if (!mounted) return;
      Variables.returnResponse(context, response, onlinemode: true);
      Variables.showtoast(context, "You are in offline mode ", Icons.info_outline_rounded);
    }

    await Variables.write(key: "isOnline", value: value.toString());
    isOnline = value;
    if (!fromhomepage) notifyListeners();
  }

  Future<void> getCurrentlocations() async {
    final currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    latitude = currentLocation.latitude;
    longitude = currentLocation.longitude;
    notifyListeners();
  }

  getAllOrdersByBikerId(bool mounted, BuildContext context) async {
    try {
      final response = await HTTPRequest.getRequest(Variables.uri(path: "/biker/orders/${Variables.driverId}/true"));
      if (!mounted) return;
      List? responseJson = Variables.returnResponse(context, response);
      if (responseJson != null) {
        newOrderList = List.generate(responseJson.length, (index) => NewOrderList.fromMap(responseJson[index]));
        newOrderList = newOrderList.reversed.toList();
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    loading = false;
    notifyListeners();
  }

  Future<double?> getDistance(bool mounted, BuildContext context, String body) async {
    try {
      final response =
          await HTTPRequest.postRequest(Variables.uri(path: "/biker/orders/${Variables.driverId}/distance"), body);
      if (!mounted) return 0;
      var responseJson = Variables.returnResponse(context, response);
      if (responseJson != null) {
        return responseJson[0]["distance"];
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    return null;
  }

  getAcceptedAndinProgressOrders(bool mounted, BuildContext context) async {
    try {
      final response = await HTTPRequest.getRequest(
          Variables.uri(path: "/biker/orders/acceptedandinprogressorders/${Variables.driverId}/$pagenumber/20"));
      if (!mounted) return;
      var responseJson = Variables.returnResponse(context, response);
      if (responseJson != null) {
        if (responseJson["data"].isNotEmpty) {
          if (pagenumber1 == 1) {
            acceptedList = List.generate(
                responseJson["data"].length, (index) => NewOrderList.fromMap(responseJson["data"][index]));
          } else if (pagenumber1 > 1) {
            acceptedList.addAll(responseJson["data"].map<NewOrderList>((e) => NewOrderList.fromMap(e)).toList());
          }
          isLastPage = false;
        } else {
          isLastPage = true;
        }
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    loading2 = false;
    notifyListeners();
  }

  setDate(bool mounted, BuildContext context, DateTime? value, bool end) async {
    if (end) {
      this.end = value ?? this.end;
    } else {
      start = value ?? start;
    }
    await getAllCompletedOrders(mounted, context, start.toString(), this.end.toString());
  }

  getAllCompletedOrders(bool mounted, BuildContext context, String startdate, String enddate) async {
    try {
      var body = MyOrderList(pageNumber: pagenumber, startDate: startdate, endDate: enddate);
      final response = await HTTPRequest.postRequest(
          Variables.uri(path: "/biker/orders/completed/${Variables.driverId}"), body.toJson());
      if (!mounted) return;
      var responseJson = Variables.returnResponse(context, response);
      if (responseJson != null) {
        if (responseJson["data"].isNotEmpty) {
          deliveredList =
              List.generate(responseJson["data"].length, (index) => NewOrderList.fromMap(responseJson["data"][index]));
          isLastPage1 = false;
        } else {
          isLastPage1 = true;
        }
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    loading3 = false;
    notifyListeners();
  }

  livebikerTracking(bool mounted, BuildContext context, int driverId, int orderId) {
    timer1 = Timer.periodic(const Duration(seconds: 5), (time) async {
      final response = await HTTPRequest.getRequest(
          Variables.uri(path: "/biker/orders/getLiveLocationByDriverId/$driverId/$orderId"));
      if (!mounted) return;
      Map<String, dynamic>? map = Variables.returnResponse(context, response);
      if (map != null) {
        driver = Marker(
            markerId: const MarkerId("origin"),
            icon: driverMarker!,
            position: LatLng(map["lastLatitude"], map["lastLongitude"]),
            infoWindow: const InfoWindow(title: "Driver Location"));
      }
      notifyListeners();
    });
  }

  void setName(String? fullName) {
    if (fullName != null) {
      if (fullName.contains(RegExp(r'\s'))) {
        name = fullName.indexOf(' ') == fullName.length - 1
            ? fullName[0]
            : fullName[0] + fullName[fullName.indexOf(' ') + 1];
      } else {
        name = fullName[0];
      }
    } else {
      name = "";
    }
    notifyListeners();
  }

  getProfile(bool mounted, BuildContext context) async {
    final colorIndex = await Variables.read(key: "color_index");
    index = colorIndex == null ? Random().nextInt(Colors.primaries.length) : int.parse(colorIndex);
    try {
      final response = await HTTPRequest.getRequest(Variables.uri(path: "/biker/profile/${Variables.driverId}"));
      if (!mounted) return;
      var responseJson = Variables.returnResponse(context, response);
      if (responseJson != null) {
        riderProfile = Profile.fromMap(responseJson);
      }
    } on SocketException {
      if (!mounted) return;
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    if (riderProfile != null) {
      decorationImage = riderProfile!.profileUrl!.isEmpty
          ? null
          : DecorationImage(image: MemoryImage(base64Decode(riderProfile!.profileUrl!)));
      setName(riderProfile!.name);
      fullName = riderProfile!.name;
    }
    notifyListeners();
  }

  updateProfile(bool mounted, BuildContext context) async {
    try {
      var json = UpdateProfile.fromMap1(riderProfile!.toMap(), TextFields.data).toJson();
      final response = await HTTPRequest.putRequest(Variables.uri(path: "/biker/profile/${Variables.driverId}"), json);
      if (!mounted) return;
      var responseJson = Variables.returnResponse(context, response);
      if (responseJson != null) {
        if (!mounted) return;
        Variables.showtoast(context, "Updating profile successfull", Icons.check);
        await getProfile(mounted, context);
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    notifyListeners();
  }

  bikerRating(bool mounted, BuildContext context, int driverid, int orderid, int rating) async {
    try {
      Map body = {
        "carryingBag": true,
        "customerId": Variables.driverId,
        "deliveredProperly": true,
        "driverId": driverid,
        "notes": rating == 1
            ? "Very bad"
            : rating == 2
                ? "Bad"
                : rating == 3
                    ? "Not bad"
                    : rating == 4
                        ? "Good"
                        : "Very Good",
        "orderId": orderid,
        "rating": rating,
        "wearingTShirt": true
      };
      final response = await HTTPRequest.postRequest(Variables.uri(path: "/biker/rating"), jsonEncode(body));
      if (!mounted) return;
      Variables.returnResponse(context, response, onlinemode: true);
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    notifyListeners();
  }
}
