import 'dart:convert';
import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:ezshipp/Provider/get_addresses_provider.dart';
import 'package:ezshipp/Provider/update_screenprovider.dart';
import 'package:ezshipp/pages/confirm_orderpage.dart';
import 'package:ezshipp/pages/set_locationpage.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class BookOrderPage extends StatefulWidget {
  static List<int?> selectedradio = [1, 1, 2];
  const BookOrderPage({Key? key}) : super(key: key);

  @override
  _BookOrderPageState createState() => _BookOrderPageState();
}

class _BookOrderPageState extends State<BookOrderPage> with TickerProviderStateMixin {
  List<Contact> contacts = [];
  TextEditingController senderName = TextEditingController(),
      senderPhone = TextEditingController(),
      receiverName = TextEditingController(),
      receiverPhone = TextEditingController();
  late void Function(AnimationStatus) _statusListener;
  late AnimationController _animationController;
  late SuggestionsBoxController _suggestionsBoxController;
  late GetAddressesProvider getAddressesProvider;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  ValueNotifier<int> cod = ValueNotifier<int>(0);

  String imageURL = "";
  @override
  void initState() {
    super.initState();
    getAddressesProvider = Provider.of<GetAddressesProvider>(context, listen: false);
    _animationController = AnimationController(vsync: this);
    _suggestionsBoxController = SuggestionsBoxController();
    _statusListener = (AnimationStatus status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        _suggestionsBoxController.resize();
      }
    };
    _animationController.addStatusListener(_statusListener);
    getAllContacts();
  }

  getAllContacts() async {
    if (await Permission.contacts.request().isGranted) {
      List<Contact> _contacts = await ContactsService.getContacts(withThumbnails: true);
      setState(() {
        contacts = _contacts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Variables.app(),
      body: contacts.isNotEmpty
          ? SingleChildScrollView(
              child: Consumer<GetAddressesProvider>(
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
                              text("Sender Name", senderName, senderPhone, keyboardtype: TextInputType.name),
                              text("Sender Phone", senderPhone, senderName, keyboardtype: TextInputType.phone),
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
                              text("Receiver Name", receiverName, receiverPhone, keyboardtype: TextInputType.name),
                              text("Receiver Phone", receiverPhone, receiverName, keyboardtype: TextInputType.phone),
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
                                    radio(BookOrderPage.selectedradio[0] == 1, "Collect At PickUp",
                                        "Collect At Delivery", 1, reference1),
                                    textboxes("Item Description", null),
                                    textboxes("Approximate Cost of Item", null, keyboardtype: TextInputType.number),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1),
                                        child: Row(children: [
                                          Text("Take a Photo of your Item", style: Variables.font()),
                                          const SizedBox(width: 20),
                                          FloatingActionButton.small(
                                            elevation: 3,
                                            heroTag: "capture",
                                            onPressed: () async {
                                              XFile? image;
                                              try {
                                                image = await ImagePicker().pickImage(source: ImageSource.camera);
                                              } catch (e) {
                                                Variables.showtoast("Invlalid Image");
                                              } finally {
                                                if (image != null) {
                                                  List<int> bytes = await File(image.path).readAsBytes();
                                                  reference.createOrder.itemImageUrl = base64Encode(bytes) ;
                                                }
                                              }
                                            },
                                            child: const Icon(LineIcons.retroCamera),
                                          )
                                        ])),
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
                            value: "₹ ${reference.delivery}",
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
                                value: "₹ ${reference.delivery + value}",
                                valueStyle: Variables.font(color: Colors.grey.shade700, fontSize: 16))),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0, bottom: 10),
                          child: FloatingActionButton.extended(
                              onPressed: () {
                                if (formkey.currentState!.validate()) {
                                  String pay = BookOrderPage.selectedradio[0] == 1 ? "CASH" : "ONLINE";
                                  reference.createOrder.bookingType = "SAMEDAY";
                                  reference.createOrder.collectAtPickUp = BookOrderPage.selectedradio[1] == 1;
                                  reference.createOrder.customerId = Variables.driverId;
                                  reference.createOrder.payType = pay;
                                  reference.createOrder.paymentId = "";
                                  reference.createOrder.senderName = senderName.text;
                                  reference.createOrder.senderPhone = senderPhone.text;
                                  reference.createOrder.receiverName = receiverName.text;
                                  reference.createOrder.receiverPhone = receiverPhone.text;
                                  reference.createOrder.orderType = "STORE";
                                  reference.createOrder.orderSource = Variables.device[Platform.isAndroid
                                      ? 0
                                      : Platform.isIOS
                                          ? 1
                                          : 2];
                                  Variables.push(context, const ConfirmOrderPage());
                                }
                              },
                              label: Text("Book Order", style: Variables.font(color: null))),
                        )
                      ]))))
          : const Center(child: CircularProgressIndicator.adaptive()),
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
                        Variables.showtoast("Online Payment Gateway is not yet Ready");
                      } else {
                        BookOrderPage.selectedradio[index] = value;
                      }
                      reference.updateScreen();
                    }),
              ),
              Text(value2, style: Variables.font())
            ])
          ]));

  Padding text(String labelText, TextEditingController? controller, TextEditingController? controller2,
          {TextInputType keyboardtype = TextInputType.none}) =>
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: TypeAheadFormField<Contact>(
            hideOnEmpty: true,
            hideOnLoading: true,
            debounceDuration: const Duration(microseconds: 10),
            validator: (value) {
              if (value!.isEmpty) return "Enter $labelText";
              return null;
            },
            textFieldConfiguration: TextFieldConfiguration(
                controller: controller,
                keyboardType: keyboardtype,
                decoration: InputDecoration(contentPadding: EdgeInsets.zero, labelText: labelText)),
            onSuggestionSelected: (suggestion) {
              String phone = suggestion.phones!.isNotEmpty
                  ? suggestion.phones!.elementAt(0).value!.trim().replaceAll(RegExp(r"^(\+91)|\D"), "")
                  : "";
              if (labelText.contains("Phone")) {
                controller!.text = phone;
                controller2!.text = suggestion.displayName!;
              } else {
                controller!.text = suggestion.displayName!;
                controller2!.text = phone;
              }
            },
            itemBuilder: (context, contact) => Row(mainAxisSize: MainAxisSize.min, children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: contact.avatar != null && contact.avatar!.isNotEmpty
                          ? CircleAvatar(backgroundImage: MemoryImage(contact.avatar!))
                          : CircleAvatar(child: Text(contact.initials()))),
                  const SizedBox(width: 15),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(contact.displayName!.trim(), style: Variables.font()),
                      if (contact.phones!.isNotEmpty)
                        Text(contact.phones!.elementAt(0).value!.trim(),
                            style: Variables.font(fontSize: 12, color: Colors.grey))
                    ],
                  )
                ]),
            suggestionsCallback: (value) {
              if (value.isEmpty) {
                return List<Contact>.empty();
              } else {
                return contacts.where((element) {
                  if (element.displayName!.toLowerCase().contains(value.toLowerCase())) return true;
                  String phone = element.phones!.isNotEmpty
                      ? element.phones!.elementAt(0).value!.trim().replaceAll(RegExp(r"^(\+91)|\D"), "")
                      : "";
                  return phone.contains(value);
                }).toList();
              }
            }),
      );

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
                getAddressesProvider.createOrder.codAmount = 0;
              } else {
                cod.value = int.parse(value);
                getAddressesProvider.createOrder.codAmount = int.parse(value);
              }
              getAddressesProvider.createOrder.amount =
                  getAddressesProvider.delivery + getAddressesProvider.createOrder.codAmount;
            } else if (labelText.contains("Description")) {
              if (value.isEmpty) {
                getAddressesProvider.createOrder.itemDescription = "";
                getAddressesProvider.createOrder.itemName = "";
              } else {
                getAddressesProvider.createOrder.itemDescription = value;
                getAddressesProvider.createOrder.itemName = value;
              }
            }
          },
          validator: (value) {
            if (labelText.contains("Description")) {
              if (value!.isEmpty) return "Enter $labelText";
            } else if (labelText.contains("Delivery Charges") && BookOrderPage.selectedradio[2] == 1) {
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
    _animationController.removeStatusListener(_statusListener);
    _animationController.dispose();
    super.dispose();
  }
}
