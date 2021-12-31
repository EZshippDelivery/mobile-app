import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/variables.dart';

class UpdateLoginProvider extends ChangeNotifier {
  String userType = "driver";
  Map? profile;


  httpost(context, body) async {
    try {
      Response? response;
      var uri = Variables.uri(path: '/register/${Variables.deviceInfo['userType']!.toLowerCase()}');
      if (Variables.deviceInfo['userType'] != null) {
        response = await post(uri, headers: Variables.headers, body: body);
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
      final response =
          await post(Variables.uri(path: "/customer/otp/generate"), body: body, headers: Variables.headers);
      var responseJson = Variables.returnResponse(response);
      if(responseJson!=null) Variables.showtoast("OTP send");
    } on SocketException {
      Variables.showtoast('No Internet connection');
    }
  }

  verifyOTP(body) async {
    Map? responseJson;
    try {
      final response = await get(Variables.uri(path: "/customer/otp/validate", queryParameters: body as Map<String, dynamic>));
      responseJson = Variables.returnResponse(response);
    } on SocketException {
      Variables.showtoast('No Internet connection');
    }
    return responseJson;
  }

  store() async {
    var pref = await SharedPreferences.getInstance();
    pref.setBool("islogin", true);
    notifyListeners();
  }

  void setUsetType(value) {
    userType = value;
    notifyListeners();
  }
}
