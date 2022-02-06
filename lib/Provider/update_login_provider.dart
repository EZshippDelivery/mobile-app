import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../utils/http_requests.dart';
import '../utils/variables.dart';

class UpdateLoginProvider extends ChangeNotifier {
  String userType = "driver";
  Map? profile;

  httpost(context, body) async {
    try {
      Response? response;
      var uri = Variables.uri(path: '/register/${Variables.deviceInfo['userType']!.toLowerCase()}');
      if (Variables.deviceInfo['userType'] != null) {
        response = await HTTPRequest.postRequest(uri, body);
      }
      if (response != null) {
        profile = Variables.returnResponse(response);
      } else {
        Variables.showtoast("Sign Up is not successfull");
      }
    } on SocketException {
      Variables.showtoast('No Internet connection');
    }
    notifyListeners();
    if (profile != null) return profile;
  }

  getOTP(body) async {
    try {
      final response = await HTTPRequest.postRequest(Variables.uri(path: "/customer/otp/generate"), body);
      var responseJson = Variables.returnResponse(response);
      if (responseJson != null) Variables.showtoast("OTP send");
    } on SocketException {
      Variables.showtoast('No Internet connection');
    }
  }

  verifyOTP(body) async {
    Map? responseJson;
    try {
      final response = await HTTPRequest.getRequest(
          Variables.uri(path: "/customer/otp/validate", queryParameters: body as Map<String, dynamic>));
      responseJson = Variables.returnResponse(response);
    } on SocketException {
      Variables.showtoast('No Internet connection');
    }
    return responseJson;
  }

  store() async {
    await Variables.write(key: "islogin", value: true.toString());
    notifyListeners();
  }

  void setUsetType(value) {
    userType = value;
    notifyListeners();
  }

  login(String body) async {
    try {
      final response = await HTTPRequest.postRequest(Variables.uri(path: "/register/signin"), body);
      Map<String, dynamic>? map = Variables.returnResponse(response);
      if (map != null) {
        Variables.token = map["accessToken"];
        Variables.driverId = map["userId"];
        userType = map["userType"];
      }
    } on SocketException {
      Variables.showtoast('No Internet connection');
    }
    notifyListeners();
  }
}
