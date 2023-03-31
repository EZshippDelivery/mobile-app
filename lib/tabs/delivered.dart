import 'package:ezshipp/main.dart';
import 'package:ezshipp/pages/biker/orderpage.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Provider/order_controller.dart';

class Delivered extends StatefulWidget {
  const Delivered({Key? key}) : super(key: key);

  @override
  State<Delivered> createState() => _DeliveredState();
}

class _DeliveredState extends State<Delivered> {
  ScrollController scrollController = ScrollController();
  late OrderController orderController;

  @override
  void initState() {
    super.initState();
    orderController = Provider.of<OrderController>(context, listen: false);
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
        if (!orderController.isLastPage2) {
          orderController.pagenumber1 += 1;
          orderController.getAllCompletedOrders(orderController.start.toString(), orderController.end.toString());
        }
      }
    });
    if (mounted) {
      Future.delayed(Duration.zero, () => constructor());
    }
  }

  void constructor() async {
    Variables.loadingDialogue(context: navigatorKey.currentContext, subHeading: "Please wait ...");
    await orderController.getAllCompletedOrders(orderController.start.toString(), orderController.end.toString());

    Navigator.pop(navigatorKey.currentContext!);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderController>(builder: (context, reference, child) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("From:", style: Variables.font(fontSize: 16)),
              ElevatedButton(
                  onPressed: () => showDatePicker(
                          context: context,
                          initialDate: reference.start,
                          firstDate: DateTime(2017),
                          lastDate: DateTime.now().subtract(const Duration(days: 1)))
                      .then((value) => reference.setDate(mounted, context, value, false)),
                  child: Text(
                    DateFormat("dd/MM/yyyy").format(reference.start),
                  )),
              Text("Until:", style: Variables.font(fontSize: 16)),
              ElevatedButton(
                  onPressed: () => showDatePicker(
                          context: context,
                          initialDate: reference.end,
                          firstDate: DateTime(2017),
                          lastDate: DateTime.now())
                      .then((value) => reference.setDate(mounted, context, value, false)),
                  child: Text(
                    DateFormat("dd/MM/yyyy").format(reference.end),
                  ))
            ],
          ),
          if (reference.deliveredList.isEmpty)
            Flexible(
              child: RefreshIndicator(
                onRefresh: () async {
                  orderController.pagenumber1 = 1;
                  return await orderController.getAllCompletedOrders(
                      orderController.start.toString(), orderController.end.toString());
                },
                child: ListView(
                  children: [
                    Expanded(
                        child: Center(
                      child: SizedBox.fromSize(
                        size: Size.square(MediaQuery.of(context).size.width * 0.5),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "In range of your dates, there is no orders that are delivered",
                            style: Variables.font(fontSize: 18, color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ))
                  ],
                ),
              ),
            ),
          if (reference.deliveredList.isNotEmpty)
            Flexible(
              child: RefreshIndicator(
                onRefresh: () async {
                  orderController.pagenumber1 = 1;
                  return await orderController.getAllCompletedOrders(
                      orderController.start.toString(), orderController.end.toString());
                },
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    itemCount: reference.deliveredList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Card(
                              child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: ListTile(
                                    tileColor: Colors.white,
                                    onTap: () => Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (context) => Order(index: index))),
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Variables.text(context,
                                            head: "Order ID: ", value: reference.deliveredList[index].orderSeqId),
                                        Text(Variables.datetime(reference.deliveredList[index].acceptedTime.isEmpty
                                            ? reference.deliveredList[index].orderCreatedTime
                                            : reference.deliveredList[index].acceptedTime))
                                      ],
                                    ),
                                    subtitle: Variables.text(context,
                                        head: "Status: ",
                                        value: reference.deliveredList[index].status,
                                        valueColor: Palette.kOrange),
                                  ))),
                          if (index == reference.deliveredList.length - 1) const SizedBox(height: 64)
                        ],
                      );
                    }),
              ),
            )
        ],
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }
}
