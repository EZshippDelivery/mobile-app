import 'dart:io';

import 'package:ezshipp/Provider/update_screenprovider.dart';
import 'package:ezshipp/pages/customer/confirm_orderpage.dart';
import 'package:ezshipp/pages/customer/set_locationpage.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Provider/customer_controller.dart';

class BookOrderPage extends StatefulWidget {
  static String routeName = "/book-order";
  static List<int?> selectedradio = [1, 1, 2];
  const BookOrderPage({Key? key}) : super(key: key);

  @override
  _BookOrderPageState createState() => _BookOrderPageState();
}

class _BookOrderPageState extends State<BookOrderPage> with TickerProviderStateMixin {
  TextEditingController senderName = TextEditingController(),
      senderPhone = TextEditingController(),
      receiverName = TextEditingController(),
      receiverPhone = TextEditingController();
  late CustomerController customerController;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  ValueNotifier<int> cod = ValueNotifier<int>(0);
  // final ContactPicker _contactPicker = ContactPicker();

  String imageURL = "";
  @override
  void initState() {
    super.initState();
    customerController = Provider.of<CustomerController>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Variables.app(),
      body: SingleChildScrollView(
          child: Consumer<CustomerController>(
              builder: (context, reference, child) => Form(
                  key: formkey,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("SHIPMENT PACKAGE",
                          style: Variables.font(color: Palette.kOrange, fontWeight: FontWeight.bold, fontSize: 19)),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              "Sender Details",
                              style: Variables.font(fontSize: 18),
                            ),
                          ),
                          textboxes("Sender Name", senderName, keyboardtype: TextInputType.name),
                          textboxes("Sender Phone", senderPhone, keyboardtype: TextInputType.phone),
                          textboxes("Sender Address", SetLocationPage.pickup, isaddress: true)
                        ]),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              "Receiver Details",
                              style: Variables.font(fontSize: 18),
                            ),
                          ),
                          textboxes("Receiver Name", receiverName, keyboardtype: TextInputType.name),
                          textboxes("Receiver Phone", receiverPhone, keyboardtype: TextInputType.phone),
                          textboxes("Receiver Address", SetLocationPage.delivery, isaddress: true)
                        ]),
                      ),
                    ),
                    Consumer<UpdateScreenProvider>(builder: (context, reference1, child) {
                      return Card(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(
                                  "Payment Details",
                                  style: Variables.font(fontSize: 18),
                                ),
                                radio(true, "CASH", "ONLINE", 0, reference1, cashonly: true),
                              ])));
                    }),
                    Consumer<UpdateScreenProvider>(builder: (context, reference1, child) {
                      return Card(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(
                                  "Item Details",
                                  style: Variables.font(fontSize: 18),
                                ),
                                radio(BookOrderPage.selectedradio[0] == 1, "Collect At PickUp", "Collect At Delivery",
                                    1, reference1),
                                textboxes("Item Description", null),
                                textboxes("Approximate Cost of Item", null, keyboardtype: TextInputType.number),
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                //   child: Row(
                                //     children: [
                                //       Text("Take a Photo of your Item:", style: Variables.font(fontSize: 15)),
                                //       const SizedBox(width: 4),
                                //       FloatingActionButton.small(
                                //         heroTag: "Lback",
                                //         elevation: 1,
                                //         onPressed: () async {
                                //           var image = await ImagePicker().pickImage(source: ImageSource.camera);
                                //           if (image != null) {
                                //             reference.createNewOrder.itemImageUrl =
                                //                 base64Encode(File(image.path).readAsBytesSync());
                                //           }
                                //         },
                                //         child: const Icon(
                                //           Icons.camera_alt_rounded,
                                //           color: Colors.white,
                                //         ),
                                //         backgroundColor: Palette.deepgrey,
                                //       )
                                //     ],
                                //   ),
                                // ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1),
                                    child: Row(children: [
                                      Flexible(
                                          child: Text("Does your Item have Cash on Delivery charges?",
                                              style: Variables.font())),
                                      const SizedBox(width: 10),
                                      radio(true, "Yes", "No", 2, reference1)
                                    ])),
                                if (BookOrderPage.selectedradio[2] == 1)
                                  textboxes("Cash on Delivery Charges", null, keyboardtype: TextInputType.number)
                              ])));
                    }),
                    const SizedBox(height: 15),
                    Variables.text1(
                        head: "Delivery Charge",
                        value: "₹ ${reference.createNewOrder.deliveryCharge}",
                        vpadding: 3,
                        valueStyle: Variables.font(color: Colors.grey.shade700, fontSize: 16)),
                    ValueListenableBuilder(
                        valueListenable: cod,
                        builder: (context, int value, widget) => value > 0
                            ? Variables.text1(
                                head: "Cash on Delivery Charge",
                                value: "₹ $value",
                                valueStyle: Variables.font(color: Colors.grey.shade700, fontSize: 16))
                            : Container()),
                    ValueListenableBuilder(
                        valueListenable: cod,
                        builder: (context, int value, widget) => Variables.text1(
                            head: "Total",
                            value: "₹ ${reference.createNewOrder.deliveryCharge + value}",
                            valueStyle: Variables.font(color: Colors.grey.shade700, fontSize: 16))),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 10),
                      child: FloatingActionButton.extended(
                          onPressed: () {
                            if (formkey.currentState!.validate()) {
                              String pay = BookOrderPage.selectedradio[0] == 1 ? "CASH" : "ONLINE";
                              reference.createNewOrder.amount =
                                  reference.createNewOrder.deliveryCharge + reference.createNewOrder.codAmount;
                              reference.createNewOrder.bookingType = "SAMEDAY";
                              reference.createNewOrder.collectAtPickUp = BookOrderPage.selectedradio[1] == 1;
                              reference.createNewOrder.customerId = Variables.driverId;
                              reference.createNewOrder.createdBy = Variables.driverId;
                              reference.createNewOrder.lastModifiedBy = Variables.driverId;
                              reference.createNewOrder.payType = pay;
                              reference.createNewOrder.paymentId = "";
                              reference.createNewOrder.senderName = senderName.text;
                              reference.createNewOrder.senderPhone = senderPhone.text;
                              reference.createNewOrder.receiverName = receiverName.text;
                              reference.createNewOrder.receiverPhone = receiverPhone.text;
                              reference.createNewOrder.orderType = "STORE";
                              reference.createNewOrder.orderSource = Variables.device[Platform.isAndroid
                                  ? 0
                                  : Platform.isIOS
                                      ? 1
                                      : 2];

                              Variables.push(context, ConfirmOrderPage.routeName);
                            }
                          },
                          label: Text("Book Order", style: Variables.font(color: null))),
                    )
                  ])))),
    );
  }

  Visibility radio(bool visible, String value1, String value2, int index, UpdateScreenProvider reference,
          {bool cashonly = false}) =>
      Visibility(
          visible: visible,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Row(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(
                width: 30,
                child: Radio<int>(
                    value: 1,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    groupValue: BookOrderPage.selectedradio[index],
                    activeColor: Palette.kOrange,
                    onChanged: (value) {
                      BookOrderPage.selectedradio[index] = value;
                      reference.updateScreen();
                    }),
              ),
              Text(value1, style: Variables.font())
            ]),
            Row(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(
                width: 30,
                child: Radio<int>(
                    value: 2,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    groupValue: BookOrderPage.selectedradio[index],
                    activeColor: Palette.kOrange,
                    onChanged: (value) {
                      if (cashonly) {
                        Variables.showtoast(context, "Online Payment Gateway is not yet Ready", Icons.warning_rounded);
                      } else {
                        BookOrderPage.selectedradio[index] = value;
                      }
                      reference.updateScreen();
                    }),
              ),
              Text(value2, style: Variables.font())
            ])
          ]));

  Widget textboxes(String labelText, TextEditingController? controller,
          {bool isaddress = false, TextInputType keyboardtype = TextInputType.name}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8),
        child: TextFormField(
          controller: controller,
          keyboardType: isaddress ? TextInputType.multiline : keyboardtype,
          maxLines: isaddress ? null : 1,
          enabled: !isaddress,
          onChanged: (value) {
            if (labelText.contains("Delivery Charges")) {
              if (value.isEmpty) {
                cod.value = 0;
                customerController.createNewOrder.codAmount = 0;
              } else {
                cod.value = int.parse(value);
                customerController.createNewOrder.codAmount = int.parse(value);
              }
              customerController.createNewOrder.amount =
                  customerController.createNewOrder.deliveryCharge + customerController.createNewOrder.codAmount;
            } else if (labelText.contains("Description")) {
              if (value.isEmpty) {
                customerController.createNewOrder.itemDescription = "";
                customerController.createNewOrder.itemName = "";
              } else {
                customerController.createNewOrder.itemDescription = value;
                customerController.createNewOrder.itemName = value;
              }
            }
          },
          validator: (value) {
            if (labelText.contains("Description")) {
              if (value!.isEmpty) return "Enter $labelText";
            } else if (labelText.contains("Delivery Charges") && BookOrderPage.selectedradio[2] == 1) {
              if (value!.isEmpty) return "Enter $labelText";
            } else if (labelText.contains("Phone")) {
              if (value!.length != 10) return "Enter valid Phone Number";
              if (labelText.contains("Receiver") && value == senderPhone.text) {
                return "Receiver and Sender Phone numbers shoudn't be same";
              }
            } else if (labelText.contains("Name")) {
              if (value!.isEmpty) return "Enter $labelText";
            }
            return null;
          },
          decoration: InputDecoration(
            border: isaddress ? InputBorder.none : const UnderlineInputBorder(),
            contentPadding: EdgeInsets.zero,
            labelText: labelText,
          ),
        ),
      );

  @override
  void dispose() {
    super.dispose();
  }
}
