import 'dart:async';

import 'package:ezshipp/Provider/maps_provider.dart';
import 'package:ezshipp/Provider/update_screenprovider.dart';
import 'package:ezshipp/tabs/my_orders.dart';
import 'package:ezshipp/tabs/new_orders.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:ezshipp/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../Provider/customer_controller.dart';
import '../../Provider/order_controller.dart';
import '../../Provider/update_profile_provider.dart';
import '../../widgets/tabbar.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/driver";
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TextEditingController controller = TextEditingController();
  late UpdateProfileProvider updateProfileProvider;
  late OrderController orderController;
  late TabController tabController;
  late MapsProvider mapsProvider;
  late StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    mapsProvider = Provider.of<MapsProvider>(context, listen: false);
    updateProfileProvider = Provider.of<UpdateProfileProvider>(context, listen: false);
    subscribe();
  }

  void subscribe() {
    subscription = InternetConnectionChecker().onStatusChange.listen((event) async {
      Variables.internetStatus = event;
      if (event == InternetConnectionStatus.connected) {
        await updateProfileProvider.getProfile(context);
        setonline();
        await updateProfileProvider.getAllOrdersByBikerId(context);
      } else if (event == InternetConnectionStatus.disconnected) {
        Variables.overlayNotification();
      }
      setState(() {});
    });
  }

  setonline() async {
    final value = await Variables.read(key: "isOnline");
    mapsProvider.offLineMode(context, value != null ? value.toLowerCase() == "true" : true, fromhomepage: true);
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
                      orderController.findOrderbyBarcode(
                          context, await Variables.scantext(context, controller, fromhomepage: true), 7);
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
                child: Consumer<UpdateScreenProvider>(builder: (context, snapshot, child) {
                  return TabBar(
                      onTap: (value) => snapshot.updateScreen(),
                      labelPadding: const EdgeInsets.all(11),
                      indicatorWeight: 4.0,
                      controller: tabController,
                      tabs: TabBars.tabs1(tabController));
                })),
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
    tabController.dispose();
    controller.dispose();
    subscription.cancel();
    super.dispose();
  }
}
