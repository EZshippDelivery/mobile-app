import 'package:ezshipp/Provider/customer_controller.dart';
import 'package:ezshipp/Provider/update_screenprovider.dart';
import 'package:ezshipp/pages/customer/set_addresspage.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddAddressPage extends StatefulWidget {
  static String routeName = "/add-address";
  static List<bool> addresstypesC = [false, false, true];
  static int temp = 2;
  static Object? selectedradio;
  static TextEditingController controller = TextEditingController();
  const AddAddressPage({Key? key}) : super(key: key);

  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  double padding = 15;
  double avatarRadius = 45;

  late CustomerController customerController;

  List<String> addresstypes = ["Home", "Office", "Others"];

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    customerController = Provider.of<CustomerController>(context, listen: false);
    customerController.addAddress.type = "OTHER";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Variables.app(actions: [
          Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton(
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    customerController.addCustomerAddress(context, customerController.addAddress.toJson());
                    Variables.showtoast(context, "Address Saved", Icons.check);
                    AddAddressPage.controller.clear();
                    customerController.getFirstTenAddresses(context);
                    Variables.pop(context);
                  }
                },
                child: Text("Save", style: Variables.font(fontSize: 16, color: null)),
              ))
        ]),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              padding: EdgeInsets.only(left: padding, top: padding, right: padding, bottom: padding),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Form(
                    key: formkey,
                    child: Column(children: [
                      Consumer<CustomerController>(builder: (context, reference, child) {
                        return Column(children: [
                          if (reference.addAddress.type.isNotEmpty)
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: avatarRadius,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(avatarRadius)),
                                  child: reference.addAddress.type == "HOME"
                                      ? Image.asset("assets/icon/icons8-home-96.png")
                                      : reference.addAddress.type == "OFFICE"
                                          ? Image.asset("assets/icon/icons8-office-96.png")
                                          : Image.asset("assets/icon/icons8-location-96.png")),
                            ),
                          ToggleButtons(
                              borderRadius: BorderRadius.circular(25),
                              isSelected: AddAddressPage.addresstypesC,
                              children: List.generate(
                                  addresstypes.length,
                                  (index) =>
                                      Text(addresstypes[index], style: Variables.font(fontSize: 15, color: null))),
                              onPressed: (index) {
                                if (AddAddressPage.temp == -1) {
                                  AddAddressPage.temp = index;
                                } else {
                                  AddAddressPage.addresstypesC[AddAddressPage.temp] = false;
                                  AddAddressPage.temp = index;
                                }
                                customerController.setAddressType(addresstypes[AddAddressPage.temp].toUpperCase());
                                AddAddressPage.addresstypesC[AddAddressPage.temp] = true;
                              })
                        ]);
                      }),
                      Consumer<UpdateScreenProvider>(builder: (context, reference, child) {
                        return Column(
                          children: [
                            Radio(reference),
                            if (AddAddressPage.selectedradio == 1) ...[
                              textfields("Appartment/Complex Name"),
                              textfields("Flat Number")
                            ],
                            if (AddAddressPage.selectedradio == 2) textfields("House number"),
                            textfields("Street/Locality Address", ontap: true),
                            textfields("Landmark")
                          ],
                        );
                      })
                    ]))
              ]))
        ])));
  }

  dynamic textfields(String label, {bool ontap = false}) => TextFormField(
        controller: ontap ? AddAddressPage.controller : null,
        decoration: InputDecoration(labelText: label),
        keyboardType: TextInputType.streetAddress,
        onTap: ontap
            ? () {
                Variables.push(context, SetAddressPage.routeName);
              }
            : null,
        onChanged: (value) {
          switch (label) {
            case "Appartment/Complex Name":
              customerController.addAddress.complexName = value;
              break;
            case "Flat Number":
              customerController.addAddress.apartment = value;
              break;
            case "House Number":
              customerController.addAddress.address2 = customerController.addAddress.address1;
              customerController.addAddress.address1 = value;
              break;
            case "Landmark":
              customerController.addAddress.landmark = value;
              break;
          }
        },
        validator: (value) {
          if (label == "Appartment/Complex Name" ||
              label == "Flat Number" ||
              label == "House number" ||
              label == "Street/Locality Address") {
            if (value!.isEmpty) return "Enter $label";
          }
          return null;
        },
      );
  @override
  void dispose() {
    AddAddressPage.controller.dispose();
    super.dispose();
  }
}

// ignore: must_be_immutable
class Radio extends StatefulWidget {
  UpdateScreenProvider updateScreen;
  Radio(
    this.updateScreen, {
    Key? key,
  }) : super(key: key);

  @override
  State<Radio> createState() => _RadioState();
}

class _RadioState extends State<Radio> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile(
          value: 1,
          groupValue: AddAddressPage.selectedradio,
          activeColor: Palette.kOrange,
          onChanged: (value) {
            setState(() => AddAddressPage.selectedradio = value);
            widget.updateScreen.updateScreen();
          },
          title: Text(
            "Appartment/Complex",
            style: Variables.font(fontSize: 15),
          ),
        ),
        RadioListTile(
          value: 2,
          groupValue: AddAddressPage.selectedradio,
          activeColor: Palette.kOrange,
          onChanged: (value) {
            setState(() => AddAddressPage.selectedradio = value);
            widget.updateScreen.updateScreen();
          },
          title: Text(
            "Street/Individual",
            style: Variables.font(fontSize: 15),
          ),
        )
      ],
    );
  }
}
