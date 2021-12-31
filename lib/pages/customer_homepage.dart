import 'package:ezshipp/Provider/get_addresses_provider.dart';
import 'package:ezshipp/tabs/old_orders.dart';
import 'package:ezshipp/widgets/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/update_profile_provider.dart';
import '../tabs/home.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({Key? key}) : super(key: key);

  @override
  _CustomerHomePageState createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> with TickerProviderStateMixin {
  late TabController tabController;
  late UpdateProfileProvider updateCustomerProfileProvider;
  late GetAddressesProvider getAddressesProvider;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    updateCustomerProfileProvider = Provider.of<UpdateProfileProvider>(context, listen: false);
    getAddressesProvider = Provider.of<GetAddressesProvider>(context, listen: false);
    updateCustomerProfileProvider.getcolor(false);
    getAddressesProvider.getAllAddresses();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: TabBarView(
          controller: tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [HomeTab(size: size), const OldOrders()]),
      bottomNavigationBar: BottomAppBar(
        child: TabBar(
          controller: tabController,
          tabs: TabBars.tabs2,
          onTap: (value) => setState(() {}),
        ),
      ),
    );
  }
}
