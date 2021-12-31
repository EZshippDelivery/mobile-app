import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:ezshipp/APIs/new_orderlist.dart';
import 'package:ezshipp/APIs/places/place_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../APIs/places/place_search.dart';
import '../utils/variables.dart';

class MapsProvider extends ChangeNotifier {
  List<LatLng> info = [];
  List<PlaceSearch> placesList = [];
  BitmapDescriptor? originMarker, destinationMarker;
  Marker? pickmark, dropmark;
  List focus = [true, true];
  double latitude = 0, longitude = 0;
  late PlaceDetails placesDetails;
  bool isorigin = false, placeAdress = false, currentLocation = false, isOnline = false;
  List boundsMap = [], directioDetails = [], savedAddress = [];
  Timer? timer;

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

  dynamic returnResponse(dio.Response response, bool isdetails) {
    switch (response.statusCode) {
      case 200:
        if (!isdetails) {
          placesList = List.generate(response.data['predictions']!.length,
              (index) => PlaceSearch.fromMap(response.data['predictions'][index]));
        } else {
          placesDetails = PlaceDetails.fromMap(response.data);
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
          "key": "AIzaSyCuvs8lj4MQgGWE26w3twaifCgxk_Vk8Yw",
          "components": "country:in"
        });
        returnResponse(response, false);
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
        returnResponse(response, true);
      } else {
        placesList.clear();
      }
    } on SocketException {
      Variables.showtoast('No Internet connection');
    }
    notifyListeners();
  }

  clear({bool? value, bool complete = false}) {
    isorigin = value ?? isorigin;
    placeAdress = complete;
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

  void filter(String value) {
    savedAddress = savedAddress.where((element) => element.address1.startsWith(value)).toList();
    notifyListeners();
  }

  online(bool value, int bikerId, {bool fromhomepage = false}) async {
    if (value) {
      timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
        await getCurrentlocations();
        final response = await put(Variables.uri(path: "/biker/onoff/$bikerId"),
            body: jsonEncode({"driverId": bikerId, "latitude": latitude, "longitude": longitude, "onlineMode": value}),
            headers: Variables.headers);
        Variables.returnResponse(response, onlinemode: true);
      });
      Variables.showtoast("You are in online mode ");
    } else {
      if (timer != null) timer!.cancel();
      await getCurrentlocations();
      final response = await put(Variables.uri(path: "/biker/onoff/$bikerId"),
          body: jsonEncode({"driverId": bikerId, "latitude": latitude, "longitude": longitude, "onlineMode": value}),
          headers: Variables.headers);
      Variables.returnResponse(response, onlinemode: true);
      Variables.showtoast("You are in offline mode ");
    }
    final pref = await SharedPreferences.getInstance();
    pref.setBool("isOnline", value);
    isOnline = value;
    if (!fromhomepage) notifyListeners();
  }
}
