import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:ezshipp/Provider/auth_controller.dart';
import 'package:ezshipp/main.dart';
import 'package:ezshipp/pages/biker/enter_kycpage.dart';
import 'package:ezshipp/pages/customer/customer_homepage.dart';
import 'package:ezshipp/utils/notification_service.dart';
import 'package:ezshipp/utils/routes.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

import 'biker/rider_homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController animcontroller;
  late Animation<double> _anim;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  late NotificationService notificationService;
  final SimpleConnectionChecker _simpleConnectionChecker = SimpleConnectionChecker()..setLookUpAddress('pub.dev');
  late AuthController authController;
  List types = ["Delivery Person", "Customer"];

  void registerNotification() async {
    // 1. Initialize the Firebase app

    // 2. Instantiate Firebase Messaging

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      FirebaseMessaging.onMessage.listen((message) async {
        debugPrint("Got some notification");
        debugPrint("Messsage data: ${message.data}");
        if (message.notification != null) {
          await notificationService.showNotifications(0, message.notification!.title!, message.notification!.body!);
        }
      });
    } else {
      debugPrint('User declined or has not accepted permission');
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
        var login =
            await authController.authenticateUser(mounted, context, {"password": password, "username": username});
        if (login is Map<String, dynamic>?) {
          islogin = login!["userType"].toLowerCase() == 'driver' ? true : login["otpVerified"];
        } else {
          islogin = login;
        }
      } else {
        islogin = false;
      }
      if (islogin) {
        if (authController.deviceToken != Variables.deviceInfo["deviceToken"]) {
          if (!mounted) return false;
          await authController.tokenUpdate(mounted, context);
        }
      }
      userType = await Variables.read(key: "usertype") ?? "";
    }
    if (await Permission.location.isGranted) Variables.enalbeLocation();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            islogin
                ? userType.toLowerCase() == "driver"
                    ? enterKYC
                        ? MaterialPageRoute(builder: (context) => const EnterKYC())
                        : MaterialPageRoute(builder: (context) => const HomePage())
                    : MaterialPageRoute(builder: (context) => const CustomerHomePage())
                : MyRoutes.routelogin()));
  }

  @override
  initState() {
    super.initState();
    Variables.fToast = FToast();
    
    notificationService = NotificationService(context);
    registerNotification();
    authController = Provider.of<AuthController>(context, listen: false);
    animcontroller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _anim = Tween(begin: 0.0, end: 1.0).animate(animcontroller);
    CurvedAnimation(curve: Curves.fastOutSlowIn, parent: animcontroller);
    animcontroller.forward();
    initPlatformState();
    // setlogin();
    subscribe();
    settimer();
  }

  subscribe() {
    Variables.subscription = _simpleConnectionChecker.onConnectionChange.listen((event) async {
      Variables.internetStatus = event;
      if (!event) {
        Variables.overlayNotification();
      }
    });
  }

  Future<void> initPlatformState() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, String>? deviceData = <String, String>{};

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      debugPrint('A new onMessageOpenedApp event was published!');
      final login = await Variables.read(key: "islogin");
      if (login == "true") {
        Navigator.pushNamedAndRemoveUntil(navigatorKey.currentContext!, HomePage.routeName, (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(navigatorKey.currentContext!, MyRoutes.routelogin(), (route) => false);
      }
    });

    final downloadPath = await getApplicationDocumentsDirectory();
    File token = File("${downloadPath.path}/token.txt");
    token.createSync();

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
      'deviceMake': build.manufacturer!,
      'deviceModel': build.model!,
      'deviceId': build.id!,
      'OS': "android",
      "deviceType": "ANDROID",
      "deviceToken": await messaging.getToken() ?? "",
      "userType": "DRIVER"
    };
  }

  Future<Map<String, String>> _readIosDeviceInfo(IosDeviceInfo data) async {
    return <String, String>{
      'deviceType': "IOS",
      'OS': "IOS",
      'deviceModel': data.model!,
      'deviceId': data.identifierForVendor!,
      'deviceMake:': data.utsname.machine!,
      "deviceToken": await messaging.getToken() ?? "",
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
