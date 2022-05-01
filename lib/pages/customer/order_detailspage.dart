import 'dart:async';

import 'package:ezshipp/APIs/customer_orders.dart';
import 'package:ezshipp/Provider/customer_controller.dart';
import 'package:ezshipp/Provider/maps_provider.dart';
import 'package:ezshipp/pages/customer/trakingpage.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../Provider/biker_controller.dart';
import '../../utils/themes.dart';

// ignore: must_be_immutable
class OrderDetailsPage extends StatefulWidget {
  static String routeName = "/order-details";
  CustomerOrdersList order;
  OrderDetailsPage(this.order, {Key? key}) : super(key: key);

  @override
  OrderDetailsPageState createState() => OrderDetailsPageState();
}

class OrderDetailsPageState extends State<OrderDetailsPage> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late MapsProvider mapsProvider;
  @override
  void initState() {
    super.initState();
    mapsProvider = Provider.of<MapsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (widget.order.statusId == 12) showfeedback(context);
      timer.cancel();
    });
    return Scaffold(
      key: _scaffoldKey,
      appBar: Variables.app(actions: [
        if (widget.order.statusId > 0 && widget.order.statusId < 13 && widget.order.statusId != 10)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
                onPressed: () async {
                  bool comment = await showDialog(
                    context: _scaffoldKey.currentContext!,
                    builder: (context) => SimpleDialog(
                      title: Text("Cancel Reasons", textAlign: TextAlign.center, style: Variables.font(fontSize: 18)),
                      children: [
                        ...ListTile.divideTiles(
                          context: context,
                          tiles: List.generate(
                              Variables.cancelReasons.length,
                              (index) => ListTile(
                                    onTap: () async {
                                      Variables.updateOrderMap.cancelReason = Variables.cancelReasons[index][1];
                                      Variables.updateOrderMap.cancelReasonId = Variables.cancelReasons[index][0];

                                      Variables.pop(context,
                                          value: Variables.cancelReasons[index][3] == 1 ? true : false);
                                    },
                                    title: Text(Variables.cancelReasons[index][1]),
                                  )),
                        ),
                      ],
                    ),
                  );
                  if (comment) {
                    String? value1;
                    Variables.updateOrderMap.orderComments = await showDialog(
                        context: _scaffoldKey.currentContext!,
                        builder: (context) => AlertDialog(
                                content: Form(
                                    key: formkey,
                                    child: TextFormField(
                                        onChanged: (value) => value1 = value,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Enter  Feedback";
                                          }
                                          return null;
                                        },
                                        decoration:
                                            const InputDecoration(hintText: "Enter Feedback", labelText: "Feedback*"))),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        if (formkey.currentState!.validate()) {
                                          Variables.pop(context, value: value1);
                                        }
                                      },
                                      child: Text(
                                        "Send",
                                        style: Variables.font(fontSize: 15, color: null),
                                      ))
                                ]));
                  }
                  Variables.updateOrderMap.driverId = widget.order.bikerId;
                  Variables.updateOrderMap.newDriverId = widget.order.bikerId;
                  await Variables.updateOrder(mounted, _scaffoldKey.currentContext!, widget.order.id, 13, true);
                  if (!mounted) return;
                  CustomerController customerController = Provider.of<CustomerController>(context, listen: false);
                  await customerController.getCustomerOrderHistory(mounted, context);
                  if (!mounted) return;
                  Variables.pop(context);
                },
                child: Text("Cancel", style: Variables.font(color: null, fontSize: 16))),
          )
      ]),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("ORDER DETAILS",
                  style: Variables.font(color: Palette.kOrange, fontWeight: FontWeight.bold, fontSize: 19))),
          Card(
              margin: const EdgeInsets.all(5),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 4),
                  child: Column(children: [
                    Variables.text(context,
                        value: " ${widget.order.orderSeqId}", headFontSize: 15, valueFontSize: 17, vpadding: 3),
                    const Divider(),
                    Variables.text1(
                        head: "Ordered at",
                        value: Variables.datetime(widget.order.orderCreatedTime, timeNeed: true),
                        valueStyle: Variables.font(color: Colors.grey.shade700, fontSize: 16),
                        headStyle: Variables.font(fontSize: 15)),
                    Variables.text1(
                        head: "Payment Type",
                        value: widget.order.paymentType,
                        valueStyle: Variables.font(color: Colors.grey.shade700, fontSize: 16),
                        headStyle: Variables.font(fontSize: 15)),
                    Variables.text1(
                        head: "Item",
                        value: widget.order.item,
                        valueStyle: Variables.font(color: Colors.grey.shade700, fontSize: 16),
                        headStyle: Variables.font(fontSize: 15)),
                    Variables.text1(
                        head: "Sender Name",
                        value: widget.order.senderName,
                        valueStyle: Variables.font(color: Colors.grey.shade700, fontSize: 16),
                        headStyle: Variables.font(fontSize: 15)),
                    Variables.text1(
                        head: "Sender Phone",
                        value: widget.order.senderPhone,
                        valueStyle: Variables.font(color: Colors.grey.shade700, fontSize: 16),
                        headStyle: Variables.font(fontSize: 15)),
                    Variables.text1(
                        head: "Receiver Name",
                        value: widget.order.receiverName,
                        valueStyle: Variables.font(color: Colors.grey.shade700, fontSize: 16),
                        headStyle: Variables.font(fontSize: 15)),
                    Variables.text1(
                        head: "Receiver Phone",
                        value: widget.order.receiverPhone,
                        valueStyle: Variables.font(color: Colors.grey.shade700, fontSize: 16),
                        headStyle: Variables.font(fontSize: 15)),
                    Variables.text1(
                        head: "Distance",
                        value: widget.order.distance.toString(),
                        valueStyle: Variables.font(color: Colors.grey.shade700, fontSize: 16),
                        headStyle: Variables.font(fontSize: 15)),
                    Variables.text1(
                        head: "Order Status",
                        value: widget.order.statusId == 2 ? "Biker ${widget.order.status}" : widget.order.status,
                        valueStyle: Variables.font(
                            color:
                                widget.order.statusId > 0 && widget.order.statusId < 13 && widget.order.statusId != 10
                                    ? Colors.green
                                    : Colors.red,
                            fontSize: 16),
                        headStyle: Variables.font(fontSize: 15)),
                  ]))),
          Variables.text1(
              head: "Delivery Charges",
              value: "₹ ${widget.order.deliveryCharge.toString()}",
              valueStyle: Variables.font(color: Colors.grey.shade700, fontSize: 16),
              headStyle: Variables.font(fontSize: 15)),
          if (widget.order.codCharge > 0)
            Variables.text1(
                head: "COD Charges",
                value: "₹ ${widget.order.codCharge.toString()}",
                valueStyle: Variables.font(color: Colors.grey.shade700, fontSize: 16),
                headStyle: Variables.font(fontSize: 15)),
          Variables.text1(
              head: "Total",
              value: "₹ ${widget.order.totalCharge.toString()}",
              valueStyle: Variables.font(color: Colors.grey.shade700, fontSize: 16),
              headStyle: Variables.font(fontSize: 15)),
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: widget.order.statusId > 2 && widget.order.statusId < 13 && widget.order.statusId != 10
          ? FloatingActionButton.extended(
              onPressed: () {
                mapsProvider.livebikerTracking(mounted, context, widget.order.bikerId, widget.order.id);

                Variables.push(context, TrackingPage.routeName);
              },
              label: Text("Track Your Order", style: Variables.font(color: null)),
              icon: const Icon(Icons.location_on_sharp))
          : null,
    );
  }

  showfeedback(BuildContext context) async => await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
          title: Align(alignment: Alignment.center, child: Text('Biker Rating', style: Variables.font(fontSize: 17))),
          titleTextStyle: Variables.font(fontSize: 17),
          content: RatingBar.builder(
              itemPadding: const EdgeInsets.all(3),
              initialRating: 0,
              itemCount: 5,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return const Icon(
                      Icons.sentiment_very_dissatisfied,
                      color: Colors.red,
                    );
                  case 1:
                    return const Icon(
                      Icons.sentiment_dissatisfied,
                      color: Colors.redAccent,
                    );
                  case 2:
                    return const Icon(
                      Icons.sentiment_neutral,
                      color: Colors.amber,
                    );
                  case 3:
                    return const Icon(
                      Icons.sentiment_satisfied,
                      color: Colors.lightGreen,
                    );
                  case 4:
                    return const Icon(
                      Icons.sentiment_very_satisfied,
                      color: Colors.green,
                    );
                }
                return Container();
              },
              onRatingUpdate: (value) {
                debugPrint(value.toString());
                TrackingPage.rating = value;
              }),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  BikerController bikerController = Provider.of<BikerController>(context, listen: false);
                  await bikerController.bikerRating(
                      mounted, context, widget.order.bikerId, widget.order.id, TrackingPage.rating.ceil());
                  if (!mounted) return;
                  if (TrackingPage.rating > 0) {
                    Variables.pop(context);
                  } else {
                    Variables.showtoast(context, "Please rate your biker", Icons.warning_rounded);
                  }
                },
                child: Text(
                  "Send",
                  style: Variables.font(fontSize: 15, color: null),
                ))
          ],
          actionsAlignment: MainAxisAlignment.spaceEvenly));
}
