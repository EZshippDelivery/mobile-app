import 'package:ezshipp/Provider/maps_provider.dart';
import 'package:ezshipp/Provider/update_order_povider.dart';
import 'package:ezshipp/tabs/my_orders.dart';
import 'package:ezshipp/tabs/new_orders.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:ezshipp/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    mapsProvider = Provider.of<MapsProvider>(context, listen: false);
    updateOrderProvider = Provider.of<UpdateOrderProvider>(context, listen: false);
    setonline();
    updateProfileProvider = Provider.of<UpdateProfileProvider>(context, listen: false);
    updateProfileProvider.getcolor(true, driverid: updateOrderProvider.driverId);
    updateOrderProvider.newOrders();
    FlutterMobileVision.start().then((value) => setState(() {}));
  }

  setonline() async {
    final pref = await SharedPreferences.getInstance();
    mapsProvider.online(pref.getBool("isOnline") ?? true, updateOrderProvider.driverId, fromhomepage: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                updateOrderProvider.findOrderbyBarcode(await Variables.scantext(context, controller, fromhomepage: true),7);
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
              onTap: (value) => setState(() {}),
              labelPadding: const EdgeInsets.all(10),
              indicatorWeight: 4.0,
              controller: tabController,
              tabs: TabBars.tabs1(tabController))),
    );
  }

  @override
  void dispose() {
    updateOrderProvider.dispose();
    updateProfileProvider.dispose();
    tabController.dispose();
    controller.dispose();
    super.dispose();
  }
}
