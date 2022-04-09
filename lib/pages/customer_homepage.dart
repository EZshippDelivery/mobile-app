import 'package:ezshipp/Provider/get_addresses_provider.dart';
import 'package:ezshipp/Provider/update_screenprovider.dart';
import 'package:ezshipp/tabs/old_orders.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:ezshipp/widgets/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/update_profile_provider.dart';
import '../tabs/home.dart';

class CustomerHomePage extends StatefulWidget {
  static String routeName = "/customer";
  const CustomerHomePage({Key? key}) : super(key: key);

  @override
  _CustomerHomePageState createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> with TickerProviderStateMixin {
  late TabController tabController;
  late UpdateProfileProvider updateCustomerProfileProvider;
  late GetAddressesProvider getAddressesProvider;
  late UpdateScreenProvider updateScreenProvider;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    updateCustomerProfileProvider = Provider.of<UpdateProfileProvider>(context, listen: false);
    getAddressesProvider = Provider.of<GetAddressesProvider>(context, listen: false);
    updateScreenProvider = Provider.of<UpdateScreenProvider>(context, listen: false);
    constructor();
  }

  void constructor() async {
    if (Variables.driverId > 0)
      await updateCustomerProfileProvider.getcolor(context, false, driverid: Variables.driverId);
    await getAddressesProvider.getAllAddresses(context);
    updateScreenProvider.getInProgressOrderCount(context);
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
      bottomNavigationBar: Consumer<UpdateScreenProvider>(builder: (context, reference, child) {
        return BottomAppBar(
          child: TabBar(
            onTap: (value) => reference.getInProgressOrderCount(context),
            controller: tabController,
            tabs: TabBars.tabs2(reference.inProgresOrderCount),
          ),
        );
      }),
    );
  }
}
