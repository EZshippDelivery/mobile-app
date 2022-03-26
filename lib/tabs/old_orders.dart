import 'package:ezshipp/Provider/update_order_povider.dart';
import 'package:ezshipp/Provider/update_screenprovider.dart';
import 'package:ezshipp/pages/order_detailspage.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:ezshipp/widgets/customer_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OldOrders extends StatefulWidget {
  const OldOrders({Key? key}) : super(key: key);

  @override
  _OldOrdersState createState() => _OldOrdersState();
}

class _OldOrdersState extends State<OldOrders> {
  ScrollController scrollController = ScrollController();
  late UpdateOrderProvider updateOrderProvider;
  late UpdateScreenProvider updateScreenProvider;

  @override
  void initState() {
    super.initState();
    updateOrderProvider = Provider.of<UpdateOrderProvider>(context, listen: false);
    updateScreenProvider = Provider.of<UpdateScreenProvider>(context, listen: false);
    updateOrderProvider.getRecentOrders(context);
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
        if (!updateOrderProvider.islastpageloaded1) {
          updateScreenProvider.pageNumber += 1;
          updateOrderProvider.accepted(context, updateScreenProvider.pageNumber, true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const CustomerDrawer(),
        appBar: Variables.app(actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: PopupMenuButton(
                itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                          onTap: () {
                            updateOrderProvider.getRecentOrders(context);
                          },
                          padding: const EdgeInsets.only(left: 8),
                          child: Text("Recent", style: Variables.font(fontSize: 15))),
                      PopupMenuItem(
                          onTap: () {
                            updateOrderProvider.accepted(context, updateScreenProvider.pageNumber, true);
                          },
                          padding: const EdgeInsets.only(left: 8),
                          child: Text("All", style: Variables.font(fontSize: 15)))
                    ],
                child: const Icon(Icons.filter_list_rounded)),
          )
        ]),
        body: Consumer2<UpdateOrderProvider, UpdateScreenProvider>(builder: (context, reference, reference1, child) {
          if (!reference.loading4) {
            if (reference.customerOrders.isNotEmpty) {
              return ListView.builder(
                controller: scrollController,
                itemCount: reference.customerOrders.length,
                itemBuilder: (context, index) => Card(
                    child: ListTile(
                  contentPadding: const EdgeInsets.all(3),
                  onTap: () {
                    Variables.index = index;
                    Variables.push(context, "/${Variables.index}"+OrderDetailsPage.routeName);
                  },
                  title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Variables.text(
                        head: "Booking ID: ",
                        value: reference.customerOrders[index].orderSeqId,
                        valueColor: Colors.grey),
                    Variables.text(
                        head: "",
                        value: Variables.datetime(reference.customerOrders[index].orderCreatedTime),
                        valueColor: Colors.grey)
                  ]),
                  subtitle: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Variables.text(
                        head: "",
                        value: reference.customerOrders[index].status,
                        valueColor: reference.customerOrders[index].statusId < 13 &&
                                reference.customerOrders[index].statusId != 10
                            ? Colors.green
                            : Colors.red),
                    Variables.text(
                        head: "",
                        value: "₹ ${reference.customerOrders[index].totalCharge}",
                        valueColor: Palette.deepgrey)
                  ]),
                )),
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
