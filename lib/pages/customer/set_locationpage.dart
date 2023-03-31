import 'dart:io';

import 'package:ezshipp/APIs/get_top_addresses.dart';
import 'package:ezshipp/Provider/maps_provider.dart';
import 'package:ezshipp/Provider/update_screenprovider.dart';
import 'package:ezshipp/pages/customer/confirm_addresspage.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../Provider/customer_controller.dart';

class SetLocationPage extends StatefulWidget {
  static String routeName = "/set-location";
  static TextEditingController pickup = TextEditingController(), delivery = TextEditingController();
  static double slider = 0;
  static int listIndex = 0;
  const SetLocationPage({Key? key}) : super(key: key);

  @override
  SetLocationPageState createState() => SetLocationPageState();
}

class SetLocationPageState extends State<SetLocationPage> {
  late MapsProvider mapsProvider;

  late GoogleMapController mapController;
  LatLng? screenCoordinates;
  List<GetAllAddresses> recentAddress = [];
  CustomerController? customerController;
  UpdateScreenProvider? updateScreenProvider;

  bool longpress = false;

  @override
  void initState() {
    super.initState();
    mapsProvider = Provider.of<MapsProvider>(context, listen: false);
    customerController = Provider.of<CustomerController>(context, listen: false);
    updateScreenProvider = Provider.of<UpdateScreenProvider>(context, listen: false);
    Future.delayed(Duration.zero, () => constructor());
  }

  constructor() async {
    // Variables.loadingDialogue(context: context, subHeading: "Please wait ...");
    await mapsProvider.getCurrentlocations();
    if (!mounted) return;
    await mapsProvider.getTopAddresses(mounted, context, Variables.driverId);
    mapsProvider.pickmark = null;
    mapsProvider.dropmark = null;
    updateScreenProvider!.onMOve = false;
    mapsProvider.info.clear();
    SetLocationPage.pickup = TextEditingController();
    SetLocationPage.delivery = TextEditingController();
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final devicePixelRatio = Platform.isAndroid ? MediaQuery.of(context).devicePixelRatio : 1.0;
    return Consumer2<MapsProvider, UpdateScreenProvider>(builder: (context, reference, snapshot, child) {
      return Scaffold(
          appBar: Variables.app(),
          body: Stack(
            children: [
              Stack(children: [
                (reference.latitude != 0) && (reference.longitude !=  0)
                    //Google Maps
                    ? InkWell(
                        onLongPress: () => longpress = true,
                        child: GoogleMap(
                          markers: {
                            if (reference.pickmark != null) reference.pickmark!,
                            if (reference.dropmark != null) reference.dropmark!
                          },
                          onTap: (value) {
                            snapshot.onMOve = true;
                          },
                          onCameraMove: (value) {
                            debugPrint("Something");
                            // if (longpress) snapshot.onMOve = true;
                            snapshot.updateScreen();
                          },
                          onCameraIdle: () async {
                            screenCoordinates = await mapController.getLatLng(ScreenCoordinate(
                              x: (size.width * devicePixelRatio) ~/ 2.0,
                              y: (size.height * devicePixelRatio) ~/ 2.0,
                            ));
                          },
                          onMapCreated: (controller) => mapController = controller,
                          polylines: {
                            if (reference.info.isNotEmpty)
                              Polyline(
                                  endCap: Cap.roundCap,
                                  startCap: Cap.roundCap,
                                  polylineId: const PolylineId("direction"),
                                  points: reference.info,
                                  width: 3)
                          },
                          initialCameraPosition:
                              CameraPosition(target: LatLng(reference.latitude, reference.longitude), zoom: 14),
                          myLocationEnabled: true,
                          zoomControlsEnabled: false,
                        ),
                      )
                    : const Center(child: CircularProgressIndicator.adaptive()),
                // Pickup loctioan pin on screen when slider equals to 1 and pickup textfield is tapped
                if (snapshot.onMOve && SetLocationPage.slider == 0) //
                  Positioned(
                    bottom: MediaQuery.of(context).viewInsets.bottom > 0
                        ? size.height * 0.1
                        : (size.height - (size.height * 0.2)) / 2.0,
                    left: (size.width - 30) / 2.0,
                    height: 45,
                    child: Image.asset("assets/icon/pickmarker.png"),
                  ),
                //Delivery location pin on screen when slider equals to 1 and delivery textfield is tapped
                if (snapshot.onMOve && SetLocationPage.slider == 1)
                  Positioned(
                    bottom: MediaQuery.of(context).viewInsets.bottom > 0
                        ? size.height * 0.1
                        : (size.height - (size.height * 0.2)) / 2.0,
                    left: (size.width - 30) / 2.0,
                    height: 45,
                    child: Image.asset("assets/icon/dropmarker.png"),
                  )
              ]),

              // Card for textfields(Pickup address and delivery address)
              Column(children: [
                Card(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                    child: Row(children: [
                      SizedBox(
                        height: size.height * 0.15,
                        child: RotatedBox(
                          quarterTurns: 1,
                          // Vertical Slider at left side of textfields
                          child: SliderTheme(
                              data: SliderThemeData(
                                  trackHeight: 1.0,
                                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                                  disabledThumbColor: Palette.kOrange[50],
                                  disabledActiveTrackColor: Palette.kOrange),
                              child: Slider(value: SetLocationPage.slider, min: 0, max: 1, onChanged: null)),
                        ),
                      ),
                      Expanded(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            FocusScope(
                                child: Focus(
                                    onFocusChange: (value) => reference.setfocus(0, value),
                                    child: textfields(0, "Pickup Location", SetLocationPage.pickup))),
                            FocusScope(
                                child: Focus(
                                    onFocusChange: (value) => reference.setfocus(1, value),
                                    child: textfields(1, "Delivery Location", SetLocationPage.delivery)))
                          ]))
                    ])),
              ]),
              // popup container with list of suggestion
              if (reference.placesList.isNotEmpty && reference.focus[SetLocationPage.slider.toInt()])
                Container(
                    margin: EdgeInsets.only(
                        top: SetLocationPage.slider == 0 ? 70 : 140,
                        left: 15,
                        right: 10,
                        bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : 15),
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
                                          String state = "", city = "", pincode = "";

                                          if (recentAddress.isNotEmpty && index < recentAddress.length) {
                                            if (SetLocationPage.slider == 0) {
                                              SetLocationPage.pickup.text = recentAddress[index].address1;
                                              screenCoordinates =
                                                  LatLng(recentAddress[index].latitude, recentAddress[index].longitude);
                                              mapController.animateCamera(CameraUpdate.newCameraPosition(
                                                  CameraPosition(target: screenCoordinates!, zoom: 17)));
                                            } else {
                                              SetLocationPage.delivery.text = recentAddress[index].address1;
                                              screenCoordinates =
                                                  LatLng(recentAddress[index].latitude, recentAddress[index].longitude);
                                              mapController.animateCamera(CameraUpdate.newCameraPosition(
                                                  CameraPosition(target: screenCoordinates!, zoom: 17)));
                                            }
                                            state = recentAddress[SetLocationPage.listIndex].state;
                                            city = recentAddress[SetLocationPage.listIndex].city;
                                            pincode = recentAddress[SetLocationPage.listIndex].pincode.toString();
                                          } else {
                                            if (SetLocationPage.slider == 0) {
                                              SetLocationPage.pickup.text = reference.placesList[index].description;
                                              await reference.getPlaceDetails(
                                                  mounted, context, reference.placesList[index].place_id);

                                              var location = reference.placesDetails.result.geometry.location;
                                              screenCoordinates = LatLng(location.lat, location.lng);
                                              mapController.animateCamera(CameraUpdate.newCameraPosition(
                                                  CameraPosition(target: screenCoordinates!, zoom: 17)));
                                            } else {
                                              SetLocationPage.delivery.text = reference.placesList[index].description;
                                              await reference.getPlaceDetails(
                                                  mounted, context, reference.placesList[index].place_id);
                                              var location = reference.placesDetails.result.geometry.location;
                                              screenCoordinates = LatLng(location.lat, location.lng);
                                              mapController.animateCamera(CameraUpdate.newCameraPosition(
                                                  CameraPosition(target: screenCoordinates!, zoom: 17)));
                                            }
                                            state = reference.placesDetails.result.addressComponents
                                                .where(
                                                    (element) => element.types.contains("administrative_area_level_1"))
                                                .first
                                                .longName;
                                            city = reference.placesDetails.result.addressComponents
                                                .where((element) =>
                                                    element.types.contains("administrative_area_level_2") ||
                                                    element.types.contains("locality"))
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
                                          }
                                          Map<String, dynamic> address = {
                                            'address1': SetLocationPage.slider == 0
                                                ? SetLocationPage.pickup.text
                                                : SetLocationPage.delivery.text,
                                            'city': city,
                                            'customerId': Variables.driverId,
                                            'latitude': screenCoordinates!.latitude,
                                            'longitude': screenCoordinates!.longitude,
                                            'pincode': int.parse(pincode),
                                            'state': state,
                                            'type': "OTHER",
                                          };
                                          if (!mounted) return;
                                          if (SetLocationPage.slider == 0) {
                                            reference.setMarkers(mounted, context, mapController,
                                                pickup: screenCoordinates);
                                            customerController!.setAddress(address, isdelivery: false);
                                            reference.clear(value: false);
                                          } else {
                                            customerController!.setAddress(address, isdelivery: true);
                                            reference.setMarkers(mounted, context, mapController,
                                                delivery: screenCoordinates);
                                            reference.clear(value: false);
                                          }
                                          reference.clear(value: true);
                                          reference.setfocus(SetLocationPage.slider.toInt(), false);
                                          SetLocationPage.listIndex = index;
                                          Variables.showtoast(context, "Tap on Map to move the Location pin",
                                              Icons.warning_rounded, true);
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
          floatingActionButton: snapshot.onMOve
              ? FloatingActionButton.extended(
                  onPressed: () async {
                    longpress = false;
                    snapshot.onMOve = false;
                    snapshot.updateScreen();
                    Map<String, dynamic> address = await mapsProvider.setLocation(mounted, context,
                            screenCoordinates!.latitude, screenCoordinates!.longitude, Variables.driverId) ??
                        {};
                    if (address.isNotEmpty) {
                      if (SetLocationPage.slider == 0) {
                        SetLocationPage.pickup.text = address["address1"];
                        if (!mounted) return;
                        reference.setMarkers(mounted, context, mapController, pickup: screenCoordinates);
                        customerController!.setAddress(address, isdelivery: false);
                        reference.clear(value: false);
                      } else {
                        SetLocationPage.delivery.text = address["address1"];
                        customerController!.setAddress(address, isdelivery: true);
                        if (!mounted) return;
                        reference.setMarkers(mounted, context, mapController, delivery: screenCoordinates);
                        reference.clear(value: false);
                      }
                    } else {
                      if (!mounted) return;
                      Variables.showtoast(context, "choose nearby another location", Icons.warning_rounded);
                    }
                  },
                  label: Text(
                    "Cofirm Location",
                    style: Variables.font(color: null, fontSize: 15),
                  ))
              : reference.dropmark != null
                  ? FloatingActionButton(
                      onPressed: () {
                        reference.pickmark != null && reference.dropmark != null
                            ? Variables.push(context, ConfirmAddressPage.routeName)
                            : Variables.showtoast(context, "Please Confirm the locations", Icons.warning_rounded);
                      },
                      child: const Icon(Icons.keyboard_arrow_right_rounded),
                    )
                  : null);
    });
  }

  Padding textfields(double sliderValue, String labelText, TextEditingController controller) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 15, 10, 10),
        child: TextFormField(
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[\w\d ]"))],
            controller: controller,
            keyboardType: TextInputType.streetAddress,
            onFieldSubmitted: (text) => mapsProvider.setfocus(sliderValue.toInt(), false),
            onTap: () {
              mapsProvider.setfocus(sliderValue.toInt(), true);
              mapsProvider.refreshCurrentLocation();
              SetLocationPage.slider = sliderValue;
              recentAddress = mapsProvider.savedAddress;
              mapsProvider.clear();
              mapsProvider.placesList.addAll(recentAddress);
            },
            onChanged: (value) async {
              recentAddress = mapsProvider.savedAddress
                  .where((element) => element.address1.toLowerCase().startsWith(value.toLowerCase()))
                  .toList();
              Variables.locations[labelText] = value;
              if (mapsProvider.focus[sliderValue.toInt()]) await mapsProvider.getAutoComplete(mounted, context, value);
              mapsProvider.placesList.insertAll(0, recentAddress);
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
                suffixIcon: controller.text.isNotEmpty && mapsProvider.focus[sliderValue.toInt()]
                    ? IconButton(
                        onPressed: () {
                          // mapsProvider.setfocus(slider.toInt(), false);
                          Variables.locations[labelText] = null;
                          mapsProvider.clear();
                          controller.clear();
                        },
                        icon: const Icon(Icons.clear_rounded))
                    : null,
                contentPadding: controller.text.isNotEmpty && mapsProvider.focus[sliderValue.toInt()]
                    ? EdgeInsets.zero
                    : const EdgeInsets.only(right: 12),
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
