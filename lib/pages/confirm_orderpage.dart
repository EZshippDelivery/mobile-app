import 'package:ezshipp/APIs/create_order.dart';
import 'package:ezshipp/Provider/get_addresses_provider.dart';
import 'package:ezshipp/Provider/update_screenprovider.dart';
import 'package:ezshipp/pages/set_locationpage.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/themes.dart';

class ConfirmOrderPage extends StatefulWidget {
  static bool check = false;
  const ConfirmOrderPage({Key? key}) : super(key: key);

  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  late GetAddressesProvider getAddressesProvider;

  @override
  Widget build(BuildContext context) {
    getAddressesProvider = Provider.of<GetAddressesProvider>(context, listen: false);
    CreateOrder co = getAddressesProvider.createOrder;
    return Scaffold(
        appBar: Variables.app(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 10),
                    child: Text("ORDER SUMMARY",
                        style: Variables.font(color: Palette.kOrange, fontWeight: FontWeight.bold, fontSize: 19))),
              ),
              Variables.text(head: "", value: "Sender Details", valueColor: Palette.deepgrey, vpadding: 6),
              const SizedBox(height: 5),
              Variables.text(head: "Name: ", value: co.senderName, vpadding: 4),
              Variables.text(head: "Phone: ", value: co.senderPhone, vpadding: 4),
              Variables.text(head: "Address:\n", value: SetLocationPage.pickup.text, vpadding: 4),
              if (getAddressesProvider.addAddress.landmark.isNotEmpty)
                Variables.text(head: "Landmark: ", value: getAddressesProvider.addAddress.landmark, vpadding: 4),
              const Divider(),
              Variables.text(head: "", value: "Receiver Details", valueColor: Palette.deepgrey, vpadding: 6),
              const SizedBox(height: 5),
              Variables.text(head: "Name: ", value: co.receiverName, vpadding: 4),
              Variables.text(head: "Phone: ", value: co.receiverPhone, vpadding: 4),
              Variables.text(head: "Address:\n", value: SetLocationPage.delivery.text, vpadding: 4),
              if (getAddressesProvider.addAddress1.landmark.isNotEmpty)
                Variables.text(head: "Landmark: ", value: getAddressesProvider.addAddress1.landmark, vpadding: 4),
              const SizedBox(height: 5),
              Variables.text(head: "Item: ", value: co.itemDescription, vpadding: 4),
              const SizedBox(height: 5),
              Variables.text(head: "", value: "Payment Details", valueColor: Palette.deepgrey, vpadding: 6),
              const SizedBox(height: 5),
              Variables.text1(
                  head: "Payment Type",
                  value: co.payType,
                  valueStyle: Variables.font(color: Colors.grey.shade700, fontSize: 16)),
              Variables.text1(
                  head: "Delivery charges",
                  value: "₹ ${co.deliveryCharge}",
                  valueStyle: Variables.font(color: Colors.grey.shade700, fontSize: 16)),
              if (co.codAmount > 0)
                Variables.text1(
                    head: "COD charges",
                    value: "₹ ${co.codAmount}",
                    valueStyle: Variables.font(color: Colors.grey.shade700, fontSize: 16)),
              Variables.text1(
                  head: "Total",
                  value: "₹ ${co.amount}",
                  valueStyle: Variables.font(color: Colors.grey.shade700, fontSize: 16)),
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Consumer<UpdateScreenProvider>(builder: (context, reference, child) {
                  return Checkbox(
                    value: ConfirmOrderPage.check,
                    onChanged: (value) {
                      ConfirmOrderPage.check = value!;
                      reference.updateScreen();
                    },
                    activeColor: Palette.kOrange,
                  );
                }),
                Container(
                    padding: const EdgeInsets.only(right: 15.0),
                    width: MediaQuery.of(context).size.width - 48,
                    child: RichText(
                        text: TextSpan(
                            text: "Accept that you have read and agree to the ezshipp ",
                            style: Variables.font(color: Palette.deepgrey, fontSize: 15),
                            children: [
                          TextSpan(
                              text: "Package & Delivery Policies",
                              style: Variables.font(color: Palette.kOrange, fontSize: 15),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => _launchURL("https://www.ezshipp.com/package-delivery-policy/"))
                        ])))
              ]),
              const SizedBox(height: 70)
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (!ConfirmOrderPage.check) {
              Variables.showtoast("Accept the Package & Delivery Policies");
            } else {
              getAddressesProvider.createOrderPost(context);
              UpdateScreenProvider updateScreenProvider = Provider.of(context, listen: false);
              if (updateScreenProvider.timer != null) updateScreenProvider.settimer(context);
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
          },
          label: Text("Confirm", style: Variables.font(color: null)),
          icon: const Icon(Icons.check_rounded),
        ));
  }

  _launchURL(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }
}
