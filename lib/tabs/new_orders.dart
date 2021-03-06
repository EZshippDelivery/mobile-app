import 'dart:async';

import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Provider/order_controller.dart';

class NewOrders extends StatefulWidget {
  const NewOrders({Key? key}) : super(key: key);

  @override
  NewOrdersState createState() => NewOrdersState();
}

class NewOrdersState extends State<NewOrders> {
  int length = 1;
  late OrderController orderController;

  @override
  void initState() {
    super.initState();
    orderController = Provider.of<OrderController>(context, listen: false);
    Future.delayed(Duration.zero, () => constructor());
  }

  constructor() async {
    Variables.loadingDialogue(context: context, subHeading: "Please wait ...");
    await orderController.getAllOrdersByBikerId(mounted, context);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<OrderController>(builder: (context, reference, child) {
        if (!reference.loading) {
          if (reference.newOrderList.isEmpty) {
            return Stack(
              children: [
                Center(
                  child: Text(
                    "No New Orders",
                    style: Variables.font(fontSize: 18),
                  ),
                ),
                RefreshIndicator(child: ListView(), onRefresh: () => constructor()),
              ],
            );
          }

          return RefreshIndicator(
            onRefresh: () => constructor(),
            child: ListView.builder(
              itemCount: reference.newOrderList.length,
              itemBuilder: (context, index) {
                return Dismissible(
                    key: ObjectKey(reference.newOrderList[index]),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        bool close = await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => AlertDialog(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                                    title: Text("Alert!", style: Variables.font(fontSize: 20)),
                                    content: Text("Are you sure,you want to cancel the order?",
                                        style: Variables.font(fontSize: 16)),
                                    actionsAlignment: MainAxisAlignment.spaceEvenly,
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("NO", style: Variables.font(fontSize: 16, color: Colors.white)),
                                        ),
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            reference.newOrderList.removeAt(index);
                                            Navigator.of(context).pop(true);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "YES",
                                              style: Variables.font(fontSize: 16, color: Colors.white),
                                            ),
                                          ))
                                    ]));
                        if (close) {
                          Timer? timer = Timer.periodic(const Duration(seconds: 3),
                              (time) => Navigator.of(context, rootNavigator: true).pop(close));
                          showDialog(
                              context: context,
                              builder: (context) => SimpleDialog(
                                      title: Text(
                                        "Rejected",
                                        style: Variables.font(fontSize: 22),
                                        textAlign: TextAlign.center,
                                      ),
                                      children: [
                                        Image.asset(
                                          "assets/icon/close_circle.gif",
                                          height: 100,
                                        ),
                                        Text(
                                          "Your order is rejected",
                                          style: Variables.font(color: Colors.grey.shade700, fontSize: 18),
                                          textAlign: TextAlign.center,
                                        ),
                                      ])).then((value) {
                            timer?.cancel();
                            timer = null;
                          });
                        }

                        return Future.value(false);
                      } else if (direction == DismissDirection.startToEnd) {
                        return Future.value(true);
                      }
                      return null;
                    },
                    background: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(15),
                        color: Colors.green,
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                        )),
                    secondaryBackground: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.all(15),
                        color: Colors.red,
                        child: const Icon(
                          Icons.cancel_outlined,
                          color: Colors.white,
                        )),
                    onDismissed: (direction) async {
                      await Variables.updateOrder(mounted, context, reference.newOrderList[index].id,
                          direction == DismissDirection.startToEnd ? 3 : 14);
                      if (direction == DismissDirection.endToStart || direction == DismissDirection.startToEnd) {
                        reference.newOrderList.removeAt(index);
                      }
                      if (direction == DismissDirection.startToEnd) {
                        Timer? timer = Timer.periodic(
                            const Duration(seconds: 1), (time) => Navigator.of(context, rootNavigator: true).pop(true));
                        showDialog(
                            context: context,
                            builder: (context) => SimpleDialog(
                                    title: Text(
                                      "Accepted",
                                      style: Variables.font(fontSize: 22),
                                      textAlign: TextAlign.center,
                                    ),
                                    children: [
                                      Image.asset("assets/icon/check_circle.gif", height: 100),
                                      Text("Your order is accepted",
                                          style: Variables.font(color: Colors.grey.shade700, fontSize: 18),
                                          textAlign: TextAlign.center),
                                      Text("Lets Go!",
                                          style: Variables.font(color: Colors.grey.shade700, fontSize: 18),
                                          textAlign: TextAlign.center)
                                    ])).then((value) {
                          timer?.cancel();
                          timer = null;
                        });
                      }
                    },
                    child: Card(
                      child: ExpansionTile(
                        backgroundColor: Colors.white,
                        childrenPadding: EdgeInsets.zero,
                        tilePadding: EdgeInsets.zero,
                        title: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Padding(
                            padding: const EdgeInsets.only(left: 7.0),
                            child: SizedBox.fromSize(
                              size: const Size.square(53),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/icon/icons8-location-48.png",
                                    height: 25,
                                    color: Palette.kOrange,
                                  ),
                                  FittedBox(
                                    child: Text(
                                      "${reference.newOrderList[index].pickDistance} km",
                                      style: Variables.font(color: Palette.kOrange),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          title: Variables.text(context,
                              head: "Order ID:", value: reference.newOrderList[index].orderSeqId),
                          subtitle: Text(
                            Variables.datetime(reference.newOrderList[index].orderCreatedTime),
                            style: Variables.font(color: Colors.grey[700]),
                          ),
                        ),
                        children: [
                          Card(
                            elevation: 4,
                            margin: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Variables.text(context,
                                        head: "Delivery distance: ",
                                        value: "${reference.newOrderList[index].pickToDropDistance} km"),
                                    IconButton(
                                        onPressed: () async {
                                          String urlString =
                                              "https://www.google.com/maps/dir/?api=1&origin=${reference.newOrderList[index].pickLatitude},${reference.newOrderList[index].pickLongitude} &destination=${reference.newOrderList[index].dropLatitude},${reference.newOrderList[index].dropLongitude}";
                                          await canLaunchUrl(Uri.parse(urlString))
                                              ? launchUrl(Uri.parse(urlString))
                                              : Variables.showtoast(
                                                  context, "Can't open Google Maps App", Icons.cancel_outlined);
                                        },
                                        icon: Image.asset("assets/icon/icons8-google-maps-64.png"))
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Variables.text(context,
                                      head: "Delivery duration: ",
                                      value: "${reference.newOrderList[index].pickToDropDuration} min"),
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.only(
                                    top: 10,
                                    bottom: 5,
                                    left: 8,
                                  ),
                                  title: Row(children: [
                                    Image.asset(
                                      "assets/icon/icons8-location-48.png",
                                      height: 18,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(width: 3),
                                    Text("Pickup Address", style: Variables.font(fontSize: 17))
                                  ]),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(reference.newOrderList[index].pickAddress),
                                  ),
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.only(
                                    top: 3,
                                    bottom: 5,
                                    left: 8,
                                  ),
                                  title: Row(children: [
                                    Image.asset(
                                      "assets/icon/icons8-location-48.png",
                                      height: 18,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(width: 3),
                                    Text("Drop Address", style: Variables.font(fontSize: 17))
                                  ]),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(reference.newOrderList[index].dropAddress),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ));
              },
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }
}
