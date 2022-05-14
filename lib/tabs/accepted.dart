import 'package:ezshipp/Provider/order_controller.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/biker/orderpage.dart';
import '../utils/variables.dart';

class Accepted extends StatefulWidget {
  const Accepted({Key? key}) : super(key: key);

  @override
  AcceptedState createState() => AcceptedState();
}

class AcceptedState extends State<Accepted> {
  ScrollController scrollController = ScrollController();
  late OrderController orderController;

  @override
  void initState() {
    super.initState();
    orderController = Provider.of<OrderController>(context, listen: false);

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
        if (!orderController.isLastPage1) {
          orderController.pagenumber += 1;
          orderController.getAcceptedAndinProgressOrders(mounted, context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderController>(builder: (context, reference, child) {
      return Column(children: [
        if (reference.acceptedList.isEmpty)
          Stack(
            children: [
              Center(
                child: SizedBox.fromSize(
                  size: Size.square(MediaQuery.of(context).size.width * 0.5),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "There is no new orders that are accepted",
                      style: Variables.font(fontSize: 18, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              // RefreshIndicator(
              //   child: ListView(),
              //   onRefresh: () {
              //     pageNumber = 1;
              //     return orderController.accepted(context, pageNumber, false);
              //   },
              // )
            ],
          ),
        if (reference.acceptedList.isNotEmpty)
          Flexible(
              child: RefreshIndicator(
                  onRefresh: () async {
                    orderController.pagenumber = 1;
                    return await orderController.getAcceptedAndinProgressOrders(mounted, context);
                  },
                  child: ListView.builder(
                      controller: scrollController,
                      itemCount: reference.acceptedList.length,
                      itemBuilder: (context, index) {
                        return Card(
                            child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: ListTile(
                                  tileColor: Colors.white,
                                  onTap: () async {
                                    Variables.index1 = index;
                                    if (!mounted) return;
                                    await Variables.push(context, "/order${Order.routeName}");
                                    if (!mounted) return;
                                    await orderController.getAcceptedAndinProgressOrders(mounted, context);
                                  },
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Variables.text(context,
                                          head: "Order ID: ", value: reference.acceptedList[index].orderSeqId),
                                      Text(Variables.datetime(reference.acceptedList[index].acceptedTime.isEmpty
                                          ? reference.acceptedList[index].orderCreatedTime
                                          : reference.acceptedList[index].acceptedTime))
                                    ],
                                  ),
                                  subtitle: Variables.text(context,
                                      head: "Status: ",
                                      value: reference.acceptedList[index].status,
                                      valueColor: Palette.kOrange),
                                )));
                      })))
      ]);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
