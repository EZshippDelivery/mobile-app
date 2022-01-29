import 'package:ezshipp/utils/variables.dart';
import 'package:http/http.dart';

class HTTPRequest {
  static Future<Response> getRequest(Uri uri) async {
    Map<String, String> headers = {"Authorization":Variables.token};
    return await get(uri, headers: headers);
  }

  static Future<Response> postRequest(Uri uri, body) async {
    Map<String, String> headers = {"Authorization":Variables.token};
    headers.addAll(Variables.headers);
    return await post(uri, body: body, headers: headers);
  }
  static Future<Response> putRequest(Uri uri, body) async {
    Map<String, String> headers = {"Authorization":Variables.token};
    headers.addAll(Variables.headers);
    return await post(uri, body: body, headers: headers);
  }
}
