import 'package:ezshipp/pages/biker/rider_homepage.dart';
import 'package:ezshipp/tabs/accepted.dart';
import 'package:ezshipp/tabs/delivered.dart';
import 'package:ezshipp/widgets/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/order_controller.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  MyOrdersState createState() => MyOrdersState();
}

class MyOrdersState extends State<MyOrders> with TickerProviderStateMixin {
  late TabController tabController;

  late OrderController orderController;

  @override
  void initState() {
    super.initState();

    orderController = Provider.of<OrderController>(context, listen: false);
    orderController.pagenumber1 = 1;
    // Future.delayed(Duration.zero, () => constructor());
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        HomePage.bikerTabController.index = 0;
        return false;
      },
      child: Scaffold(
        body: TabBarView(
            // physics: AlwaysScrollableScrollPhysics(),
            controller: tabController,
            children: const [Accepted(), Delivered()]),
        // Consumer<OrderController>(builder: (context, reference, child) {

        //     return TabBarView(controller: tabController, children: const [Accepted(), Delivered()]);

        // }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Material(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
              height: 40,
              width: 170,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.label,
                controller: tabController,
                tabs: TabBars.tabs3,
              )),
        ),
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
