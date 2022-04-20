import 'package:ezshipp/APIs/create_order.dart';
import 'package:ezshipp/Provider/maps_provider.dart';
import 'package:ezshipp/Provider/update_screenprovider.dart';
import 'package:ezshipp/pages/customer/book_orderpage.dart';
import 'package:ezshipp/pages/customer/confirm_addresspage.dart';
import 'package:ezshipp/pages/customer/customer_homepage.dart';
import 'package:ezshipp/pages/customer/set_locationpage.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Provider/customer_controller.dart';
import '../../utils/themes.dart';

class ConfirmOrderPage extends StatefulWidget {
  static String routeName = "/confirm";
  static bool check = false;
  const ConfirmOrderPage({Key? key}) : super(key: key);

  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  late CustomerController customerController;
  late MapsProvider mapsProvider;

  @override
  Widget build(BuildContext context) {
    customerController = Provider.of<CustomerController>(context, listen: false);
    mapsProvider = Provider.of<MapsProvider>(context, listen: false);
    CreateOrder co = customerController.createNewOrder;
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
              Variables.text(context, head: "", value: "Sender Details", valueColor: Palette.deepgrey, vpadding: 6),
              const SizedBox(height: 5),
              Variables.text(context, head: "Name: ", value: co.senderName, vpadding: 4),
              Variables.text(context, head: "Phone: ", value: co.senderPhone, vpadding: 4),
              Variables.text(context, head: "Address:\n", value: SetLocationPage.pickup.text, vpadding: 4),
              if (customerController.addAddress.landmark.isNotEmpty)
                Variables.text(context, head: "Landmark: ", value: customerController.addAddress.landmark, vpadding: 4),
              const Divider(),
              Variables.text(context, head: "", value: "Receiver Details", valueColor: Palette.deepgrey, vpadding: 6),
              const SizedBox(height: 5),
              Variables.text(context, head: "Name: ", value: co.receiverName, vpadding: 4),
              Variables.text(context, head: "Phone: ", value: co.receiverPhone, vpadding: 4),
              Variables.text(context, head: "Address:\n", value: SetLocationPage.delivery.text, vpadding: 4),
              if (customerController.addAddress1.landmark.isNotEmpty)
                Variables.text(context,
                    head: "Landmark: ", value: customerController.addAddress1.landmark, vpadding: 4),
              const SizedBox(height: 5),
              Variables.text(context,
                  head: "Item: ", value: co.itemDescription, vpadding: 3, linkvalue: co.itemImageUrl, islink: true),
              const SizedBox(height: 5),
              Variables.text(context, head: "", value: "Payment Details", valueColor: Palette.deepgrey, vpadding: 6),
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
          onPressed: () async {
            if (!ConfirmOrderPage.check) {
              Variables.showtoast(context, "Accept the Package & Delivery Policies", Icons.warning_rounded);
            } else {
              await customerController.creatOrder(context);

              ConfirmAddressPage.selectedradio = [null, null];
              ConfirmAddressPage.toggle = [false, false];
              ConfirmAddressPage.temp = [2, 2];
              if (customerController.timer != null) customerController.settimer(context);
              SetLocationPage.pickup.clear();
              SetLocationPage.delivery.clear();
              mapsProvider.pickmark = null;
              mapsProvider.dropmark = null;
              mapsProvider.info.clear();
              ConfirmOrderPage.check = false;
              BookOrderPage.selectedradio = [1, 1, 2];
              customerController.getCustomerInProgressOrderCount(context);
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(CustomerHomePage.routeName, (Route<dynamic> route) => false);
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
