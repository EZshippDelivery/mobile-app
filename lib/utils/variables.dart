import 'dart:async';
import 'dart:convert';

import 'package:ezshipp/APIs/update_order.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';

import '../Provider/update_order_povider.dart';

class Variables {
  static GlobalKey<FormState> formkey = GlobalKey<FormState>();
  static String token = "";
  static Map<String, String> headers = {"Content-Type": 'application/json'};
  static String locationPin = "assets/icon/icons8-location-48.png";
  static String key = "AIzaSyCuvs8lj4MQgGWE26w3twaifCgxk_Vk8Yw";
  static List menuItems = ["Recipient", "Watchman", "Receptionist", "Neighbours", "Others"];
  static String currentMenuItem = menuItems[0];
  static bool showdialog = true;
  static Map<String, String?> locations = {};
  static UpdateOrder updateOrderMap = UpdateOrder.fromMap({});
  static int driverId = 18;
  static final pref = FlutterSecureStorage(aOptions: _getAndroidOptions());
  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  static String referalCode = "";
  static String subject = "EZShipp - A Fastest Delivery App";
  static String sendText =
      "Hello there,\n How are you?\n I have an ezshipp Coupon.\nSign up with my code $referalCode to avail the coupon with suprising discount. Download app with this link:";
  static String urlShare = "https://www.ezshipp.com/share.html";
  static Map share = {
    "Facebook": ["https://www.facebook.com/share/sharer.php?u=$urlShare&t=$sendText", "assets/icon/share/fb1.png"],
    "Message": [
      Uri(scheme: "sms", queryParameters: {"body": sendText}).toString(),
      "assets/icon/share/sms.png"
    ],
    "Twitter": ["https://twitter.com/intent/tweet?url=$urlShare&text=$sendText", "assets/icon/share/twitter.png"],
    "Whatsapp": ["https://api.whatsapp.com/send?text=$sendText\n$urlShare", "assets/icon/share/whatsapp.png"],
    "Gmail": [
      Uri(scheme: "mailto", queryParameters: {"subject": subject, "body": "$sendText\n$urlShare"}).toString(),
      "assets/icon/share/Gmail_round-384x384.png"
    ],
  };
  static Map<String, String> deviceInfo = {
    'deviceId': "",
    'deviceMake': "",
    'deviceModel': "",
    'deviceToken': "",
    'deviceType': "",
    'os': "",
    'userType': ""
  };

  static List centers = [
    ["Hitech City", "Office", false],
    ["Mehdipatnam", "Mehdipatnam Bus Stop", false],
    ["Dilsukhnagar", "LB Nagar Bus Stop", false],
    ["Charminar", "Charminar", false],
    ["Secunderabad", "Jublee Bus Stop", false],
    ["Khairatabad", "GCK", false],
    ["Balanagar", "Y Junction", false],
    ["Uppal", "Uppal Junction", false]
  ];
  static List cancelReasons = [
    [1, 'Entered wrong address', 0, 0],
    [2, 'Package is not ready to pickup', 0, 1],
    [3, 'Customer not available at destination', 0, 1],
    [4, 'Other Reason', 0, 0],
    [5, 'Ezshipp cannot deliver after hours', 0, 0],
    [6, 'Heavy Items', 0, 1],
    [7, "Customer Rejected", 0, 0]
  ];

  static InternetConnectionStatus internetStatus = InternetConnectionStatus.disconnected;

  static List device = ["ANDROID", "IOS", "WEB"];
  static read({String key = ''}) async => await pref.read(key: key, aOptions: _getAndroidOptions());
  static write({String key = "", String value = ""}) async =>
      await pref.write(key: key, value: value, aOptions: _getAndroidOptions());
  static push(BuildContext context, Widget route) => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => route,
      ));
  static pop(BuildContext context, {var value}) => Navigator.of(context).pop(value);
  static TextStyle font(
          {double fontSize = 14, FontWeight fontWeight = FontWeight.normal, Color? color = Palette.deepgrey}) =>
      GoogleFonts.notoSans(fontSize: fontSize, color: color, fontWeight: fontWeight);
  static Uri uri({required String path, queryParameters}) =>
      Uri(scheme: "http", host: "65.2.152.100", port: 2020, path: "/api/v1" + path, queryParameters: queryParameters);

  static text(
          {String head = "Order ID:",
          String value = "XXXXXXXXX",
          double vpadding = 1.0,
          double hpadding = 10.0,
          Color? valueColor,
          Color? headColor,
          double valueFontSize = 16,
          double headFontSize = 14}) =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: hpadding, vertical: vpadding),
        child: RichText(
            text: TextSpan(
                text: head,
                style: Variables.font(color: headColor ?? Palette.deepgrey, fontSize: headFontSize),
                children: [
              TextSpan(
                  text: value,
                  style: Variables.font(color: valueColor ?? Colors.grey.shade700, fontSize: valueFontSize))
            ])),
      );
  static text1(
          {String head = "Order ID:",
          String value = "XXXXXXXXX",
          double vpadding = 3.0,
          double hpadding = 15,
          TextStyle? headStyle,
          TextStyle? valueStyle}) =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: hpadding, vertical: vpadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(head, style: headStyle), if (value.isNotEmpty) Text(value, style: valueStyle)],
        ),
      );

  static AppBar app({actions, color, elevation = 3}) => AppBar(
      elevation: elevation.toDouble(),
      actions: actions,
      backgroundColor: color,
      title: Image.asset(
        "assets/images/Logo.png",
        height: 40,
      ),
      centerTitle: true);

  static void showtoast(String message, {int time = 1}) {
    Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: time,
        textColor: Colors.white,
        backgroundColor: Colors.black54);
  }

  static String datetime(value, {bool timeNeed = false}) {
    DateTime _time = DateTime.now();
    if (value.toString() != "null" && value.toString().isNotEmpty) {
      if (value is DateTime) {
        _time = value;
      } else {
        _time = DateTime.parse(value);
      }
      String time = DateFormat().add_jm().format(_time);
      String date = DateFormat().add_MMMd().format(_time) + "," + DateFormat().add_y().format(_time);
      if (DateTime.now() == _time) {
        return "Today, $time";
      } else if (DateTime.now().subtract(const Duration(days: 1)) == _time) {
        return "Yesterday, $time";
      }
      if (timeNeed) return "$date | $time";
      return date;
    }
    return "";
  }

  static Future<String> scantext(BuildContext context, TextEditingController controller,
      {bool fromhomepage = false}) async {
    List<Barcode> texts = [];
    try {
      var camera = FlutterMobileVision.scan(fps: 5.0, forceCloseCameraOnTap: true, waitTap: true);

      texts = await camera;

      for (Barcode ocr in texts) {
        return ocr.displayValue;
      }
    } catch (e) {
      controller.clear();
      Variables.showtoast("No BarCode Captured");
      return await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => AlertDialog(
                    title: Text("Alert!", style: Variables.font(fontSize: 18)),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Enter BarCode manually',
                            style: Variables.font(fontSize: 15, color: Colors.grey), textAlign: TextAlign.center),
                        const SizedBox(height: 10),
                        Form(
                            key: formkey,
                            child: TextFormField(
                                controller: controller,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value != null) {
                                    if (value.isEmpty) {
                                      return "Enter Barcode";
                                    } else if (value.length < 6) {
                                      return "Enter valid Barcode";
                                    }
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: "Barcode",
                                    hintText: "Enter 6 digits Barcode",
                                    contentPadding: EdgeInsets.zero)))
                      ],
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(25, 20, 25, 5),
                    actionsAlignment: MainAxisAlignment.center,
                    actions: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                          onPressed: () {
                            if (formkey.currentState!.validate()) {
                              Variables.pop(context, value: controller.text);
                            }
                          },
                          child: const Icon(Icons.keyboard_arrow_right))
                    ],
                  )) ??
          "";
    }
    return "";
  }

  static Future<void> getLiveLocation({int? statusId}) async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    var currentlocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    Variables.updateOrderMap.latitude = currentlocation.latitude;
    Variables.updateOrderMap.longitude = currentlocation.longitude;
    if (statusId != null) Variables.updateOrderMap.statusId = statusId;
  }

  static Future<void> updateOrder(UpdateOrderProvider value, int index, statusId) async {
    await Variables.getLiveLocation(statusId: statusId);
    Map body = {
      "latitude": Variables.updateOrderMap.latitude,
      "longitude": Variables.updateOrderMap.longitude,
      "orderId": statusId > 3 && statusId < 13 ? value.acceptedList[index].id : value.newOrderList[index].id
    };
    // print(jsonEncode(body));
    // var temp = value.newOrderList[index];
    // print("${temp.pickLatitude} ${temp.pickLongitude}   ${temp.dropLatitude} ${temp.dropLongitude}");
    var result = await value.getDistance(jsonEncode(body));
    if (result != null) {
      Variables.updateOrderMap.distance = result;
      Variables.updateOrderMap.driverId = driverId;
      Variables.updateOrderMap.newDriverId = driverId;
      value.update(Variables.updateOrderMap.toJson(), value.newOrderList[index].id);
    }
  }

  static returnResponse(Response response, {onlinemode = false}) {
    switch (response.statusCode) {
      case 200:
        var responseJson = onlinemode ? response.body : json.decode(response.body);
        return responseJson;
      case 400:
        Variables.showtoast(response.body.toString());
        break;
      case 401:
      case 403:
        Variables.showtoast(response.body.toString());
        break;
      case 500:
      default:
        Variables.showtoast('Error occured while Communication with Server with StatusCode : ${response.statusCode}');
        break;
    }
  }

  static OverlaySupportEntry overlayNotification() =>
      showSimpleNotification(Text("No Internet Connection", style: font(color: Colors.white, fontSize: 18)),
          background: Colors.red);

  static Padding dividerName(String name, {double hpadding = 10, double vpadding = 15}) => Padding(
        padding: EdgeInsets.symmetric(vertical: vpadding, horizontal: hpadding),
        child: Row(children: [
          const Expanded(
              child: Divider(
            indent: 10,
            endIndent: 10,
            thickness: 2,
          )),
          Text(
            name,
            style: Variables.font(fontSize: 15, color: Colors.grey),
          ),
          const Expanded(
              child: Divider(
            indent: 10,
            endIndent: 10,
            thickness: 2,
          )),
        ]),
      );
}
