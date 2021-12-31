import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/get_addresses_provider.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({Key? key}) : super(key: key);

  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  double padding = 15;
  double avatarRadius = 45;
  late GetAddressesProvider getAddressesProvider;
  List<bool> addresstypesC = [false, false, false];
  List<String> addresstypes = ["Home", "Office", "Others"];
  int temp = -1;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  Object? selectedradio;
  TextEditingController controller = TextEditingController();

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
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    getAddressesProvider.addAddresses(getAddressesProvider.addAddress.toJson());
                    Variables.pop(context);
                  }
                },
                child: Text("Save", style: Variables.font(fontSize: 16, color: null)),
              ))
        ]),
        body: Consumer<GetAddressesProvider>(builder: (context, reference, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: padding, top: padding, right: padding, bottom: padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                          key: formkey,
                          child: Column(
                            children: [
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
                                  isSelected: addresstypesC,
                                  children: List.generate(
                                      addresstypes.length,
                                      (index) =>
                                          Text(addresstypes[index], style: Variables.font(fontSize: 15, color: null))),
                                  onPressed: (index) {
                                    setState(() {
                                      if (temp == -1) {
                                        temp = index;
                                      } else {
                                        addresstypesC[temp] = false;
                                        temp = index;
                                      }
                                      getAddressesProvider.setAddressType(addresstypes[temp].toUpperCase());
                                      addresstypesC[temp] = true;
                                    });
                                  }),
                              RadioListTile(
                                value: 1,
                                groupValue: selectedradio,
                                activeColor: Palette.kOrange,
                                onChanged: (value) => setState(() => selectedradio = value),
                                title: Text(
                                  "Appartment/Complex",
                                  style: Variables.font(fontSize: 15),
                                ),
                              ),
                              RadioListTile(
                                value: 2,
                                groupValue: selectedradio,
                                activeColor: Palette.kOrange,
                                onChanged: (value) => setState(() => selectedradio = value),
                                title: Text(
                                  "Street/Individual",
                                  style: Variables.font(fontSize: 15),
                                ),
                              ),
                              if (selectedradio == 1) ...[
                                textfields("Appartment/Complex Name"),
                                textfields("Flat Number")
                              ],
                              if (selectedradio == 2) textfields("House number"),
                              textfields("Street/Locality Address", ontap: true),
                              textfields("Landmark")
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            ),
          );
        }));
  }

  dynamic textfields(String label, {bool ontap = false}) => TextFormField(
        controller: ontap ? controller : null,
        decoration: InputDecoration(labelText: label),
        keyboardType: TextInputType.streetAddress,
        onTap: ontap
            ? () {
                Variables.showtoast("Clicked");
              }
            : null,
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
    getAddressesProvider.dispose();
    controller.dispose();
    super.dispose();
  }
}
