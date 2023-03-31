import 'package:ezshipp/Provider/customer_controller.dart';
import 'package:ezshipp/Provider/update_screenprovider.dart';
import 'package:ezshipp/pages/customer/set_addresspage.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AddAddressPage extends StatefulWidget {
  static String routeName = "/add-address";
  List<bool> addresstypesC = [false, false, true];
  int temp = 2;
  static Object? selectedradio;

  AddAddressPage({Key? key}) : super(key: key);

  @override
  AddAddressPageState createState() => AddAddressPageState();
}

class AddAddressPageState extends State<AddAddressPage> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  late CustomerController customerController;
  TextEditingController flatNumber = TextEditingController();
  TextEditingController apartment = TextEditingController();
  TextEditingController houseNumber = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController landmark = TextEditingController();

  double padding = 15;
  double avatarRadius = 45;
  List<String> addresstypes = ["Home", "Office", "Others"];

  @override
  void initState() {
    super.initState();
    customerController = Provider.of<CustomerController>(context, listen: false);
    customerController.addAddress.type = "OTHER";
    AddAddressPage.selectedradio = null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // flatNumber.clear();
        // apartment.clear();
        // houseNumber.clear();
        // street.clear();
        // landmark.clear();
        AddAddressPage.selectedradio = null;
        widget.temp = 2;
        widget.addresstypesC = [false, false, true];
        return true;
      },
      child: Scaffold(
          appBar: Variables.app(actions: [
            Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextButton(
                  onPressed: () async {
                    if (formkey.currentState!.validate()) {
                      Variables.loadingDialogue(context: context, subHeading: "Please wait ...");
                      await customerController.addCustomerAddress(
                          mounted, context, customerController.addAddress.toJson());
                      if (!mounted) return;
                      Variables.showtoast(context, "Address Saved", Icons.check);

                      if (!mounted) return;
                      await customerController.getFirstTenAddresses(mounted, context);
                      if (!mounted) return;
                      Navigator.pop(context);
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
                            // if (reference.addAddress.type.isNotEmpty)
                            //   CircleAvatar(
                            //     backgroundColor: Colors.transparent,
                            //     radius: avatarRadius,
                            //     child: ClipRRect(
                            //         borderRadius: BorderRadius.all(Radius.circular(avatarRadius)),
                            //         child: reference.addAddress.type == "HOME"
                            //             ? Image.asset("assets/icon/icons8-home-96.png")
                            //             : reference.addAddress.type == "OFFICE"
                            //                 ? Image.asset("assets/icon/icons8-office-96.png")
                            //                 : Image.asset("assets/icon/icons8-location-96.png")),
                            //   ),
                            ToggleButtons(
                                borderRadius: BorderRadius.circular(25),
                                isSelected: widget.addresstypesC,
                                children: List.generate(
                                    addresstypes.length,
                                    (index) =>
                                        Text(addresstypes[index], style: Variables.font(fontSize: 15, color: null))),
                                onPressed: (index) {
                                  if (widget.temp == -1) {
                                    widget.temp = index;
                                  } else {
                                    widget.addresstypesC[widget.temp] = false;
                                    widget.temp = index;
                                  }
                                  customerController.setAddressType(addresstypes[widget.temp].toUpperCase());
                                  widget.addresstypesC[widget.temp] = true;
                                })
                          ]);
                        }),
                        Consumer<UpdateScreenProvider>(builder: (context, reference, child) {
                          return Column(
                            children: [
                              Radio(reference),
                              if (AddAddressPage.selectedradio == 1) ...[
                                textfields("Flat Number", flatNumber),
                                textfields("Apartment/Complex Name", apartment),
                              ],
                              if (AddAddressPage.selectedradio == 2) textfields("House number", houseNumber),
                              textfields("Street/Locality Address", street, ontap: true),
                              textfields("Landmark", landmark)
                            ],
                          );
                        })
                      ]))
                ]))
          ]))),
    );
  }

  Widget textfields(String label, TextEditingController controller, {bool ontap = false}) => TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        keyboardType: TextInputType.streetAddress,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[\w\d ]"))],
        onTap: ontap && street.text.isEmpty
            ? () {
                Navigator.pushNamed(context, SetAddressPage.routeName).then((value) {
                  controller.text = value.toString() == "null" ? "" : value.toString();
                  controller.selection = TextSelection.fromPosition(const TextPosition(offset: 0));
                });
              }
            : null,
        onChanged: (value) {
          switch (label) {
            case "Apartment/Complex Name":
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
          if (label == "Apartment/Complex Name" ||
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
            "Apartment/Complex",
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
