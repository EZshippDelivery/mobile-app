import 'dart:convert';
import 'dart:io';

import 'package:ezshipp/utils/http_requests.dart';
import 'package:flutter/material.dart';
import 'package:ezshipp/utils/variables.dart';

class UserController extends ChangeNotifier {
  String deviceToken = "";
  int userId = 0;
  tokenUpdate(bool mounted, BuildContext context) async {
    try {
      Map<String, dynamic> body = {
        "deviceId": Variables.deviceInfo['deviceId'],
        "deviceMake": Variables.deviceInfo['deviceMake'],
        "deviceModel": Variables.deviceInfo['deviceModel'],
        "deviceToken": Variables.deviceInfo['deviceToken'],
        "deviceType": Variables.deviceInfo["deviceType"],
        "os": Variables.deviceInfo['OS'],
        "userId": userId
      };
      var uri = Variables.uri(path: '/users/tokenUpdate');
      final response = await HTTPRequest.putRequest(uri, jsonEncode(body));
      if (!mounted) return;
      if (response != null) {
        Variables.returnResponse(context, response);
      } else {
        Variables.showtoast(context, "Sign Up is not successfull", Icons.cancel_outlined);
      }
    } on SocketException catch (e) {
      Variables.showtoast(
          context, 'No Internet connection\n${e.message}', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
  }
}
