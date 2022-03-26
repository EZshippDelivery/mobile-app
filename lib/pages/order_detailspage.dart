import 'package:ezshipp/APIs/new_orderlist.dart';
import 'package:ezshipp/Provider/maps_provider.dart';
import 'package:ezshipp/pages/trakingpage.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/themes.dart';

// ignore: must_be_immutable
class OrderDetailsPage extends StatefulWidget {
  static String routeName = "/order-details";
  NewOrderList order;
  OrderDetailsPage(this.order, {Key? key}) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  late MapsProvider mapsProvider;
  @override
  void initState() {
    super.initState();
    mapsProvider = Provider.of<MapsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Variables.app(actions: [
        if (widget.order.statusId > 0 && widget.order.statusId < 13 && widget.order.statusId != 10)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
                onPressed: () async {
                  bool comment = await showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                      title: Text("Cancel Reasons", textAlign: TextAlign.center, style: Variables.font(fontSize: 18)),
                      children: [
                        ...ListTile.divideTiles(
                          context: context,
                          tiles: List.generate(
                              Variables.cancelReasons.length,
                              (index) => ListTile(
                                    onTap: () {
                                      Variables.updateOrderMap.cancelReason = Variables.cancelReasons[index][1];
                                      Variables.updateOrderMap.cancelReasonId = Variables.cancelReasons[index][0];
                                      //  Variables.updateOrder(reference, widget.index, 14);
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
                    Variables.updateOrderMap.driverComments = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                                content: Form(
                                    key: formkey,
                                    child: TextFormField(
                                        onChanged: (value) => value1 = value,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Enter  comment ";
                                          }
                                          return null;
                                        },
                                        decoration:
                                            const InputDecoration(hintText: "Enter comment", labelText: "Comment*"))),
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
                  Variables.pop(context);
                },
                child: Text("Cancel", style: Variables.font(color: null, fontSize: 16))),
          )
      ]),
      body: Column(children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("ORDER DETAILS",
                style: Variables.font(color: Palette.kOrange, fontWeight: FontWeight.bold, fontSize: 19))),
        Card(
            margin: const EdgeInsets.all(5),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 4),
                child: Column(children: [
                  Variables.text(
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
                      head: "Order Status",
                      value: widget.order.status,
                      valueStyle: Variables.font(
                          color: widget.order.statusId > 0 && widget.order.statusId < 13 && widget.order.statusId != 10
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: widget.order.statusId > 2 && widget.order.statusId < 13 && widget.order.statusId != 10
          ? FloatingActionButton.extended(
              onPressed: () {
                mapsProvider.livebikerTracking(context, widget.order.bikerId, widget.order.id);
                Variables.list2 = widget.order;
                Variables.push(context, TrackingPage.routeName);
              },
              label: Text("Track Your Order", style: Variables.font(color: null)),
              icon: const Icon(Icons.location_on_sharp))
          : null,
    );
  }
}
