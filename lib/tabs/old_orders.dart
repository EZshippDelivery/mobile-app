import 'package:ezshipp/Provider/update_screenprovider.dart';
import 'package:ezshipp/pages/customer/order_detailspage.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:ezshipp/widgets/customer_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/customer_controller.dart';

class OldOrders extends StatefulWidget {
  const OldOrders({Key? key}) : super(key: key);

  @override
  OldOrdersState createState() => OldOrdersState();
}

class OldOrdersState extends State<OldOrders> {
  ScrollController scrollController = ScrollController();
  late CustomerController customerController;
  late UpdateScreenProvider updateScreenProvider;

  @override
  void initState() {
    super.initState();
    customerController = Provider.of<CustomerController>(context, listen: false);
    updateScreenProvider = Provider.of<UpdateScreenProvider>(context, listen: false);
    Future.delayed(Duration.zero, () => constructor());
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
        if (!customerController.isLastPage) {
          customerController.pagenumber += 1;
          customerController.getCustomerOrders(mounted, context);
        }
      }
    });
  }

  void constructor() async {
    Variables.loadingDialogue(context: context, subHeading: "Please wait ...");
    await customerController.getCustomerOrders(mounted, context);
    if (!mounted) return;
    await customerController.getCustomerInProgressOrderCount(mounted, context);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const CustomerDrawer(),
        appBar: Variables.app(actions: [
          // Padding(
          //   padding: const EdgeInsets.only(right: 15.0),
          //   child: PopupMenuButton(
          //       itemBuilder: (BuildContext context) => [
          //             PopupMenuItem(
          //                 onTap: () async {
          //                   Variables.loadingDialogue(context: context, subHeading: "Please wait ...");

          //                   await customerController.getCustomerOrderHistory(mounted, context);
          //                   if (!mounted) return;
          //                   Navigator.pop(context);
          //                 },
          //                 padding: const EdgeInsets.only(left: 8),
          //                 child: Text("Recent", style: Variables.font(fontSize: 15))),
          //             PopupMenuItem(
          //                 onTap: () async {
          //                   customerController.pagenumber = 1;
          //                   Variables.loadingDialogue(context: context, subHeading: "Please wait ...");
          //                   await customerController.getCustomerOrders(mounted, context);
          //                   if (!mounted) return;
          //                   Navigator.pop(context);
          //                 },
          //                 padding: const EdgeInsets.only(left: 8),
          //                 child: Text("All", style: Variables.font(fontSize: 15)))
          //           ],
          //       child: const Icon(Icons.filter_list_rounded)),
          // )
        ]),
        body: Consumer<CustomerController>(builder: (context, reference, child) {
          if (!reference.loading4) {
            if (reference.customerOrders.isNotEmpty) {
              return RefreshIndicator(
                onRefresh: () {
                  customerController.pagenumber1 = 1;
                  return customerController.getCustomerOrders(mounted, context);
                },
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: reference.customerOrders.length,
                  itemBuilder: (context, index) => Card(
                      child: ListTile(
                    contentPadding: const EdgeInsets.all(3),
                    onTap: () {
                      Variables.index = index;
                      Variables.push(context, OrderDetailsPage.routeName);
                    },
                    title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Variables.text(context,
                          head: "Booking ID: ",
                          value: reference.customerOrders[index].orderSeqId,
                          valueColor: Colors.grey),
                      Variables.text(context,
                          head: "",
                          value: Variables.datetime(reference.customerOrders[index].orderCreatedTime),
                          valueColor: Colors.grey)
                    ]),
                    subtitle: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Variables.text(context,
                          head: "",
                          value: reference.customerOrders[index].status,
                          valueColor: reference.customerOrders[index].statusId < 13 &&
                                  reference.customerOrders[index].statusId != 10
                              ? Colors.green
                              : Colors.red),
                      Variables.text(context,
                          head: "",
                          value: "₹ ${reference.customerOrders[index].totalCharge}",
                          valueColor: Palette.deepgrey)
                    ]),
                  )),
                ),
              );
            } else {
              return Center(child: Text("No orders", style: Variables.font(fontSize: 22)));
            }
          }
          return const Center(child: CircularProgressIndicator.adaptive());
        }));
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
