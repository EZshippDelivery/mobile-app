// ignore_for_file: unused_import

import 'package:ezshipp/Provider/get_addresses_provider.dart';
import 'package:ezshipp/Provider/maps_provider.dart';
import 'package:ezshipp/Provider/update_order_povider.dart';
import 'package:ezshipp/Provider/update_profile_provider.dart';
import 'package:ezshipp/pages/book_orderpage.dart';
import 'package:ezshipp/pages/customer_homepage.dart';
import 'package:ezshipp/pages/deliver_page.dart';
import 'package:ezshipp/pages/enter_kycpage.dart';
import 'package:ezshipp/pages/homepage.dart';
import 'package:ezshipp/pages/loginpage.dart';
import 'package:ezshipp/pages/splash.dart';
// import 'package:ezshipp/pages/splash.dart';
import 'package:ezshipp/utils/routes.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Provider/update_login_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<UpdateOrderProvider>(create: (context) => UpdateOrderProvider()),
      ChangeNotifierProvider<UpdateLoginProvider>(create: (context) => UpdateLoginProvider()),
      ChangeNotifierProvider<UpdateProfileProvider>(create: (context) => UpdateProfileProvider()),
      ChangeNotifierProvider<MapsProvider>(create: (context) => MapsProvider()),
      ChangeNotifierProvider<GetAddressesProvider>(create: (context) => GetAddressesProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: MyTheme.lighttheme(context),
      home: const SplashScreen(),
      routes: {
        MyRoutes.homepage: (context) => const HomePage(),
        MyRoutes.loginpage: (context) => const LoginPage(),
      },
    );
  }
}
