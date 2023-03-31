import 'dart:io';

import 'package:ezshipp/APIs/get_top_addresses.dart';
import 'package:ezshipp/Provider/maps_provider.dart';
import 'package:ezshipp/Provider/update_screenprovider.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../Provider/customer_controller.dart';

// ignore: must_be_immutable
class SetAddressPage extends StatefulWidget {
  static String routeName = "/set-address";
  int listIndex = 0;
  bool maptap = false;
  TextEditingController pickup = TextEditingController();
  SetAddressPage({Key? key}) : super(key: key);

  @override
  SetAddressPageState createState() => SetAddressPageState();
}

class SetAddressPageState extends State<SetAddressPage> {
  late GoogleMapController mapController;
  late MapsProvider mapsProvider;
  late UpdateScreenProvider updateScreenProvider;
  late CustomerController customerController;
  LatLng? screenCoordinates;
  FocusNode focusNode = FocusNode();

  List<GetAllAddresses> recentAddress = [];

  @override
  void initState() {
    super.initState();
    mapsProvider = Provider.of<MapsProvider>(context, listen: false);
    updateScreenProvider = Provider.of<UpdateScreenProvider>(context, listen: false);
    Future.delayed(Duration.zero, () => constructor());
    customerController = Provider.of<CustomerController>(context, listen: false);
  }

  constructor() async {
    Variables.loadingDialogue(context: context, subHeading: "Please wait ...");
    mapsProvider.getCurrentlocations();
    await mapsProvider.setCurrentLocation(mounted, context, Variables.driverId, addAddress: true);
    mapsProvider.pickmark = null;
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final devicePixelRatio = Platform.isAndroid ? MediaQuery.of(context).devicePixelRatio : 1.0;
    return Consumer<MapsProvider>(builder: (context, reference, child) {
      return WillPopScope(
        onWillPop: () async {
          reference.clear();
          return true;
        },
        child: Scaffold(
            appBar: Variables.app(),
            body: Stack(
              children: [
                reference.latitude > 0 && reference.longitude > 0
                    ? GoogleMap(
                        onCameraIdle: () async {
                          screenCoordinates = await mapController.getLatLng(ScreenCoordinate(
                            x: (size.width * devicePixelRatio) ~/ 2.0,
                            y: (size.height * devicePixelRatio) ~/ 2.0,
                          ));
                        },
                        onTap: (value) {
                          widget.maptap = true;
                          updateScreenProvider.updateScreen();
                        },
                        onMapCreated: ((controller) => mapController = controller),
                        markers: {if (reference.pickmark != null) reference.pickmark!},
                        initialCameraPosition:
                            CameraPosition(target: LatLng(reference.latitude, reference.longitude), zoom: 10),
                        myLocationEnabled: true,
                        zoomControlsEnabled: false,
                      )
                    : const Center(child: CircularProgressIndicator.adaptive()),
                Consumer<UpdateScreenProvider>(builder: (context, snapshot, child) {
                  return Stack(
                    children: [
                      if (widget.maptap)
                        Positioned(
                          bottom: MediaQuery.of(context).viewInsets.bottom > 0
                              ? size.height * 0.1
                              : (size.height - (size.height * 0.2)) / 2.0,
                          left: (size.width - 30) / 2.0,
                          height: 45,
                          child: Image.asset("assets/icon/pickmarker.png"),
                        )
                    ],
                  );
                }),
                Column(
                  children: [
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FocusScope(
                            child: Focus(
                                onFocusChange: (value) => reference.setfocus(0, value),
                                child: textfields("Location", widget.pickup))),
                      ),
                    ),
                  ],
                ),
                if (reference.placesList.isNotEmpty)
                  Container(
                      margin: EdgeInsets.only(
                          top: 70, left: 15, right: 10, bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : 15),
                      child: Material(
                          type: MaterialType.card,
                          elevation: 5,
                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                            Expanded(
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: reference.placesList.length,
                                    separatorBuilder: (BuildContext context, int index) => const Divider(),
                                    itemBuilder: (context, index) {
                                      String addressType2 = recentAddress.isNotEmpty && index < recentAddress.length
                                          ? recentAddress[index].addressType
                                          : "OTHER";
                                      return InkWell(
                                          onTap: () async {
                                            if (recentAddress.isNotEmpty && index < recentAddress.length) {
                                              widget.pickup.text = recentAddress[index].address1;
                                              screenCoordinates =
                                                  LatLng(recentAddress[index].latitude, recentAddress[index].longitude);
                                              reference.setMarkers(mounted, context, mapController,
                                                  pickup: screenCoordinates);
                                            } else {
                                              widget.pickup.text = reference.placesList[index].description;
                                              await reference
                                                  .getPlaceDetails(
                                                      mounted, context, reference.placesList[index].place_id)
                                                  .then((value) async {
                                                var location = reference.placesDetails.result.geometry.location;
                                                screenCoordinates = LatLng(location.lat, location.lng);
                                                reference.setMarkers(mounted, context, mapController,
                                                    pickup: screenCoordinates);
                                                // await mapController.animateCamera(CameraUpdate.newCameraPosition(
                                                //     CameraPosition(target: screenCoordinates!, zoom: 17)));
                                              });
                                            }
                                            focusNode.unfocus();
                                            reference.clear(value: true);
                                            widget.listIndex = index;
                                          },
                                          child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: index < recentAddress.length
                                                        ? recentAddress[index].addressType == "CURRENT"
                                                            ? Icon(Icons.location_searching_rounded,
                                                                color: Colors.blue.shade300)
                                                            : recentAddress[index].addressType == "HOME"
                                                                ? Icon(Icons.home, color: Colors.grey.shade600)
                                                                : recentAddress[index].addressType == "OFFICE"
                                                                    ? Icon(Icons.work, color: Colors.grey.shade600)
                                                                    : Icon(Icons.history_sharp,
                                                                        color: Colors.grey.shade600)
                                                        : Icon(Icons.location_pin, color: Colors.grey.shade600),
                                                  ),
                                                  const SizedBox(width: 15),
                                                  Expanded(
                                                    child: Text(
                                                        index < recentAddress.length
                                                            ? recentAddress[index].addressType == "CURRENT"
                                                                ? "My Current Location"
                                                                : recentAddress[index].addressType == "OTHER"
                                                                    ? recentAddress[index].address1
                                                                    : addressType2[0] +
                                                                        addressType2.substring(1).toLowerCase()
                                                            : reference.placesList[index].description,
                                                        style: Variables.font()),
                                                  )
                                                ],
                                              )));
                                    }))
                          ])))
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: reference.isclicked
                ? FloatingActionButton.extended(
                    onPressed: () async {
                      String state = "", city = "", pincode = "";
                      if (widget.listIndex >= recentAddress.length) {
                        state = reference.placesDetails.result.addressComponents
                            .where((element) => element.types.contains("administrative_area_level_1"))
                            .first
                            .longName;
                        city = reference.placesDetails.result.addressComponents
                            .where((element) => element.types.contains("administrative_area_level_2"))
                            .first
                            .longName;
                        pincode = reference.placesDetails.result.addressComponents
                                .where((element) => element.types.contains("postal_code"))
                                .isNotEmpty
                            ? reference.placesDetails.result.addressComponents
                                .where((element) => element.types.contains("postal_code"))
                                .first
                                .longName
                            : "0";
                      } else {
                        state = recentAddress[widget.listIndex].state;
                        city = recentAddress[widget.listIndex].city;
                        pincode = recentAddress[widget.listIndex].pincode.toString();
                      }
                      Map<String, dynamic> address = {};
                      if (widget.maptap) {
                        address = await mapsProvider.setLocation(mounted, context, screenCoordinates!.latitude,
                                screenCoordinates!.longitude, Variables.driverId) ??
                            {};
                        widget.maptap = false;
                      } else {
                        address = {
                          'address1': widget.pickup.text,
                          'city': city,
                          'customerId': Variables.driverId,
                          'latitude': mapsProvider.pickmark!.position.latitude,
                          'longitude': mapsProvider.pickmark!.position.latitude,
                          'pincode': int.parse(pincode),
                          'state': state,
                          'type': "OTHER",
                        };
                      }
                      customerController.setAddress(address, isdelivery: false);
                      reference.clear(value: false);
                      if (!mounted) return;
                      Navigator.pop(context, widget.pickup.text);
                    },
                    label: Text(
                      "Confirm Location",
                      style: Variables.font(color: null, fontSize: 15),
                    ))
                : null),
      );
    });
  }

  Padding textfields(String labelText, TextEditingController controller) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 15, 10, 10),
        child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.streetAddress,
            focusNode: focusNode,
            onTap: () {
              mapsProvider.refreshCurrentLocation();
              recentAddress = mapsProvider.savedAddress;
              mapsProvider.clear();
              mapsProvider.placesList.addAll(recentAddress);
            },
            onChanged: (value) async {
              recentAddress = mapsProvider.savedAddress
                  .where((element) => element.address1.toLowerCase().startsWith(value.toLowerCase()))
                  .toList();
              Variables.locations[labelText] = value;
              await mapsProvider.getAutoComplete(mounted, context, value);
              mapsProvider.placesList.insertAll(0, recentAddress);
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          // mapsProvider.setfocus(slider.toInt(), false);
                          Variables.locations[labelText] = null;
                          mapsProvider.clear();
                          controller.clear();
                        },
                        icon: const Icon(Icons.clear_rounded))
                    : null,
                contentPadding: controller.text.isNotEmpty ? EdgeInsets.zero : const EdgeInsets.only(right: 12),
                prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0), child: Image.asset("assets/icon/icons8-location-pin-49.png")),
                labelText: labelText,
                hintText: "Search $labelText",
                prefixIconConstraints: const BoxConstraints(maxHeight: 40))));
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}
