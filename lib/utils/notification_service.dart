import 'package:ezshipp/main.dart';
import 'package:ezshipp/pages/biker/rider_homepage.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  late AndroidInitializationSettings androidInitializationSettings;
  late IOSInitializationSettings iosInitializationSettings;
  late InitializationSettings initializationSettings;
  late BuildContext context;

  NotificationService(this.context) {
    androidInitializationSettings = const AndroidInitializationSettings("@mipmap/launcher_icon");
    iosInitializationSettings = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
          // didReceiveLocalNotificationSubject.add(ReceivedNotification(
          //     id: id, title: title, body: body, payload: payload));
        });
    initializationSettings =
        InitializationSettings(android: androidInitializationSettings, iOS: iosInitializationSettings);
    initializeNotification();
  }

  void initializeNotification([mounted = true]) async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (payload) async {
      String userType = await Variables.read(key: "usertype");
      if (userType.toLowerCase() == 'driver') {
        if (!mounted) return;
        navigatorKey.currentState!.pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
      }
    });
  }

  Future<void> showNotifications(int id, String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails("channelId", 'channelName',
        importance: Importance.max, priority: Priority.high);
    IOSNotificationDetails iosNotificationDetails = const IOSNotificationDetails();
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(id, title, body, notificationDetails);
  }
}
