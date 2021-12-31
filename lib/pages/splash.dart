import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:device_info/device_info.dart';
import 'package:ezshipp/pages/customer_homepage.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ezshipp/utils/routes.dart';
import 'package:ezshipp/utils/themes.dart';

import 'homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController animcontroller;
  late Animation _anim;
  FirebaseMessaging fcm = FirebaseMessaging.instance;
  List types = ["Delivery Person", "Customer"];

  settimer() async {
    var pref = await SharedPreferences.getInstance();
    pref.setInt("color_index", Random().nextInt(Colors.primaries.length));
    pref.setString("username1", "9652638197");
    pref.setString("password1", "Pradeep@2765");
    pref.setString("usertype1", "driver");
    pref.setString("username2", "8885858583");
    pref.setString("password2", "Hitesh&6999");
    pref.setString("usertype2", "customer");
    bool islogin = pref.getBool("islogin") ?? false;
    String userType = "";
    if (islogin) {
      List type = pref.getStringList("usertype") ?? ["driver"];
      userType = type.isNotEmpty ? type[pref.getInt("type-index") ?? 0] : "driver";
    }
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            islogin
                ? userType != "driver"
                    ? MaterialPageRoute(builder: (context) => const HomePage())
                    : MaterialPageRoute(builder: (context) => const CustomerHomePage())
                : MyRoutes.routelogin()));
  }

  @override
  initState() {
    super.initState();
    animcontroller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _anim = Tween(begin: 0.0, end: 1.0).animate(animcontroller);
    CurvedAnimation(curve: Curves.fastOutSlowIn, parent: animcontroller);
    animcontroller.addListener(() => setState(() {}));
    animcontroller.forward();
    initPlatformState();
    setlogin();
    settimer();
    Variables.getLiveLocation();
  }

  Future<void> initPlatformState() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, String>? deviceData = <String, String>{};
    try {
      if (Platform.isAndroid) {
        deviceData = await _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = await _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, String>{'Error:': 'Failed to get platform version.'};
    }

    if (!mounted) return;

    setState(() {
      Variables.deviceInfo = deviceData!;
    });
  }

  Future<Map<String, String>> _readAndroidBuildData(AndroidDeviceInfo build) async {
    return <String, String>{
      'deviceMake': build.manufacturer,
      'deviceModel': build.model,
      'deviceId': build.androidId,
      'OS': build.version.baseOS!.isEmpty ? "android" : build.version.baseOS ?? "android",
      "deviceType": "ANDROID",
      "deviceToken": await fcm.getToken() ?? "",
      "userType": "DRIVER"
    };
  }

  Future<Map<String, String>> _readIosDeviceInfo(IosDeviceInfo data) async {
    return <String, String>{
      'deviceType': "IOS",
      'OS': data.systemName.isEmpty ? 'ios' : data.systemName,
      'deviceModel': data.model,
      'deviceId': data.identifierForVendor,
      'deviceMake:': data.utsname.machine,
      "deviceToken": await fcm.getToken() ?? "",
      "userType": "DRIVER"
    };
  }

  @override
  Widget build(BuildContext context) {
    // animcontroller.forward();
    return Material(
        color: Palette.kOrange,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) => Stack(children: [
            Center(
              child: Image.asset(
                "assets/images/Bike-Anim.gif",
              ),
            ),
            Positioned(
                top: (constraints.maxHeight - 60.0) * (0.15),
                left: (constraints.maxWidth - 200) * 0.5,
                height: 60,
                child: Opacity(opacity: _anim.value, child: Image.asset("assets/images/Logo-Light.png"))),
          ]),
        ));
  }

  Future<void> setlogin() async {
    var pref = await SharedPreferences.getInstance();
    pref.setBool("islogin", false);
  }

  @override
  void dispose() {
    animcontroller.dispose();
    super.dispose();
  }
}
