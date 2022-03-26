import 'package:ezshipp/Provider/update_screenprovider.dart';
import 'package:ezshipp/pages/set_locationpage.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/get_addresses_provider.dart';
import 'book_orderpage.dart';

class ConfirmAddressPage extends StatefulWidget {
  static String routeName = "/confirm-address";
  static List<List<bool>> addresstypesC = [
    [false, false, true],
    [false, false, true]
  ];
  static List<Object?> selectedradio = [null, null];
  static List<bool> toggle = [false, false];
  static List<int> temp = [2, 2];
  const ConfirmAddressPage({Key? key}) : super(key: key);

  @override
  _ConfirmAddressPageState createState() => _ConfirmAddressPageState();
}

class _ConfirmAddressPageState extends State<ConfirmAddressPage> {
  double padding = 15;
  double avatarRadius = 45;
  late GetAddressesProvider getAddressesProvider;

  List<String> addresstypes = ["Home", "Office", "Others"];

  List<GlobalKey<FormState>> formkey = [GlobalKey<FormState>(), GlobalKey<FormState>()];

  TextEditingController landmark = TextEditingController(), landmark1 = TextEditingController();
  TextEditingController houseNumber = TextEditingController(), houseNumber1 = TextEditingController();
  TextEditingController flatNumber = TextEditingController(), flatNumber1 = TextEditingController();
  TextEditingController appartment = TextEditingController(), appartment1 = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAddressesProvider = Provider.of<GetAddressesProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Variables.app(actions: [
          Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton(
                onPressed: () async {
                  bool form = formkey[1].currentState!.validate();
                  bool form1 = formkey[0].currentState!.validate();
                  if (form && form1) {
                    await getAddressesProvider.saveAllAddresses(context, getAddressesProvider.addAddress, 0);
                    await getAddressesProvider.saveAllAddresses(context, getAddressesProvider.addAddress1, 1);
                    Variables.push(context, BookOrderPage.routeName);
                  }
                },
                child: Text("Save", style: Variables.font(fontSize: 16, color: null)),
              ))
        ]),
        body: Consumer<GetAddressesProvider>(builder: (context, reference, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("CONFIRM ADDRESSES",
                      style: Variables.font(color: Palette.kOrange, fontWeight: FontWeight.bold, fontSize: 19)),
                ),
                addressCard("PickUp Address", reference.addAddress.type, 0,
                    [SetLocationPage.pickup, landmark, houseNumber, flatNumber, appartment], false),
                addressCard("Delivery Address", reference.addAddress1.type, 1,
                    [SetLocationPage.delivery, landmark1, houseNumber1, flatNumber1, appartment1], true),
              ],
            ),
          );
        }));
  }

  Card addressCard(String address, String type, int index, List<TextEditingController> controller, bool isDelivery) {
    return Card(
      child: Container(
        padding: EdgeInsets.only(left: padding, top: padding, right: padding, bottom: padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
                key: formkey[index],
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_pin,
                              color: address.startsWith("P") ? Colors.green : Colors.red,
                            ),
                            Text(address, style: Variables.font(fontSize: 18, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        // IconButton(
                        //     iconSize: 18,
                        //     onPressed: () {
                        //       ConfirmAddressPage.toggle[index] = !ConfirmAddressPage.toggle[index];
                        //     },
                        //     icon: ConfirmAddressPage.toggle[index]
                        //         ? const Icon(Icons.favorite, color: Colors.red)
                        //         : const Icon(Icons.favorite_border_rounded))
                      ],
                    ),
                    if (type.isNotEmpty)
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: avatarRadius,
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(avatarRadius)),
                            child: type == "HOME"
                                ? Image.asset("assets/icon/icons8-home-96.png")
                                : type == "OFFICE"
                                    ? Image.asset("assets/icon/icons8-office-96.png")
                                    : Image.asset("assets/icon/icons8-location-96.png")),
                      ),
                    ToggleButtons(
                        borderRadius: BorderRadius.circular(25),
                        isSelected: ConfirmAddressPage.addresstypesC[index],
                        children: List.generate(addresstypes.length,
                            (index) => Text(addresstypes[index], style: Variables.font(fontSize: 15, color: null))),
                        onPressed: (value) {
                          if (ConfirmAddressPage.temp[index] == -1) {
                            ConfirmAddressPage.temp[index] = value;
                          } else {
                            ConfirmAddressPage.addresstypesC[index][ConfirmAddressPage.temp[index]] = false;
                            ConfirmAddressPage.temp[index] = value;
                          }
                          getAddressesProvider.setAddressType(
                              addresstypes[ConfirmAddressPage.temp[index]].toUpperCase(),
                              isdelivery: isDelivery);
                          ConfirmAddressPage.addresstypesC[index][ConfirmAddressPage.temp[index]] = true;
                        }),
                    Consumer<UpdateScreenProvider>(builder: (context, reference, child) {
                      return Column(children: [
                        Radio(index, reference),
                        if (ConfirmAddressPage.selectedradio[index] == 1) ...[
                          textfields("Appartment/Complex Name", index, controller: controller[4]),
                          textfields("Flat Number", index, controller: controller[3])
                        ],
                        if (ConfirmAddressPage.selectedradio[index] == 2)
                          textfields("House number", index, controller: controller[2]),
                        textfields("Street/Locality Address", index, controller: controller[0]),
                        textfields("Landmark", index, controller: controller[1])
                      ]);
                    })
                  ],
                )),
          ],
        ),
      ),
    );
  }

  dynamic textfields(String label, int index, {controller}) => TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        keyboardType: TextInputType.streetAddress,
        enabled: label == "Street/Locality Address" ? false : true,
        maxLines: null,
        onChanged: (value) {
          if (index == 0) {
            switch (label) {
              case "Appartment/Complex Name":
                getAddressesProvider.addAddress.complexName = value;
                break;
              case "Flat Number":
                getAddressesProvider.addAddress.apartment = value;
                break;
              case "House Number":
                getAddressesProvider.addAddress.address2 = getAddressesProvider.addAddress.address1;
                getAddressesProvider.addAddress.address1 = value;
                break;
              case "Landmark":
                getAddressesProvider.addAddress.landmark = value;
                break;
            }
          } else {
            switch (label) {
              case "Appartment/Complex Name":
                getAddressesProvider.addAddress1.complexName = value;
                break;
              case "Flat Number":
                getAddressesProvider.addAddress1.apartment = value;
                break;
              case "House Number":
                getAddressesProvider.addAddress1.address2 = getAddressesProvider.addAddress.address1;
                getAddressesProvider.addAddress1.address1 = value;
                break;
              case "Landmark":
                getAddressesProvider.addAddress1.landmark = value;
                break;
            }
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
}

// ignore: must_be_immutable
class Radio extends StatefulWidget {
  int index;
  UpdateScreenProvider updateScreen;
  Radio(
    this.index,
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
          groupValue: ConfirmAddressPage.selectedradio[widget.index],
          activeColor: Palette.kOrange,
          onChanged: (value) {
            setState(() => ConfirmAddressPage.selectedradio[widget.index] = value);
            widget.updateScreen.updateScreen();
          },
          title: Text(
            "Appartment/Complex",
            style: Variables.font(fontSize: 15),
          ),
        ),
        RadioListTile(
          value: 2,
          groupValue: ConfirmAddressPage.selectedradio[widget.index],
          activeColor: Palette.kOrange,
          onChanged: (value) {
            setState(() => ConfirmAddressPage.selectedradio[widget.index] = value);
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
