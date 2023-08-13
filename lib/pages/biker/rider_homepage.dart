import 'dart:async';

import 'package:ezshipp/Provider/maps_provider.dart';
import 'package:ezshipp/Provider/update_screenprovider.dart';
import 'package:ezshipp/pages/biker/qr_scanner_page.dart';
import 'package:ezshipp/tabs/my_orders.dart';
import 'package:ezshipp/tabs/new_orders.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:ezshipp/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../Provider/order_controller.dart';
import '../../Provider/update_profile_provider.dart';
import '../../widgets/tabbar.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/driver";
  static late TabController bikerTabController;
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TextEditingController controller = TextEditingController();
  late UpdateProfileProvider updateProfileProvider;
  late OrderController orderController;
  final SimpleConnectionChecker _simpleConnectionChecker = SimpleConnectionChecker()..setLookUpAddress('pub.dev');

  late MapsProvider mapsProvider;

  bool firstTime = false;

  @override
  void initState() {
    super.initState();
    HomePage.bikerTabController = TabController(length: 2, vsync: this);
    mapsProvider = Provider.of<MapsProvider>(context, listen: false);
    updateProfileProvider = Provider.of<UpdateProfileProvider>(context, listen: false);
    orderController = Provider.of<OrderController>(context, listen: false);
    subscribe();
  }

  void subscribe() {
    Variables.subscription = _simpleConnectionChecker.onConnectionChange.listen((event) async {
      Variables.internetStatus = event;
      if (event) {
        Variables.loadingDialogue(context: context, subHeading: "Please wait ...");
        await updateProfileProvider.getProfile(mounted, context);
        if (!mounted) return;
        await updateProfileProvider.getAllOrdersByBikerId(mounted, context);
        await setonline();
        if (!mounted) return;
        Navigator.pop(context);
        show(context);
      } else {
        Variables.overlayNotification();
      }

      setState(() {});
    });
  }

  setonline() async {
    final value = await Variables.read(key: "isOnline");
    final value1 = await Variables.read(key: "FirstTime");
    firstTime = value1 != null ? value1 == "true" : false;
    if (!mounted) return;
    await mapsProvider.offLineMode(mounted, context, value != null ? value.toLowerCase() == "true" : true,
        fromhomepage: true);
    if (updateProfileProvider.newOrderList.isNotEmpty && firstTime) {
      firstTime = false;
      await Variables.write(key: "FirstTime", value: "false");
    } else {
      firstTime = true;
    }
  }

  show(BuildContext context) {
    if (firstTime == false) {
      Timer.periodic(Duration.zero, (timer) async {
        timer.cancel();
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title:
                    Align(alignment: Alignment.center, child: Text("INFORMATION", style: Variables.font(fontSize: 16))),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          Image.asset("assets/images/bloodbros-swipe-left.gif", scale: 0.2, height: 100),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                          Flexible(child: info("right", "Accept"))
                        ]),
                      )),
                  Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          Image.asset("assets/images/bloodbros-swipe-right.gif", scale: 0.2, height: 100),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                          Flexible(child: info("left", "Reject"))
                        ]),
                      ))
                ]),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                actions: [
                  ElevatedButton(
                      onPressed: () => Variables.pop(context),
                      child: Text("OK", style: Variables.font(fontSize: 15, color: null)))
                ],
                actionsAlignment: MainAxisAlignment.center,
                titlePadding: const EdgeInsets.only(top: 20, bottom: 10)));
      });
    }
  }

  RichText info(String direction, String action) {
    return RichText(
        text: TextSpan(
            text: "Swipe $direction to ",
            children: [
              TextSpan(
                  text: action,
                  style: Variables.font(
                      color: action == "Reject" ? Colors.red : Colors.green,
                      fontSize: 19,
                      fontWeight: FontWeight.bold)),
              const TextSpan(text: " the order")
            ],
            style: Variables.font(color: action == "Reject" ? Colors.red : Colors.green, fontSize: 17)));
  }

  @override
  Widget build(BuildContext context) {
    return Variables.internetStatus
        ? Consumer<UpdateScreenProvider>(
            builder: (context, snapshot, child) {
              return Scaffold(
                drawer: const DrawerWidget(),
                appBar: Variables.app(actions: [
                  IconButton(
                      onPressed: () {
                        Share.share("https://play.google.com/store/apps/details?id=com.delivery.ezshipp&hl=en&gl=US");
                      },
                      icon: const Icon(Icons.share)),
                  if (HomePage.bikerTabController.index == 1)
                    IconButton(
                        onPressed: () async {
                          QRScanerPage.zoned = true;
                          Variables.push(context, QRScanerPage.routeName);
                          // Variables.loadingDialogue(context: context, subHeading: "Please wait ...");
                          // await orderController.findOrderbyBarcode(
                          //     mounted, context, await Variables.scantext(context, controller, fromhomepage: true), 9);
                          // if (!mounted) return;
                          // await orderController.getAcceptedAndinProgressOrders(mounted, context);
                          // if (!mounted) return;
                          // Navigator.pop(context);
                        },
                        icon: const Icon(Icons.qr_code_scanner_rounded))
                ]),
                body: child,
                bottomNavigationBar: BottomAppBar(
                    shape: const CircularNotchedRectangle(),
                    child: TabBar(
                        onTap: (value) => snapshot.updateScreen(),
                        labelPadding: const EdgeInsets.all(11),
                        indicatorWeight: 4.0,
                        controller: HomePage.bikerTabController,
                        tabs: TabBars.tabs1(HomePage.bikerTabController))),
              );
            },
            child: Stack(
              children: [
                TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: HomePage.bikerTabController,
                  children: const [NewOrders(), MyOrders()],
                ),
              ],
            ),
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
    // HomePage.bikerTabController.dispose();
    controller.dispose();
    super.dispose();
  }
}
