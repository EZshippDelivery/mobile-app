import 'dart:developer';

import 'package:ezshipp/utils/variables.dart';
import 'package:http/http.dart';

class HTTPRequest {
  static Map<String, String> headers = {"Authorization": Variables.token};
  static Future<Response> getRequest(Uri uri) async {
    return await get(uri, headers: headers);
  }

  static Future<Response> postRequest(Uri uri, body, [bool issignup = false]) async {
    log(uri.toString(), name: "URI");
    headers.addAll(Variables.headers);
    return await post(uri, body: body, headers: issignup ? Variables.headers : headers);
  }

// "https://backendapi.exshipp.com:2020//register/signin"
  static Future<Response> putRequest(Uri uri, body) async {
    headers.addAll(Variables.headers);
    return await put(uri, body: body, headers: headers);
  }
}
