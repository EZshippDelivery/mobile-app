import 'dart:async';

import 'package:ezshipp/Provider/maps_provider.dart';
import 'package:ezshipp/Provider/update_order_povider.dart';
import 'package:ezshipp/tabs/my_orders.dart';
import 'package:ezshipp/tabs/new_orders.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:ezshipp/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../Provider/update_profile_provider.dart';
import '../widgets/tabbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController tabController;
  late UpdateProfileProvider updateProfileProvider;
  late UpdateOrderProvider updateOrderProvider;
  late MapsProvider mapsProvider;
  TextEditingController controller = TextEditingController();
  late StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    mapsProvider = Provider.of<MapsProvider>(context, listen: false);
    updateOrderProvider = Provider.of<UpdateOrderProvider>(context, listen: false);
    updateProfileProvider = Provider.of<UpdateProfileProvider>(context, listen: false);
    subscribe();
  }

  void subscribe() {
    subscription = InternetConnectionChecker().onStatusChange.listen((event) {
      Variables.internetStatus = event;
      if (event == InternetConnectionStatus.connected) {
        setonline();
        updateProfileProvider.getcolor(true, driverid: Variables.driverId);
        updateOrderProvider.newOrders();
      } else if (event == InternetConnectionStatus.disconnected) {
        Variables.overlayNotification();
      }
      setState(() {});
    });
  }

  setonline() async {
    final value = await Variables.pref.read(key: "isOnline");
    mapsProvider.online(value != null ? value.toLowerCase() == "true" : true, Variables.driverId, fromhomepage: true);
  }

  @override
  Widget build(BuildContext context) {
    return Variables.internetStatus == InternetConnectionStatus.connected
        ? Scaffold(
            drawer: const DrawerWidget(),
            appBar: Variables.app(actions: [
              IconButton(
                  onPressed: () {
                    Share.share("https://play.google.com/store/apps/details?id=com.ezshipp.customer.app&hl=en&gl=US");
                  },
                  icon: const Icon(Icons.share)),
              if (tabController.index == 1)
                IconButton(
                    onPressed: () async {
                      updateOrderProvider.findOrderbyBarcode(
                          await Variables.scantext(context, controller, fromhomepage: true), 7);
                    },
                    icon: const Icon(Icons.qr_code_scanner_rounded))
            ]),
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: tabController,
              children: const [NewOrders(), MyOrders()],
            ),
            bottomNavigationBar: BottomAppBar(
                shape: const CircularNotchedRectangle(),
                child: TabBar(
                    labelPadding: const EdgeInsets.all(10),
                    indicatorWeight: 4.0,
                    controller: tabController,
                    tabs: TabBars.tabs1(tabController))),
          )
        : Scaffold(
            appBar: Variables.app(actions: [
              IconButton(
                  onPressed: () {
                    Share.share("https://play.google.com/store/apps/details?id=com.ezshipp.customer.app&hl=en&gl=US");
                  },
                  icon: const Icon(Icons.share))
            ]),
            body: const Center(child: CircularProgressIndicator.adaptive()),
          );
  }

  @override
  void dispose() {
    updateOrderProvider.dispose();
    updateProfileProvider.dispose();
    tabController.dispose();
    controller.dispose();
    subscription.cancel();
    super.dispose();
  }
}
