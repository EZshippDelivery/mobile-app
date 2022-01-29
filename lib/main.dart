import 'package:ezshipp/Provider/get_addresses_provider.dart';
import 'package:ezshipp/Provider/maps_provider.dart';
import 'package:ezshipp/Provider/update_order_povider.dart';
import 'package:ezshipp/Provider/update_profile_provider.dart';
import 'package:ezshipp/Provider/update_screenprovider.dart';
import 'package:ezshipp/pages/homepage.dart';
import 'package:ezshipp/pages/loginpage.dart';
import 'package:ezshipp/pages/splash.dart';
import 'package:ezshipp/utils/routes.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
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
      ChangeNotifierProvider<GetAddressesProvider>(create: (context) => GetAddressesProvider()),
      ChangeNotifierProvider<UpdateScreenProvider>(create: (context) => UpdateScreenProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EZShipp',
        theme: MyTheme.lighttheme(context),
        home: const SplashScreen(),
        routes: {
          MyRoutes.homepage: (context) => const HomePage(),
          MyRoutes.loginpage: (context) => const LoginPage(),
        },
      ),
    );
  }
}
