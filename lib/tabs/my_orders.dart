import 'package:ezshipp/tabs/accepted.dart';
import 'package:ezshipp/tabs/delivered.dart';
import 'package:ezshipp/widgets/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/update_order_povider.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> with TickerProviderStateMixin {
  late TabController tabController;

  late UpdateOrderProvider updateOrderProvider;

  @override
  void initState() {
    super.initState();
    updateOrderProvider = Provider.of<UpdateOrderProvider>(context, listen: false);
    updateOrderProvider.accepted(1, false);
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UpdateOrderProvider>(builder: (context, reference, child) {
        if (!reference.loading2) {
          return TabBarView(controller: tabController, children: const [Accepted(), Delivered()]);
        }
        return const Center(child: CircularProgressIndicator.adaptive());
      }),
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
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
