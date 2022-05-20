import 'package:ezshipp/pages/customer/add_addresspage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Provider/customer_controller.dart';
import '../../utils/variables.dart';

class SavedAddressPage extends StatefulWidget {
  static String routeName = "/saved-addresses";
  static bool delete = false;
  const SavedAddressPage({Key? key}) : super(key: key);

  @override
  SavedAddressPageState createState() => SavedAddressPageState();
}

class SavedAddressPageState extends State<SavedAddressPage> {
  double padding = 15;
  double avatarRadius = 45;

  late CustomerController customerController;
  List<bool> addresstypesC = [false, false, false];
  List<String> addresstypes = ["Home", "Office", "Others"];
  int temp = -1;

  @override
  void initState() {
    super.initState();
    customerController = Provider.of<CustomerController>(context, listen: false);
    Future.delayed(Duration.zero, () => constructor());
  }

  void constructor() async {
    Variables.loadingDialogue(context: context, subHeading: "Please wait ...");
    await customerController.getFirstTenAddresses(mounted, context);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Variables.app(
          //   actions: [
          //   TextButton(
          //       onPressed: () => setState(() => SavedAddressPage.delete = !SavedAddressPage.delete),
          //       child: Text(SavedAddressPage.delete ? "Cancel" : "Edit", style: Variables.font(fontSize: 15, color: null)))
          // ]
          ),
      body: Consumer<CustomerController>(builder: (context, reference, child) {
        if (reference.getFirstTenAddress.isNotEmpty) {
          return ListView.separated(
              itemCount: reference.getFirstTenAddress.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                var addressType2 = reference.getFirstTenAddress[index].addressType;
                var data = reference.getFirstTenAddress[index].apartment +
                    (reference.getFirstTenAddress[index].apartment.isNotEmpty
                        ? "\n${reference.getFirstTenAddress[index].address1}"
                        : reference.getFirstTenAddress[index].address1);
                return ListTile(
                    contentPadding: const EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
                    leading: reference.getFirstTenAddress[index].addressType == "HOME"
                        ? Image.asset("assets/icon/icons8-home-96.png")
                        : reference.getFirstTenAddress[index].addressType == "OFFICE"
                            ? Image.asset("assets/icon/icons8-office-96.png")
                            : Image.asset("assets/icon/icons8-location-96.png"),
                    title: Text("${addressType2[0]}${addressType2.substring(1).toLowerCase()}",
                        style: Variables.font(fontSize: 17)),
                    subtitle: Text(data, style: Variables.font(color: Colors.grey.shade600, fontSize: 15)),
                    trailing: SavedAddressPage.delete
                        ? IconButton(
                            icon: const Icon(Icons.delete_forever_rounded),
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            splashRadius: 20)
                        : null,
                    onTap: () async => await showDialog(
                        context: context,
                        builder: (context) => Dialog(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(padding)),
                            child: Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      left: padding, top: avatarRadius, right: padding, bottom: padding),
                                  margin: EdgeInsets.only(top: avatarRadius),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(padding),
                                    boxShadow: const [
                                      BoxShadow(color: Colors.black, offset: Offset(0, 3), blurRadius: 10)
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "${addressType2[0]}${addressType2.substring(1).toLowerCase()}",
                                        style: Variables.font(fontSize: 22, fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 15),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Variables.text(context,
                                              head: "Apartment/House no. :\n",
                                              value: reference.getFirstTenAddress[index].apartment,
                                              valueColor: Colors.grey,
                                              vpadding: 5),
                                          Container(
                                              child: Variables.text(context,
                                                  head: "Address:\n",
                                                  value: reference.getFirstTenAddress[index].address1,
                                                  valueColor: Colors.grey,
                                                  vpadding: 5)),
                                          Variables.text(context,
                                              head: "Landmark:\n",
                                              value: reference.getFirstTenAddress[index].landmark,
                                              valueColor: Colors.grey,
                                              vpadding: 5),
                                        ],
                                      ),
                                      Flexible(
                                        flex: 0,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () => Variables.pop(context),
                                                child:
                                                    Text("Cancel", style: Variables.font(color: null, fontSize: 16))),
                                            ElevatedButton(
                                                onPressed: () {
                                                  Variables.pop(context);
                                                },
                                                child: Text("Delete", style: Variables.font(color: null, fontSize: 16)))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                    left: padding,
                                    right: padding,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: avatarRadius,
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(avatarRadius)),
                                          child: reference.getFirstTenAddress[index].addressType == "HOME"
                                              ? Image.asset("assets/icon/icons8-home-96.png")
                                              : reference.getFirstTenAddress[index].addressType == "OFFICE"
                                                  ? Image.asset("assets/icon/icons8-office-96.png")
                                                  : Image.asset("assets/icon/icons8-location-96.png")),
                                    ))
                              ],
                            ))));
              });
        }
        return Center(child: Text("No Saved Addresses", style: Variables.font(fontSize: 16)));
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Variables.push(context, AddAddressPage.routeName);
        },
        label: Text("Add Address", style: Variables.font(color: null, fontSize: 15)),
        icon: const Icon(Icons.add_location_alt_rounded),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
