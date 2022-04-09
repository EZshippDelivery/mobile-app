import 'package:ezshipp/Provider/get_addresses_provider.dart';
import 'package:ezshipp/Provider/maps_provider.dart';
import 'package:ezshipp/Provider/update_order_povider.dart';
import 'package:ezshipp/Provider/update_profile_provider.dart';
import 'package:ezshipp/Provider/update_screenprovider.dart';
import 'package:ezshipp/pages/aboutpage.dart';
import 'package:ezshipp/pages/add_addresspage.dart';
import 'package:ezshipp/pages/book_orderpage.dart';
import 'package:ezshipp/pages/confirm_addresspage.dart';
import 'package:ezshipp/pages/confirm_orderpage.dart';
import 'package:ezshipp/pages/contact_page.dart';
import 'package:ezshipp/pages/customer_editprofilepage.dart';
import 'package:ezshipp/pages/customer_homepage.dart';
import 'package:ezshipp/pages/customer_invitepage.dart';
import 'package:ezshipp/pages/customer_profilepage.dart';
import 'package:ezshipp/pages/deliver_page.dart';
import 'package:ezshipp/pages/editprofilepage.dart';
import 'package:ezshipp/pages/homepage.dart';
import 'package:ezshipp/pages/loginpage.dart';
import 'package:ezshipp/pages/order_detailspage.dart';
import 'package:ezshipp/pages/orderpage.dart';
import 'package:ezshipp/pages/profilepage.dart';
import 'package:ezshipp/pages/saved_addresspage.dart';
import 'package:ezshipp/pages/set_addresspage.dart';
import 'package:ezshipp/pages/set_locationpage.dart';
import 'package:ezshipp/pages/splash.dart';
import 'package:ezshipp/pages/trakingpage.dart';
import 'package:ezshipp/pages/zonepage.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'Provider/update_login_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value) => runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider<UpdateOrderProvider>(create: (context) => UpdateOrderProvider()),
          ChangeNotifierProvider<UpdateLoginProvider>(create: (context) => UpdateLoginProvider()),
          ChangeNotifierProvider<UpdateProfileProvider>(create: (context) => UpdateProfileProvider()),
          ChangeNotifierProvider<MapsProvider>(create: (context) => MapsProvider()),
          ChangeNotifierProvider<GetAddressesProvider>(create: (context) => GetAddressesProvider()),
          ChangeNotifierProvider<UpdateScreenProvider>(create: (context) => UpdateScreenProvider())
        ],
        child: const MyApp(),
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UpdateProfileProvider updateProfileProvider = Provider.of<UpdateProfileProvider>(context, listen: false);
    UpdateOrderProvider updateOrderProvider = Provider.of<UpdateOrderProvider>(context, listen: false);
    return OverlaySupport.global(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EZShipp',
        theme: MyTheme.lighttheme(context),
        home: const SplashScreen(),
        routes: {
          HomePage.routeName: (context) => const HomePage(),
          LoginPage.routeName: (context) => const LoginPage(),
          CustomerHomePage.routeName: (context) => const CustomerHomePage(),
          ContactPage.routeName: (context) => const ContactPage(),
          AboutPage.routeName: (context) => const AboutPage(),
          ProfilePage.routeName: (context) => const ProfilePage(),
          CustomerInvitePage.routeName: (context) =>
              CustomerInvitePage(referCode: updateProfileProvider.profile.referralCode),
          SavedAddressPage.routeName: (context) => const SavedAddressPage(),
          CustomerProfilePage.routeName: (context) => const CustomerProfilePage(),
          OrderDetailsPage.routeName: (context) =>
              OrderDetailsPage(updateOrderProvider.customerOrders[Variables.index]),
          SetLocationPage.routeName: (context) => const SetLocationPage(),
          ConfirmAddressPage.routeName: (context) => const ConfirmAddressPage(),
          "/order" + Order.routeName: (context) => Order(index: Variables.index1, accepted: true),
          BookOrderPage.routeName: (context) => const BookOrderPage(),
          ConfirmOrderPage.routeName: (context) => const ConfirmOrderPage(),
          CustomerEditProfilePage.routeName: (context) => const CustomerEditProfilePage(),
          AddAddressPage.routeName: (context) => const AddAddressPage(),
          SetAddressPage.routeName: (context) => const SetAddressPage(),
          ZonedPage.routeName: (context) => const ZonedPage(),
          EditProfilePage.routeName: (context) => const EditProfilePage(),
          DeliveredPage.routeName: (context) =>
              DeliveredPage(reference: Variables.list1, index: Variables.index2, isdetails: Variables.isdetail),
          TrackingPage.routeName: (context) => TrackingPage(Variables.list2)
        },
      ),
    );
  }
}
