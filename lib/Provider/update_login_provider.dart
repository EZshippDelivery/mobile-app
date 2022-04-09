import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../utils/http_requests.dart';
import '../utils/variables.dart';

class UpdateLoginProvider extends ChangeNotifier {
  String userType = "driver";
  Map? profile;

  httpost(BuildContext context, body) async {
    try {
      Response? response;
      var uri = Variables.uri(path: '/register/${Variables.deviceInfo['userType']!.toLowerCase()}');
      if (Variables.deviceInfo['userType'] != null) {
        response = await HTTPRequest.postRequest(uri, body, true);
      }
      if (response != null) {
        profile = Variables.returnResponse(context, response);
      } else {
        Variables.showtoast(context, "Sign Up is not successfull", Icons.cancel_outlined);
      }
    } on SocketException catch (e) {
      Variables.showtoast(context, 'No Internet connection\n${e.message}', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    notifyListeners();
    if (profile != null) return profile;
  }

  getOTP(BuildContext context, String body) async {
    try {
      final response = await HTTPRequest.postRequest(Variables.uri(path: "/customer/otp/generate"), body);
      var responseJson = Variables.returnResponse(context, response);
      if (responseJson != null) Variables.showtoast(context, "OTP send", Icons.check);
    } on SocketException catch (e) {
      Variables.showtoast(
          context, 'No Internet connection\n${e.message}', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
  }

  verifyOTP(BuildContext context, body) async {
    Map? responseJson;
    try {
      final response = await HTTPRequest.getRequest(
          Variables.uri(path: "/customer/otp/validate", queryParameters: body as Map<String, dynamic>));
      responseJson = Variables.returnResponse(context, response);
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    return responseJson;
  }

  store(bool value) async {
    await Variables.write(key: "islogin", value: value.toString());
    notifyListeners();
  }

  void setUsetType(value) {
    userType = value;
    notifyListeners();
  }

  login(BuildContext context, Map<String, dynamic> body) async {
    try {
      body.addAll({
        "appVersion": "V1",
        "authType": "EMAIL",
        "loginSource": "MOBILE",
      });
      final response = await HTTPRequest.postRequest(Variables.uri(path: "/register/signin"), jsonEncode(body));
      Map<String, dynamic>? map = Variables.returnResponse(context, response);
      if (map != null) {
        Variables.token = map["accessToken"];
        userType = map["userType"];
        if (userType.toLowerCase() == "driver") {
          Variables.driverId = map["bikerId"];
        } else {
          Variables.driverId = map["customerId"];
        }
      } else {
        Variables.token = '';
        Variables.driverId = -1;
        userType = "";
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    notifyListeners();
  }
}
