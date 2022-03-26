import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:device_info/device_info.dart';
import 'package:ezshipp/Provider/update_login_provider.dart';
import 'package:ezshipp/pages/customer_homepage.dart';
import 'package:ezshipp/utils/routes.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController animcontroller;
  late Animation<double> _anim;
  FirebaseMessaging fcm = FirebaseMessaging.instance;
  late UpdateLoginProvider updateLoginProvider;
  List types = ["Delivery Person", "Customer"];

  settimer() async {
    await Variables.read(key: "color_index") == null
        ? Variables.write(key: "color_index", value: Random().nextInt(Colors.primaries.length).toString())
        : null;

    final login = await Variables.read(key: "islogin");
    bool islogin = login != null ? login.toLowerCase() == "true" : false;
    String userType = "";
    if (islogin) {
      final username = await Variables.read(key: "username");
      final password = await Variables.read(key: "password");
      await updateLoginProvider.login(context,{"password": password, "username": username});
      userType = await Variables.read(key: "usertype")?? "";
    }
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            islogin
                ? userType.toLowerCase() == "driver"
                    ? MaterialPageRoute(builder: (context) => const HomePage())
                    : MaterialPageRoute(builder: (context) => const CustomerHomePage())
                : MyRoutes.routelogin()));
  }

  @override
  initState() {
    super.initState();
    updateLoginProvider = Provider.of<UpdateLoginProvider>(context, listen: false);
    animcontroller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _anim = Tween(begin: 0.0, end: 1.0).animate(animcontroller);
    CurvedAnimation(curve: Curves.fastOutSlowIn, parent: animcontroller);
    animcontroller.forward();
    initPlatformState();
    // setlogin();
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

    Variables.deviceInfo = deviceData;
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
                child: FadeTransition(opacity: _anim, child: Image.asset("assets/images/Logo-Light.png"))),
          ]),
        ));
  }

  Future<void> setlogin() async {
    await Variables.write(key: "islogin", value: false.toString());
  }

  @override
  void dispose() {
    animcontroller.dispose();
    super.dispose();
  }
}
