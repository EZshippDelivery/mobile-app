import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:ezshipp/APIs/new_orderlist.dart';
import 'package:ezshipp/APIs/places/place_address.dart';
import 'package:ezshipp/APIs/places/place_details.dart';
import 'package:ezshipp/utils/http_requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../APIs/get_top_addresses.dart';
import '../APIs/places/place_search.dart';
import '../utils/variables.dart';

class MapsProvider extends ChangeNotifier {
  List<LatLng> info = [];
  List placesList = [];
  List<GetAllAddresses> savedAddress = [];
  BitmapDescriptor? originMarker, destinationMarker, driverMarker;
  Marker? pickmark, dropmark, driver;
  List focus = [true, true];
  double latitude = 0, longitude = 0;
  late PlaceDetails placesDetails;
  late PlaceAddress placeAddress;
  bool isorigin = false, currentLocation = false, isOnline = false;
  List boundsMap = [], directioDetails = [];
  Timer? timer, timer1;

  bool fileExists = false;

  MapsProvider() {
    getMarkers();
  }

  dynamic _returnResponse(NewOrderList? reference, GoogleMapController? controller, dio.Response response) {
    switch (response.statusCode) {
      case 200:
        var data = response.data;
        final encodedString = data['routes'][0]["overview_polyline"]["points"];
        boundsMap = [data['routes'][0]['bounds']["northeast"], data['routes'][0]['bounds']["southwest"]];
        boundsMap =
            List.generate(boundsMap.length, (index) => LatLng(boundsMap[index]['lat'], boundsMap[index]['lng']));
        directioDetails = [data['routes'][0]['legs'][0]["distance"], data['routes'][0]['legs'][0]["duration"]];
        if (reference != null) {
          pickmark = Marker(
              onTap: () => controller!.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: LatLng(reference.pickLatitude, reference.pickLongitude), zoom: 15))),
              markerId: const MarkerId("origin"),
              icon: originMarker!,
              position: LatLng(reference.pickLatitude, reference.pickLongitude),
              infoWindow: InfoWindow(title: "Pick Address", snippet: reference.pickAddress));
          dropmark = Marker(
              onTap: () => controller!.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: LatLng(reference.dropLatitude, reference.dropLongitude), zoom: 15))),
              markerId: const MarkerId("destination"),
              icon: destinationMarker!,
              position: LatLng(reference.dropLatitude, reference.dropLongitude),
              infoWindow: InfoWindow(title: "Delivery Address", snippet: reference.dropAddress));
        }
        info = PolylinePoints().decodePolyline(encodedString).map((e) => LatLng(e.latitude, e.longitude)).toList();
        Variables.showtoast("Status updated");

        break;
      case 400:
        Variables.showtoast(response.data.toString());
        break;
      case 401:
      case 403:
        Variables.showtoast(response.data.toString());
        break;
      case 500:
      default:
        Variables.showtoast('Error occured while Communication with Server with StatusCode : ${response.statusCode}');
        break;
    }
  }

  dynamic returnResponse(dio.Response response, int details) {
    switch (response.statusCode) {
      case 200:
        if (details == 0) {
          placesList = List.generate(response.data['predictions']!.length,
              (index) => PlaceSearch.fromMap(response.data['predictions'][index]));
        } else if (details == 1) {
          placesDetails = PlaceDetails.fromMap(response.data);
        } else {
          placeAddress = PlaceAddress.fromMap(response.data);
        }
        break;
      case 400:
        Variables.showtoast(response.data.toString());
        break;
      case 401:
      case 403:
        Variables.showtoast(response.data.toString());
        break;
      case 500:
      default:
        Variables.showtoast('Error occured while Communication with Server with StatusCode : ${response.statusCode}');
        break;
    }
  }

  Future<void> directions(GoogleMapController? controller, NewOrderList? reference, {List<LatLng>? places}) async {
    try {
      if (reference != null) {
        final response = await dio.Dio().get("https://maps.googleapis.com/maps/api/directions/json?", queryParameters: {
          "origin": "${reference.pickLatitude},${reference.pickLongitude}",
          "destination": "${reference.dropLatitude},${reference.dropLongitude}",
          "key": Variables.key
        });
        _returnResponse(reference, controller, response);
      } else {
        if (places != null) {
          final response =
              await dio.Dio().get("https://maps.googleapis.com/maps/api/directions/json?", queryParameters: {
            "origin": "${places[0].latitude},${places[0].longitude}",
            "destination": "${places[1].latitude},${places[1].longitude}",
            "key": Variables.key
          });
          _returnResponse(null, controller, response);
        }
      }
    } on SocketException {
      Variables.showtoast('No Internet connection');
    }
    notifyListeners();
  }

  getMarkers() async {
    originMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(10, 10)), "assets/icon/pickmarker.png");
    destinationMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(10, 10)), "assets/icon/dropmarker.png");
    driverMarker =
        await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(10, 10)), "assets/icon/ic_rider.png");
  }

  getAutoComplete(String value) async {
    try {
      if (value.isNotEmpty) {
        final response =
            await dio.Dio().get("https://maps.googleapis.com/maps/api/place/autocomplete/json?", queryParameters: {
          "radius": 100000,
          'strictbounds': true,
          "types": "geocode|establishment",
          "input": value,
          "location": "17.387140,78.491684",
          "key": Variables.key,
          "components": "country:in"
        });
        returnResponse(response, 0);
      } else {
        placesList.clear();
      }
    } on SocketException {
      Variables.showtoast('No Internet connection');
    }
    notifyListeners();
  }

  Future<void> getPlaceDetails(String value) async {
    try {
      if (value.isNotEmpty) {
        final response =
            await dio.Dio().get("https://maps.googleapis.com/maps/api/place/details/json?", queryParameters: {
          "place_id": value,
          "key": Variables.key,
        });
        returnResponse(response, 1);
      } else {
        placesList.clear();
      }
    } on SocketException {
      Variables.showtoast('No Internet connection');
    }
    notifyListeners();
  }

  clear({bool? value}) {
    isorigin = value ?? isorigin;
    placesList.clear();
    notifyListeners();
  }

  void setfocus(int index, bool value) {
    focus[index] = value;
    notifyListeners();
  }

  Future<void> getCurrentlocations() async {
    final currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    latitude = currentLocation.latitude;
    longitude = currentLocation.longitude;
    notifyListeners();
  }

  setMarkers(GoogleMapController controller, {pickup, delivery}) {
    if (pickup != null) {
      pickmark = Marker(
          onTap: () =>
              controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: pickup, zoom: 15))),
          markerId: const MarkerId("origin"),
          icon: originMarker!,
          position: pickup,
          infoWindow: const InfoWindow(title: "Pick Address"));
    }
    if (delivery != null) {
      dropmark = Marker(
          onTap: () =>
              controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: delivery, zoom: 15))),
          markerId: const MarkerId("destination"),
          icon: destinationMarker!,
          position: delivery,
          infoWindow: const InfoWindow(title: "Delivery Address"));
    }
    if (pickmark != null && dropmark != null) {
      directions(controller, null, places: [pickmark!.position, dropmark!.position]).then((value) {
        var latLngBounds = LatLngBounds(southwest: boundsMap[1], northeast: boundsMap[0]);
        controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 50));
      });
    }
    notifyListeners();
  }

  getTopAddresses(customerId) async {
    try {
      final response = await HTTPRequest.getRequest(Variables.uri(path: "/customer/$customerId/address"));
      var responseJson = Variables.returnResponse(response);
      if (responseJson != null) {
        savedAddress = responseJson.map<GetAllAddresses>((e) => GetAllAddresses.fromMap(e)).toList();
        savedAddress.sort((a, b) => a.addressType.compareTo(b.addressType));
      }
    } on SocketException {
      Variables.showtoast('No Internet connection');
    }
    await setCurrentLocation(customerId);
    notifyListeners();
  }

  online(bool value, int bikerId, {bool fromhomepage = false}) async {
    Directory dir;
    dir = (await getExternalStorageDirectory())!;
    File file = File("${dir.path}/location.json");
    fileExists = file.existsSync();
    if (value) {
      timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
        await getCurrentlocations();
        final response = await HTTPRequest.putRequest(Variables.uri(path: "/biker/onoff/$bikerId"),
            jsonEncode({"driverId": bikerId, "latitude": latitude, "longitude": longitude, "onlineMode": value}));
        writeToJsonFile(dir, file, {
          "timestamp:": DateTime.now().toIso8601String(),
          "driverId": bikerId,
          "latitude": latitude,
          "longitude": longitude,
          "onlineMode": value
        });
        Variables.returnResponse(response, onlinemode: true);
      });
      Variables.showtoast("You are in online mode ");
    } else {
      if (timer != null) timer!.cancel();
      await getCurrentlocations();
      final response = await HTTPRequest.putRequest(Variables.uri(path: "/biker/onoff/$bikerId"),
          jsonEncode({"driverId": bikerId, "latitude": latitude, "longitude": longitude, "onlineMode": value}));
      Variables.returnResponse(response, onlinemode: true);
      Variables.showtoast("You are in offline mode ");
    }

    await Variables.write(key: "isOnline", value: value.toString());
    isOnline = value;
    if (!fromhomepage) notifyListeners();
  }

  Future<void> setCurrentLocation(customerId) async {
    try {
      await getCurrentlocations();
      final response = await dio.Dio().get("https://maps.googleapis.com/maps/api/geocode/json?", queryParameters: {
        "latlng": "$latitude,$longitude",
        "key": Variables.key,
      });
      returnResponse(response, 2);
      placeAddress.results.removeWhere((i) => (i.addressComponents.first.types.contains("plus_code") ||
          i.addressComponents.first.types.contains("premise")));
      placeAddress.results.retainWhere((i) => i.addressComponents.last.types.contains("postal_code"));
      String state = placeAddress.results.first.addressComponents
          .where((element) => element.types.contains("administrative_area_level_1"))
          .first
          .longName;
      String city = placeAddress.results.first.addressComponents
          .where((element) => element.types.contains("administrative_area_level_2"))
          .first
          .longName;

      Map<String, dynamic> currentLocation = {
        "customerId": customerId,
        "address1": placeAddress.results.first.formattedAddress,
        "pincode": int.parse(placeAddress.results.first.addressComponents.last.longName),
        "state": state,
        "addressType": "CURRENT",
        "longitude": longitude,
        "latitude": latitude,
        "city": city,
      };
      savedAddress.insert(0, GetAllAddresses.fromMap(currentLocation));
    } on SocketException {
      Variables.showtoast('No Internet connection');
    }
    notifyListeners();
  }

  refreshCurrentLocation() {
    getCurrentlocations().then((value) {
      savedAddress[0].latitude = latitude;
      savedAddress[0].longitude = longitude;
    });
    notifyListeners();
  }

  void writeToJsonFile(Directory dir, File file, Map<String, Object> map) {
    if (fileExists) {
      List fileContent = jsonDecode(file.readAsStringSync());
      fileContent.add(map);
      file.writeAsStringSync(jsonEncode(fileContent));
    } else {
      file.createSync();
      fileExists = true;
      file.writeAsStringSync(jsonEncode([map]));
    }
  }

  livebikerTracking(int driverId, int orderId) {
    timer1 = Timer.periodic(const Duration(seconds: 5), (time) async {
      final response = await HTTPRequest.getRequest(
          Variables.uri(path: "/biker/orders/getLiveLocationByDriverId/$driverId/$orderId"));
      Map<String, dynamic>? map = Variables.returnResponse(response);
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
}
