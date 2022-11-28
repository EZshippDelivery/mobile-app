import 'dart:convert';
import 'dart:io';

import 'package:ezshipp/Provider/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../utils/http_requests.dart';
import '../utils/variables.dart';

class AuthController extends UserController {
  String userType = "";
  Map? profile;

  registerUser(bool mounted, BuildContext context, String body) async {
    try {
      Response? response;
      if (Variables.deviceInfo['userType'] != null) {
        var uri = Variables.uri(path: '/register/${Variables.deviceInfo['userType']!.toLowerCase()}');
        response = await HTTPRequest.postRequest(uri, body, true);
      }
      if (!mounted) return;
      if (response != null) {
        profile = Variables.returnResponse(context, response, fromSignUp: true);
      } else {
        Variables.showtoast(context, "Sign Up is not successfull", Icons.cancel_outlined);
      }
    } on SocketException catch (e) {
      Variables.showtoast(
          context, 'No Internet connection\n${e.message}', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    notifyListeners();
    if (profile != null) return profile;
  }

  Future<Map<String, dynamic>?> checkUserVerified(
      bool mounted, BuildContext context, String email, String phone) async {
    Map<String, dynamic>? map = {};
    try {
      Response? response;
      if (Variables.deviceInfo['userType'] != null) {
        var uri = Variables.uri(path: '/register/checkVerifiedUser/$email/$phone');
        response = await HTTPRequest.getRequest(uri);
      }
      if (!mounted) return null;
      if (response != null) {
        map = Variables.returnResponse(context, response);
      } else {
        Variables.showtoast(context, "Sign Up is not successfull", Icons.cancel_outlined);
      }
    } on SocketException catch (e) {
      Variables.showtoast(
          context, 'No Internet connection\n${e.message}', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    return map;
  }

  authenticateUser(bool mounted, BuildContext context, Map<String, dynamic> body) async {
    Map<String, dynamic>? map;
    try {
      body.addAll({"appVersion": "V1", "authType": "EMAIL", "loginSource": "MOBILE"});
      final response = await HTTPRequest.postRequest(Variables.uri(path: "/register/signin"), jsonEncode(body), true);
      if (!mounted) return;
      map = Variables.returnResponse(context, response);
      if (map != null) {
        Variables.token = map["accessToken"];
        userType = map["userType"];
        deviceToken = map["deviceToken"] ?? "";
        userId = map["userId"];
        Variables.driverId = userType.toLowerCase() == "driver" ? map["bikerId"] : map["customerId"];
      } else {
        Variables.token = '';
        Variables.driverId = -1;
        userType = "";
      }
    } on SocketException {
      if (!mounted) return;
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    notifyListeners();
    if (map != null) {
      return map;
    } else {
      return false;
    }
  }

  storeLoginStatus(bool value) async {
    await Variables.write(key: "islogin", value: value.toString());
    notifyListeners();
  }

  void setUserType(value) {
    userType = value;
    notifyListeners();
  }
}
