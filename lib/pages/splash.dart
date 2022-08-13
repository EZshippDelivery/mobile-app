import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:device_info/device_info.dart';
import 'package:ezshipp/Provider/auth_controller.dart';
import 'package:ezshipp/pages/biker/enter_kycpage.dart';
import 'package:ezshipp/pages/customer/customer_homepage.dart';
import 'package:ezshipp/utils/routes.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'biker/rider_homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController animcontroller;
  late Animation<double> _anim;
  late FirebaseMessaging _messaging;

  late AuthController authController;
  List types = ["Delivery Person", "Customer"];

  void registerNotification() async {
    // 1. Initialize the Firebase app

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      // TODO: handle the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
      });
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    } else {
      print('User declined or has not accepted permission');
    }
  }

  settimer() async {
    await Variables.read(key: "color_index") == null
        ? Variables.write(key: "color_index", value: Random().nextInt(Colors.primaries.length).toString())
        : null;

    final login = await Variables.read(key: "islogin");
    bool islogin = login != null ? login.toLowerCase() == "true" : false;
    final kyc = await Variables.read(key: "enterKYC");
    final enterKYC = kyc == null ? false : kyc.toLowerCase() == "true";
    String userType = "";
    if (islogin) {
      final username = await Variables.read(key: "username") ?? "";
      final password = await Variables.read(key: "password") ?? "";
      if (!mounted) return;
      if (username.isNotEmpty && password.isNotEmpty) {
        islogin = await authController.authenticateUser(mounted, context, {"password": password, "username": username});
      } else {
        islogin = false;
      }
      userType = await Variables.read(key: "usertype") ?? "";
    }
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            islogin
                ? userType.toLowerCase() == "driver"
                    ? enterKYC
                        ? MaterialPageRoute(builder: (context) => EnterKYC())
                        : MaterialPageRoute(builder: (context) => const HomePage())
                    : MaterialPageRoute(builder: (context) => const CustomerHomePage())
                : MyRoutes.routelogin()));
  }

  @override
  initState() {
    super.initState();
    registerNotification();
    authController = Provider.of<AuthController>(context, listen: false);
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
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');
      Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (route) => false);
    });

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    final downloadPath = await getExternalStorageDirectory();
    File token = File("${downloadPath!.path}/token.txt");
    token.createSync();

    debugPrint('User granted permission: ${settings.authorizationStatus}');
    try {
      if (Platform.isAndroid) {
        deviceData = await _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = await _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
      token.writeAsStringSync("${deviceData["deviceToken"]}\n\n");
      debugPrint(deviceData["deviceToken"]);
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
      'OS': "android",
      "deviceType": "ANDROID",
      "deviceToken": await _messaging.getToken() ?? "",
      "userType": "DRIVER"
    };
  }

  Future<Map<String, String>> _readIosDeviceInfo(IosDeviceInfo data) async {
    return <String, String>{
      'deviceType': "IOS",
      'OS': "IOS",
      'deviceModel': data.model,
      'deviceId': data.identifierForVendor,
      'deviceMake:': data.utsname.machine,
      "deviceToken": await _messaging.getToken() ?? "",
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
