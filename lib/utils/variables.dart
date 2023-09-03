import 'dart:async';
import 'dart:convert';

import 'package:app_settings/app_settings.dart';
import 'package:ezshipp/APIs/new_orderlist.dart';
import 'package:ezshipp/APIs/update_order.dart';
import 'package:ezshipp/Provider/auth_controller.dart';
import 'package:ezshipp/Provider/customer_controller.dart';
import 'package:ezshipp/Provider/order_controller.dart';
import 'package:ezshipp/main.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart' as f;
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import '../Provider/update_profile_provider.dart';
import '../widgets/textfield.dart';

enum AlertDialogAction { cancel, save }

class Variables {
  static GlobalKey<FormState> formkey = GlobalKey<FormState>();
  static f.FToast fToast = f.FToast();
  static String token = "";
  static Map<String, String> headers = {"Content-Type": 'application/json'};
  static String locationPin = "assets/icon/icons8-location-48.png";
  static String key = "AIzaSyCuvs8lj4MQgGWE26w3twaifCgxk_Vk8Yw";
  static List menuItems = ["Recipient", "Watchman", "Receptionist", "Neighbours", "Others"];
  static String currentMenuItem = menuItems[0];
  static bool showdialog = true, isdetail = false;
  static Map<String, String?> locations = {};
  static UpdateOrder updateOrderMap = UpdateOrder.fromMap({});
  static int driverId = -1;
  static final pref = FlutterSecureStorage(aOptions: getAndroidOptions());

  static int index = 0, index2 = 0, index3 = 0;
  static String index1 = "";
  static late NewOrderList list, list1;
  static int orderscount = 0;
  static Map<String, dynamic>? responseJson;

  static bool otpNotVerified = true;

  static AndroidOptions getAndroidOptions() => const AndroidOptions(
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

  static bool internetStatus = false;
  static StreamSubscription? subscription;

  static List device = ["ANDROID", "IOS", "WEB"];
  static read({String key = ''}) async => await pref.read(key: key, aOptions: getAndroidOptions());
  static write({String key = "", String value = ""}) async =>
      await pref.write(key: key, value: value, aOptions: getAndroidOptions());
  static push(BuildContext context, String routeName) => Navigator.of(context).pushNamed(routeName);
  static pop(BuildContext context, {var value}) => Navigator.of(context).pop(value);
  static TextStyle font(
          {double fontSize = 14,
          FontWeight fontWeight = FontWeight.normal,
          Color? color = Palette.deepgrey,
          TextDecoration? decoration}) =>
      GoogleFonts.notoSans(fontSize: fontSize, color: color, fontWeight: fontWeight, decoration: decoration);
  static String urlSchema = "https";
  static String urlhost = "backendapi.ezshipp.com";
  static Uri uri({required String path, queryParameters}) {
    // Uri(
    //     scheme: "https",
    //     host: "backendapi.ezshipp.com",
    //     port: 2020,
    //     path: "/api/v1$path",
    //     queryParameters: queryParameters);
    // Uri(scheme: "http", host: "65.2.152.100", port: 2020, path: "/api/v1$path", queryParameters: queryParameters);
    return Uri(
        scheme: Variables.urlSchema,
        host: Variables.urlhost,
        port: 2020,
        path: "/api/v1$path",
        queryParameters: queryParameters);
  }

  static Widget text(BuildContext context,
          {String head = "Order ID:",
          String value = "XXXXXXXXX",
          double vpadding = 1.0,
          double hpadding = 10.0,
          Color? valueColor,
          Color? headColor,
          double valueFontSize = 16,
          double headFontSize = 14,
          bool islink = false,
          String linkvalue = ""}) =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: hpadding, vertical: vpadding),
        child: RichText(
            text: TextSpan(
                text: head,
                style: Variables.font(color: headColor ?? Palette.deepgrey, fontSize: headFontSize),
                children: [
              islink
                  ? linkvalue.isNotEmpty
                      // ? WidgetSpan(
                      //     child: GestureDetector(
                      //     onTap: () async => await showDialog(
                      //         context: context,
                      //         builder: (context) => AlertDialog(
                      //               content: Image.memory(base64Decode(linkvalue), height: 500),
                      //             )),
                      //     child: Text(
                      //       value,
                      //       style: Variables.font(fontSize: valueFontSize),
                      //     ),
                      //   ))
                      ? TextSpan(
                          text: value,
                          style: Variables.font(
                              color: Palette.kOrange, fontSize: valueFontSize, decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async => await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      content: Image.memory(base64Decode(linkvalue), height: 500),
                                    )))
                      : TextSpan(
                          text: value,
                          style: Variables.font(color: valueColor ?? Colors.grey.shade700, fontSize: valueFontSize))
                  : TextSpan(
                      text: value,
                      style: Variables.font(color: valueColor ?? Colors.grey.shade700, fontSize: valueFontSize))
            ])),
      );

  static Widget text1(
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
              children: [Text(head, style: headStyle), if (value.isNotEmpty) Text(value, style: valueStyle)]));

  static switchOptions(
          {String head = "Order ID:",
          bool value = false,
          double vpadding = 3.0,
          double hpadding = 15,
          TextStyle? headStyle,
          required void Function(bool) onChanged}) =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: hpadding, vertical: vpadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(head, style: headStyle), Switch(value: value, onChanged: onChanged)],
        ),
      );

  static AppBar app({actions, color, elevation = 3, IconThemeData? iconTheme}) => AppBar(
      elevation: elevation.toDouble(),
      actions: actions,
      backgroundColor: color,
      iconTheme: iconTheme,
      title: Image.asset(
        "assets/images/Logo.png",
        height: 40,
      ),
      centerTitle: true);

  static void showtoast(BuildContext context, String message, IconData icon, [bool shouldup = false]) async {
    Variables.fToast = f.FToast();
    Variables.fToast.init(navigatorKey.currentState!.context);
    Widget toast = newMethod(icon, message);
    f.Fluttertoast.showToast(
        msg: message,
        toastLength: f.Toast.LENGTH_LONG,
        fontSize: 14,
        backgroundColor: Colors.green,
        gravity: shouldup ? f.ToastGravity.TOP : f.ToastGravity.BOTTOM);
  }

  static Container newMethod(IconData icon, String message) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.greenAccent,
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon),
          const SizedBox(
            width: 10.0,
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Text(
              message,
              style: font(color: null),
            ),
          )
        ]));
  }

  static String datetime(value, {bool timeNeed = false}) {
    DateTime timeCurrent = DateTime.now();
    if (value.toString() != "null" && value.toString().isNotEmpty) {
      if (value is DateTime) {
        timeCurrent = value;
      } else {
        timeCurrent = DateTime.parse(value);
      }
      String time = DateFormat().add_jm().format(timeCurrent);
      String date = "${DateFormat().add_MMMd().format(timeCurrent)},${DateFormat().add_y().format(timeCurrent)}";
      if (DateTime.now() == timeCurrent) {
        return "Today, $time";
      } else if (DateTime.now().subtract(const Duration(days: 1)) == timeCurrent) {
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
      var camera = FlutterMobileVision.scan(fps: 5.0, forceCloseCameraOnTap: true);

      texts = await camera;

      for (Barcode ocr in texts) {
        return ocr.displayValue;
      }
    } catch (e) {
      controller.clear();
      Variables.showtoast(context, "No BarCode Captured", Icons.cancel_outlined);
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

  static Future<bool> getLiveLocation(BuildContext context, {int? statusId}) async {
    bool serviceEnabled;
    bool confirm = false;
    geo.LocationPermission permission;

    permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      confirm = await showLocationDialog(context);
      if (confirm) {
        permission = await geo.Geolocator.requestPermission();
        // if (permission == LocationPermission.denied) {
        //   Variables.showtoast(context,'Location permissions are denied',Icons.cancel_outlined);
        // }
      }
    }
    if (permission == geo.LocationPermission.deniedForever) {
      Variables.showtoast(context, 'Location permissions are permanently denied, we cannot request permissions.',
          Icons.cancel_outlined);
      await geo.GeolocatorPlatform.instance.openAppSettings();
    }
    serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await geo.Geolocator.openLocationSettings();
      // return Future.error('Location services are disabled.');
    }
    var bool2 = (permission == geo.LocationPermission.always || permission == geo.LocationPermission.whileInUse) &&
        serviceEnabled;
    if (bool2) {
      var currentlocation = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
      Variables.updateOrderMap.latitude = currentlocation.latitude;
      Variables.updateOrderMap.longitude = currentlocation.longitude;
      if (statusId != null) Variables.updateOrderMap.statusId = statusId;
    }
    return bool2;
  }

  static Future<bool> showLocationDialog(BuildContext context) async => (await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
            content: Stack(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  IconButton(
                      onPressed: () => Navigator.pop(context, false),
                      icon: const Icon(Icons.cancel_outlined, color: Colors.grey, size: 27),
                      splashRadius: 15)
                ]),
                Column(mainAxisSize: MainAxisSize.min, children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Image.asset("assets/images/location_marker_icon.png", height: 150, width: 200),
                  ),
                  Text("Use Your Location", style: Variables.font(fontSize: 16, fontWeight: FontWeight.bold)),
                  // Padding(
                  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
                  //     child: Column(mainAxisSize: MainAxisSize.min, children: [
                  //       Text("To see maps for automatically tracked activities.",
                  //           style: Variables.font(), textAlign: TextAlign.center),
                  //       Text("Allow EZshipp to use your location all of the time.",
                  //           style: Variables.font(), textAlign: TextAlign.center)
                  //     ])),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              "EZshipp uses your location to make your experience better. We provide maps for activity tracking and ensure seamless order delivery while respecting your privacy. ",
                              style: Variables.font(),
                              textAlign: TextAlign.center),
                          Text("Grant location access for a smoother experience.",
                              style: Variables.font(), textAlign: TextAlign.center,)
                        ],
                      )),
                ]),
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
            actionsPadding: const EdgeInsets.only(bottom: 15),
            actions: [
              SizedBox(
                height: 45,
                child: FloatingActionButton.extended(
                    heroTag: "allow_location",
                    onPressed: () => Navigator.pop(context, true),
                    label: Text("Continue", style: Variables.font(color: Palette.kOrange)),
                    backgroundColor: Palette.deepgrey),
              )
            ],
          )))!;

  static dynamic updateOrder(bool mounted, BuildContext context, int orderId, statusId,
      [bool iscustomer = false]) async {
    UpdateProfileProvider value = Provider.of<UpdateProfileProvider>(context, listen: false);
    OrderController value1 = Provider.of<OrderController>(context, listen: false);
    CustomerController value2 = Provider.of<CustomerController>(context, listen: false);
    await Variables.getLiveLocation(context, statusId: statusId);
    Map body = {
      "latitude": Variables.updateOrderMap.latitude,
      "longitude": Variables.updateOrderMap.longitude,
      "orderId": orderId
    };
    // print(jsonEncode(body));
    // var temp = value.newOrderList[index];
    // print("${temp.pickLatitude} ${temp.pickLongitude}   ${temp.dropLatitude} ${temp.dropLongitude}");
    loadingDialogue(context: context, subHeading: "Please wait ...");
    if (!mounted) return;
    if (!iscustomer) {
      var result = await value.getDistance(mounted, context, jsonEncode(body));
      if (result != null) {
        Variables.updateOrderMap.distance = result;
        Variables.updateOrderMap.driverId = driverId;
        Variables.updateOrderMap.newDriverId = driverId;
        if (!mounted) return;
        responseJson = await value1.updateOrder(mounted, context, Variables.updateOrderMap.toJson(), orderId);
        if (!mounted) return;
        Navigator.pop(context);
      }
    } else {
      Variables.updateOrderMap.distance = value2.customerOrders[Variables.index].distance;
      if (!mounted) return;
      responseJson = await value1.updateOrder(mounted, context, Variables.updateOrderMap.toJson(), orderId);
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  static returnResponse(BuildContext context, Response response, {onlinemode = false, bool fromSignUp = false}) {
    var responseJson = onlinemode ? response.body : json.decode(response.body);
    switch (response.statusCode) {
      case 200:
      case 201:
        return responseJson;
      case 400:
      case 401:
      case 403:
        if (responseJson["error"] == "Unauthorized") {
          Variables.showtoast(context, "${responseJson["error"]} account.", Icons.warning_rounded);
        } else {
          Variables.showtoast(context, "${responseJson["status"]}: ${responseJson["error"]}", Icons.warning_rounded);
        }
        break;
      case 500:
      default:
        if (responseJson["message"] == null) {
          if (!fromSignUp) {
            Variables.showtoast(
                context,
                'Error occured while Communication with Server with StatusCode : ${response.statusCode}',
                Icons.warning_rounded);
          } else {
            Variables.showtoast(context, "User doen't exist to reset Password", Icons.warning_amber_rounded);
          }
        } else {
          String message = "";
          switch (responseJson["message"]) {
            /** user already exists error. */
            case "100":
              message = "User already existed";
              break;
            /** user already exists error. */
            case "103":
              message = "This mobile number is already registered";
              break;
            /** email already exists error. */
            case "101":
              message = "This email address is already registered";
              break;
            case "105":
              Variables.otpNotVerified = true;
              break;
          }

          // if (message.isNotEmpty) Variables.showtoast(context, 'Server Error: $message', Icons.warning_rounded);
        }
        break;
    }
  }

  static OverlaySupportEntry overlayNotification() =>
      showSimpleNotification(Text("No Internet Connection", style: font(color: Colors.white, fontSize: 18)),
          background: Colors.red);

  static Padding dividerName(String name, {double hpadding = 10, double vpadding = 15}) => Padding(
        padding: EdgeInsets.symmetric(vertical: vpadding, horizontal: hpadding),
        child: Row(children: [
          const Flexible(
              fit: FlexFit.tight,
              child: Divider(
                indent: 10,
                endIndent: 10,
                thickness: 2,
              )),
          Text(
            name,
            style: Variables.font(fontSize: 15, color: Colors.grey),
          ),
          const Flexible(
              fit: FlexFit.tight,
              child: Divider(
                indent: 10,
                endIndent: 10,
                thickness: 2,
              )),
        ]),
      );

  static Future<void> writeDetails(BuildContext context) async {
    AuthController authController = Provider.of<AuthController>(context, listen: false);
    await Variables.write(key: "username", value: TextFields.data["Email id"].toString());
    await Variables.write(key: "password", value: TextFields.data["Password"].toString());
    await Variables.write(key: "usertype", value: authController.userType);
    await Variables.write(key: "mobileSignUp", value: true.toString());
    if (authController.userType == "driver") {
      await Variables.write(key: "enterKYC", value: true.toString());
    } else {
      await Variables.write(key: "enterKYC", value: false.toString());
    }
  }

  static Future<Object> loadingDialogue({
    BuildContext? context,
    String subHeading = "Please wait...",
  }) async {
    Future? action = await showDialog(
        context: context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Row(
              children: [
                const SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator.adaptive(
                    valueColor: AlwaysStoppedAnimation<Color>(Palette.kOrange),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  subHeading,
                  style: Variables.font(color: Palette.deepgrey),
                )
              ],
            ),
          );
        });
    // ignore: unnecessary_null_comparison
    if ((action != null)) {
      return action;
    } else {
      return AlertDialogAction.cancel;
    }
  }

  static String statusCode(int statusID) {
    switch (statusID) {
      case 3:
        return "Start";
      case 4:
        return "At Pickup";
      case 5:
        return "Pick";
      case 6:
        return "Start";
      case 9:
        return "At Delivery";
      case 11:
        return "Complete";
      default:
        return "";
    }
  }

  static void enalbeLocation() async {
    var location = Location();
    bool ison = await location.serviceEnabled();
    if (!ison) {
      bool turnon = await location.requestService();
      if (!turnon) {
        await AppSettings.openLocationSettings();
      }
    }
  }
}
