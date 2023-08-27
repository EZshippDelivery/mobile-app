import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:ezshipp/APIs/new_orderlist.dart';
import 'package:ezshipp/APIs/places/place_address.dart';
import 'package:ezshipp/APIs/places/place_details.dart';
import 'package:ezshipp/Provider/biker_controller.dart';
import 'package:ezshipp/utils/http_requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../APIs/get_top_addresses.dart';
import '../APIs/places/place_search.dart';
import '../utils/variables.dart';

class MapsProvider extends BikerController {
  List<LatLng> info = [];
  List placesList = [];
  List<GetAllAddresses> savedAddress = [];
  List focus = [true, true];
  late PlaceDetails placesDetails;
  late PlaceAddress placeAddress, placeAddress1;
  bool isclicked = false, currentLocation = false;
  List boundsMap = [], directioDetails = [];

  bool fileExists = false;

  MapsProvider() {
    getMarkers();
  }

  dynamic _returnResponse(
      BuildContext context, NewOrderList? reference, GoogleMapController? controller, dio.Response response) {
    try {
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
          //Variables.showtoast("Status updated");

          break;
        case 400:
          Variables.showtoast(context, response.data.toString(), Icons.warning_rounded);
          break;
        case 401:
        case 403:
          Variables.showtoast(context, response.data.toString(), Icons.warning_rounded);
          break;
        case 500:
        default:
          Variables.showtoast(
              context,
              'Error occured while Communication with Server with StatusCode : ${response.statusCode}',
              Icons.warning_rounded);
          break;
      }
    } on Exception {
      Variables.showtoast(context, "No Proper location details", Icons.cancel_outlined);
    }
  }

  dynamic returnResponse(bool mounted, BuildContext context, dio.Response response, int details) {
    switch (response.statusCode) {
      case 200:
        if (details == 0 && response.data["status"].toString().toLowerCase() == "ok") {
          placesList = List.generate(response.data['predictions']!.length,
              (index) => PlaceSearch.fromMap(response.data['predictions'][index]));
        } else if (details == 1 && response.data["status"].toString().toLowerCase() == "ok") {
          placesDetails = PlaceDetails.fromMap(response.data);
        } else if (details == 2 && response.data["status"].toString().toLowerCase() == "ok") {
          placeAddress = PlaceAddress.fromMap(response.data);
        } else if (details == 3 && response.data["status"].toString().toLowerCase() == "ok") {
          placeAddress1 = PlaceAddress.fromMap(response.data);
        } else {
          if (details == 1) {
            placesDetails = PlaceDetails.fromMap({});
          } else if (details == 2) {
            placeAddress = PlaceAddress.fromMap({});
          } else if (details == 3) {
            placeAddress1 = PlaceAddress.fromMap({});
          }
        }
        break;
      case 400:
        Variables.showtoast(context, response.data.toString(), Icons.warning_rounded);
        break;
      case 401:
      case 403:
        Variables.showtoast(context, response.data.toString(), Icons.warning_rounded);
        break;
      case 500:
      default:
        Variables.showtoast(
            context,
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}',
            Icons.warning_rounded);
        break;
    }
  }

  Future<void> directions(bool mounted, BuildContext context, GoogleMapController? controller, NewOrderList? reference,
      {List<LatLng>? places}) async {
    try {
      if (reference != null) {
        final response = await dio.Dio().get("https://maps.googleapis.com/maps/api/directions/json?", queryParameters: {
          "origin": "${reference.pickLatitude},${reference.pickLongitude}",
          "destination": "${reference.dropLatitude},${reference.dropLongitude}",
          "key": Variables.key
        });
        if (!mounted) return;
        _returnResponse(context, reference, controller, response);
      } else {
        if (places != null) {
          final response =
              await dio.Dio().get("https://maps.googleapis.com/maps/api/directions/json?", queryParameters: {
            "origin": "${places[0].latitude},${places[0].longitude}",
            "destination": "${places[1].latitude},${places[1].longitude}",
            "key": Variables.key
          });
          if (!mounted) return;
          _returnResponse(context, null, controller, response);
        }
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    } catch (e) {
      Variables.showtoast(context, "No Proper location details", Icons.cancel_outlined);
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

  getAutoComplete(bool mounted, BuildContext context, String value) async {
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
        if (!mounted) return;
        returnResponse(mounted, context, response, 0);
      } else {
        placesList.clear();
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    notifyListeners();
  }

  Future<void> getPlaceDetails(bool mounted, BuildContext context, String value) async {
    try {
      if (value.isNotEmpty) {
        final response =
            await dio.Dio().get("https://maps.googleapis.com/maps/api/place/details/json?", queryParameters: {
          "place_id": value,
          "key": Variables.key,
        });
        if (!mounted) return;
        returnResponse(mounted, context, response, 1);
      } else {
        placesList.clear();
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    notifyListeners();
  }

  clear({bool? value}) {
    isclicked = value ?? isclicked;
    if (placesList.isNotEmpty) placesList.clear();
    notifyListeners();
  }

  void setfocus(int index, bool value) {
    focus[index] = value;
    notifyListeners();
  }

  setMarkers(bool mounted, BuildContext context, GoogleMapController controller, {pickup, delivery}) {
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
      directions(mounted, context, controller, null, places: [pickmark!.position, dropmark!.position]).then((value) {
        var latLngBounds = LatLngBounds(southwest: boundsMap[1], northeast: boundsMap[0]);
        controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 50));
      });
    }
    notifyListeners();
  }

  getTopAddresses(bool mounted, BuildContext context, customerId) async {
    try {
      final response = await HTTPRequest.getRequest(Variables.uri(path: "/customer/$customerId/address"));
      if (!mounted) return;

      var responseJson = Variables.returnResponse(context, response);
      if (responseJson != null) {
        savedAddress = responseJson.map<GetAllAddresses>((e) => GetAllAddresses.fromMap(e)).toList();
        savedAddress.sort((a, b) => a.addressType.compareTo(b.addressType));
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    if (!mounted) return;
    // await setCurrentLocation(mounted, context, customerId);
    notifyListeners();
  }

  Future<void> setCurrentLocation(bool mounted, BuildContext context, int customerId, {bool addAddress = false}) async {
    try {
      await getCurrentlocations();
      final response = await dio.Dio().get("https://maps.googleapis.com/maps/api/geocode/json?", queryParameters: {
        "latlng": "$latitude,$longitude",
        "key": Variables.key,
      });
      if (!mounted) return;
      returnResponse(mounted, context, response, 2);
      placeAddress.results.removeWhere((i) => (i.addressComponents.first.types.contains("plus_code") ||
          i.addressComponents.first.types.contains("premise")));
      placeAddress.results.retainWhere((i) => i.addressComponents.last.types.contains("postal_code"));

      String state = placeAddress.results.first.addressComponents
          .where((element) => element.types.contains("administrative_area_level_1"))
          .first
          .longName;
      String city = placeAddress.results.first.addressComponents
          .where(
              (element) => element.types.contains("administrative_area_level_2") || element.types.contains("locality"))
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
      if (addAddress) {
        savedAddress = [GetAllAddresses.fromMap(currentLocation)];
      } else {
        savedAddress.insert(0, GetAllAddresses.fromMap(currentLocation));
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    notifyListeners();
  }

  Future<Map<String, dynamic>?> setLocation(
      bool mounted, BuildContext context, double lat, double long, customerId) async {
    Map<String, dynamic>? currentLocation;
    try {
      final response = await dio.Dio().get("https://maps.googleapis.com/maps/api/geocode/json?", queryParameters: {
        "latlng": "$lat,$long",
        "key": Variables.key,
      });
      if (!mounted) return currentLocation;
      returnResponse(mounted, context, response, 3);
      placeAddress1.results.removeWhere((i) => (i.addressComponents.first.types.contains("plus_code") ||
          i.addressComponents.first.types.contains("premise")));
      placeAddress1.results.retainWhere((i) => i.addressComponents.last.types.contains("postal_code"));
      String state = placeAddress1.results.first.addressComponents
          .where((element) => element.types.contains("administrative_area_level_1"))
          .first
          .longName;
      String city = placeAddress1.results.first.addressComponents
          .where(
              (element) => element.types.contains("administrative_area_level_2") || element.types.contains("locality"))
          .first
          .longName;

      currentLocation = {
        "customerId": customerId,
        "address1": placeAddress1.results.first.formattedAddress,
        "pincode": int.parse(placeAddress1.results.first.addressComponents.last.longName),
        "state": state,
        "type": "OTHER",
        "longitude": long,
        "latitude": lat,
        "city": city,
      };
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    notifyListeners();
    return currentLocation;
  }

  refreshCurrentLocation() {
    getCurrentlocations().then((value) {
      savedAddress[0].latitude = latitude;
      savedAddress[0].longitude = longitude;
    });
    notifyListeners();
  }
}
