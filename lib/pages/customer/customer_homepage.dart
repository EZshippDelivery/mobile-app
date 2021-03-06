import 'package:ezshipp/Provider/update_screenprovider.dart';
import 'package:ezshipp/tabs/old_orders.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:ezshipp/widgets/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Provider/customer_controller.dart';
import '../../Provider/order_controller.dart';
import '../../Provider/update_profile_provider.dart';
import '../../tabs/home.dart';

class CustomerHomePage extends StatefulWidget {
  static String routeName = "/customer";
  const CustomerHomePage({Key? key}) : super(key: key);

  @override
  CustomerHomePageState createState() => CustomerHomePageState();
}

class CustomerHomePageState extends State<CustomerHomePage> with TickerProviderStateMixin {
  late TabController tabController;
  late UpdateProfileProvider updateCustomerProfileProvider;
  late CustomerController customerController;
  late UpdateScreenProvider updateScreenProvider;
  late OrderController orderController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    updateCustomerProfileProvider = Provider.of<UpdateProfileProvider>(context, listen: false);
    customerController = Provider.of<CustomerController>(context, listen: false);
    updateScreenProvider = Provider.of<UpdateScreenProvider>(context, listen: false);
    orderController = Provider.of<OrderController>(context, listen: false);
    Future.delayed(Duration.zero, () => constructor());
  }

  void constructor() async {
    if (Variables.driverId > 0) {
      Variables.loadingDialogue(context: context, subHeading: "Please wait ...");
      await updateCustomerProfileProvider.getCustomer(mounted, context);
      if (!mounted) return;
      await customerController.getFirstTenAddresses(mounted, context);
      if (!mounted) return;
      await orderController.getAcceptedAndinProgressOrders(mounted, context);
      if (!mounted) return;
      await customerController.getCustomerInProgressOrderCount(mounted, context);
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: TabBarView(
          controller: tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [HomeTab(size: size), const OldOrders()]),
      bottomNavigationBar: Consumer<CustomerController>(builder: (context, reference, child) {
        return BottomAppBar(
          child: TabBar(
            onTap: (value) => reference.getCustomerInProgressOrderCount(mounted, context),
            controller: tabController,
            tabs: TabBars.tabs2(reference.inProgresOrderCount),
          ),
        );
      }),
    );
  }
}
