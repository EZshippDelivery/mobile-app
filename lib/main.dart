import 'package:ezshipp/Provider/customer_controller.dart';
import 'package:ezshipp/Provider/maps_provider.dart';
import 'package:ezshipp/Provider/update_profile_provider.dart';
import 'package:ezshipp/Provider/update_screenprovider.dart';
import 'package:ezshipp/pages/aboutpage.dart';
import 'package:ezshipp/pages/customer/add_addresspage.dart';
import 'package:ezshipp/pages/customer/book_orderpage.dart';
import 'package:ezshipp/pages/customer/confirm_addresspage.dart';
import 'package:ezshipp/pages/customer/confirm_orderpage.dart';
import 'package:ezshipp/pages/biker/contact_page.dart';
import 'package:ezshipp/pages/customer/customer_editprofilepage.dart';
import 'package:ezshipp/pages/customer/customer_homepage.dart';
import 'package:ezshipp/pages/customer/customer_invitepage.dart';
import 'package:ezshipp/pages/customer/customer_profilepage.dart';
import 'package:ezshipp/pages/biker/deliver_page.dart';
import 'package:ezshipp/pages/biker/editprofilepage.dart';
import 'package:ezshipp/pages/biker/rider_homepage.dart';
import 'package:ezshipp/pages/loginpage.dart';
import 'package:ezshipp/pages/customer/order_detailspage.dart';
// import 'package:ezshipp/pages/biker/orderpage.dart';
import 'package:ezshipp/pages/biker/order_deliverypage.dart';
import 'package:ezshipp/pages/biker/profilepage.dart';
import 'package:ezshipp/pages/biker/saved_addresspage.dart';
import 'package:ezshipp/pages/customer/set_addresspage.dart';
import 'package:ezshipp/pages/customer/set_locationpage.dart';
import 'package:ezshipp/pages/splash.dart';
import 'package:ezshipp/pages/customer/trakingpage.dart';
import 'package:ezshipp/pages/biker/zonepage.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'Provider/auth_controller.dart';
import 'Provider/biker_controller.dart';
import 'Provider/order_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value) => runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider<UpdateProfileProvider>(create: (context) => UpdateProfileProvider()),
          ChangeNotifierProvider<UpdateScreenProvider>(create: (context) => UpdateScreenProvider()),
          ChangeNotifierProvider<CustomerController>(create: (context) => CustomerController()),
          ChangeNotifierProvider<BikerController>(create: (context) => BikerController()),
          ChangeNotifierProvider<OrderController>(create: (context) => OrderController()),
          ChangeNotifierProvider<AuthController>(create: (context) => AuthController()),
          ChangeNotifierProvider<MapsProvider>(create: (context) => MapsProvider()),
        ],
        child: const MyApp(),
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UpdateProfileProvider updateProfileProvider = Provider.of<UpdateProfileProvider>(context, listen: false);
    CustomerController updateOrderProvider = Provider.of<CustomerController>(context, listen: false);
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
              CustomerInvitePage(referCode: updateProfileProvider.customerProfile!.referralCode),
          SavedAddressPage.routeName: (context) => const SavedAddressPage(),
          CustomerProfilePage.routeName: (context) => const CustomerProfilePage(),
          OrderDetailsPage.routeName: (context) =>
              OrderDetailsPage(updateOrderProvider.customerOrders[Variables.index]),
          SetLocationPage.routeName: (context) => const SetLocationPage(),
          ConfirmAddressPage.routeName: (context) => const ConfirmAddressPage(),
          "/order${Order.routeName}": (context) => Order(index: Variables.index1, accepted: true),
          BookOrderPage.routeName: (context) => const BookOrderPage(),
          ConfirmOrderPage.routeName: (context) => const ConfirmOrderPage(),
          CustomerEditProfilePage.routeName: (context) => CustomerEditProfilePage(),
          AddAddressPage.routeName: (context) => const AddAddressPage(),
          SetAddressPage.routeName: (context) => const SetAddressPage(),
          ZonedPage.routeName: (context) => const ZonedPage(),
          EditProfilePage.routeName: (context) => EditProfilePage(),
          DeliveredPage.routeName: (context) =>
              DeliveredPage(reference: Variables.list1, index: Variables.index2, isdetails: Variables.isdetail),
          TrackingPage.routeName: (context) => TrackingPage(updateOrderProvider.customerOrders[Variables.index])
        },
      ),
    );
  }
}
