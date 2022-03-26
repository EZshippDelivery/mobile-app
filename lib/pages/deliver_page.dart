import 'package:ezshipp/APIs/new_orderlist.dart';
import 'package:ezshipp/Provider/update_order_povider.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';

// ignore: must_be_immutable
class DeliveredPage extends StatefulWidget {
  static String routeName = "/delivered";
  static bool addsignature = false;
  NewOrderList reference;
  int? index;
  bool isdetails;
  DeliveredPage({Key? key, required this.reference, this.isdetails = false, this.index}) : super(key: key);

  @override
  _DeliveredPageState createState() => _DeliveredPageState();
}

class _DeliveredPageState extends State<DeliveredPage> {
  
  SignatureController signatureController = SignatureController(penColor: Palette.deepgrey);
  @override
  Widget build(BuildContext context) {
    List paymentItems = [
      ["Collect Cash At", widget.reference.collectAt],
      ["Payment Type", widget.reference.paymentType],
      ["Delivery Charges", "₹ " + widget.reference.codCharge.toString()],
      ["Total Amount", "₹ " + widget.reference.totalCharge.toString()]
    ];
    return Scaffold(
      appBar: Variables.app(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Flexible(
                  child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: Variables.text(head: "Order Id: ", value: widget.reference.orderSeqId))),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Variables.text(
                head: "Order Date: ", value: Variables.datetime(widget.reference.orderCreatedTime), vpadding: 5),
            Variables.text(
                head: "Delivery distance: ", value: "${widget.reference.pickToDropDistance} km", vpadding: 5),
            Variables.text(
                head: "Delivery duration: ", value: "${widget.reference.pickToDropDuration} min", vpadding: 5),
            if (widget.isdetails == false)
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Item Received by:", style: Variables.font(fontSize: 15)),
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: DropdownButtonFormField<String>(
                      items: Variables.menuItems
                          .map((e) =>
                              DropdownMenuItem<String>(value: e, child: Text(e, style: Variables.font(fontSize: 15))))
                          .toList(),
                      onChanged: (value) => Variables.currentMenuItem = value!,
                      value: Variables.currentMenuItem,
                    ),
                  )
                ],
              ),
            const SizedBox(height: 15),
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(children: [
                            Image.asset(
                              "assets/icon/icons8-location-48.png",
                              height: 20,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 3),
                            Text("Pickup Address", style: Variables.font(fontSize: 17))
                          ]),
                        ),
                        const SizedBox(height: 3),
                        Variables.text(
                            head: "Name: ",
                            value: widget.reference.senderName,
                            valueFontSize: 15,
                            valueColor: Colors.grey),
                        Variables.text(
                            head: "Phone number: ",
                            value: widget.reference.senderPhone,
                            valueFontSize: 15,
                            valueColor: Colors.grey),
                        Variables.text(
                            head: "Address:\n",
                            value: widget.reference.pickAddress,
                            valueFontSize: 15,
                            valueColor: Colors.grey),
                        if (widget.reference.pickLandmark.isEmpty)
                          Variables.text(
                              head: "Landmark:",
                              value: widget.reference.pickLandmark,
                              valueFontSize: 15,
                              valueColor: Colors.grey)
                      ],
                    ),
                    const Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(children: [
                            Image.asset(
                              "assets/icon/icons8-location-48.png",
                              height: 20,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 3),
                            Text("Drop Address", style: Variables.font(fontSize: 17))
                          ]),
                        ),
                        const SizedBox(height: 3),
                        Variables.text(
                            head: "Name: ",
                            value: widget.reference.receiverName,
                            valueFontSize: 15,
                            valueColor: Colors.grey),
                        Variables.text(
                            head: "Phone number: ",
                            value: widget.reference.receiverPhone,
                            valueFontSize: 15,
                            valueColor: Colors.grey),
                        Variables.text(
                            head: "Address:\n",
                            value: widget.reference.dropAddress,
                            valueFontSize: 15,
                            valueColor: Colors.grey),
                        if (widget.reference.dropLandmark.isEmpty)
                          Variables.text(
                              head: "Landmark:",
                              value: widget.reference.dropLandmark,
                              valueFontSize: 15,
                              valueColor: Colors.grey)
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            if (widget.reference.item.isNotEmpty) Variables.text(head: "Item Name: ", value: widget.reference.item),
            if (widget.reference.itemDescription.isNotEmpty)
              Variables.text(head: "Item Description: ", value: widget.reference.itemDescription),
            if (widget.reference.itemImage.isNotEmpty)
              RichText(
                  text: TextSpan(text: "Item Image:\t", children: [
                WidgetSpan(
                    child: TextButton(
                  onPressed: () async => await showDialog(
                    context: context,
                    builder: (context) => Center(
                        child: Placeholder(
                            fallbackHeight: MediaQuery.of(context).size.height * 0.37,
                            fallbackWidth: MediaQuery.of(context).size.width * 0.5)),
                  ),
                  child: Text(
                    "show Image",
                    style: Variables.font(fontSize: 15, color: null),
                  ),
                ))
              ])),
            ...paymentItems.map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e[0], style: Variables.font(color: Palette.deepgrey)),
                      Text(e[1], style: Variables.font(color: Colors.grey.shade700, fontSize: 16))
                    ],
                  ),
                )),
            if (widget.isdetails == false) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text("Signature", style: Variables.font(fontSize: 15)),
                  TextButton(
                      onPressed: () async {
                        String value = await showDialog(
                                context: context,
                                builder: (context) => Center(
                                      child: SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.45,
                                        width: MediaQuery.of(context).size.width * 0.95,
                                        child: Material(
                                          color: Colors.grey[200],
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Padding(
                                                    padding: const EdgeInsets.only(left: 13.0),
                                                    child: Text("Signature", style: Variables.font(fontSize: 20)),
                                                  )),
                                                  IconButton(
                                                    icon: const Icon(Icons.restart_alt_rounded),
                                                    onPressed: () => signatureController.clear(),
                                                  )
                                                ],
                                              ),
                                              Signature(
                                                controller: signatureController,
                                                height: MediaQuery.of(context).size.height * 0.3,
                                                backgroundColor: Colors.white,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty.all<Color>(Palette.deepgrey),
                                                            overlayColor:
                                                                MaterialStateProperty.all<Color>(Palette.kOrange)),
                                                        onPressed: () async {
                                                          if (signatureController.points.isNotEmpty) {
                                                            String value = SignatureController(
                                                                    exportBackgroundColor: Colors.white,
                                                                    penStrokeWidth: 3,
                                                                    penColor: Colors.black,
                                                                    points: signatureController.points)
                                                                .toString();
                                                            Variables.pop(context, value: value);
                                                          } else {
                                                            Variables.showtoast(context, "Write a Signature", Icons.warning_rounded);
                                                          }
                                                        },
                                                        child: const Icon(
                                                          Icons.check_rounded,
                                                        )),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )) ??
                            "";

                         DeliveredPage.addsignature = value.isNotEmpty;
                      },
                      child: Text("Add Signature", style: Variables.font(color: null, fontSize: 16)))
                ]),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FloatingActionButton.extended(
                    elevation: 4,
                    onPressed: () {
                      if (DeliveredPage.addsignature == false) {
                        Variables.showtoast(context, "Add a Signature", Icons.warning_rounded);
                      } else {
                        Variables.updateOrder(
                            context,
                            Provider.of<UpdateOrderProvider>(context, listen: false), widget.index!, 12);
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      }
                    },
                    label: Text("Delivered", style: Variables.font(color: null)),
                    icon: const Icon(Icons.check_rounded),
                  ),
                ),
              )
            ]
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    signatureController.dispose();
  }
}
