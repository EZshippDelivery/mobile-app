import 'dart:io';

import 'package:ezshipp/Provider/maps_provider.dart';
import 'package:ezshipp/pages/confirm_addresspage.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class BookOrderPage extends StatefulWidget {
  const BookOrderPage({Key? key}) : super(key: key);

  @override
  _BookOrderPageState createState() => _BookOrderPageState();
}

class _BookOrderPageState extends State<BookOrderPage> {
  double slider = 0;
  late MapsProvider mapsProvider;
  TextEditingController pickup = TextEditingController(), delivery = TextEditingController();
  late GoogleMapController mapController;
  LatLng? screenCoordinates;

  @override
  void initState() {
    super.initState();
    mapsProvider = Provider.of<MapsProvider>(context, listen: false);
    mapsProvider.getCurrentlocations();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final devicePixelRatio = Platform.isAndroid ? MediaQuery.of(context).devicePixelRatio : 1.0;
    return Consumer<MapsProvider>(builder: (context, reference, child) {
      return Scaffold(
          appBar: Variables.app(),
          body: Stack(
            children: [
              reference.latitude > 0 && reference.longitude > 0
                  ? GoogleMap(
                      markers: {
                        if (reference.pickmark != null) reference.pickmark!,
                        if (reference.dropmark != null) reference.dropmark!
                      },
                      onCameraIdle: () async {
                        screenCoordinates = await mapController.getLatLng(ScreenCoordinate(
                          x: (size.width * devicePixelRatio) ~/ 2.0,
                          y: (size.height * devicePixelRatio) ~/ 2.0,
                        ));
                      },
                      onMapCreated: ((controller) => mapController = controller),
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
                    )
                  : const Center(child: CircularProgressIndicator.adaptive()),
              if (reference.isorigin && slider == 0)
                Positioned(
                  bottom: MediaQuery.of(context).viewInsets.bottom > 0
                      ? size.height * 0.1
                      : (size.height - (size.height * 0.2)) / 2.0,
                  left: (size.width - 30) / 2.0,
                  child: Image.asset("assets/icon/pickmarker.png"),
                  height: 45,
                ),
              if (reference.isorigin && slider == 1)
                Positioned(
                  bottom: MediaQuery.of(context).viewInsets.bottom > 0
                      ? size.height * 0.1
                      : (size.height - (size.height * 0.2)) / 2.0,
                  left: (size.width - 30) / 2.0,
                  child: Image.asset("assets/icon/dropmarker.png"),
                  height: 45,
                ),
              Column(
                children: [
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                    child: Row(children: [
                      SizedBox(
                        height: size.height * 0.17,
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: SliderTheme(
                              data: SliderThemeData(
                                  trackHeight: 1.0,
                                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                                  disabledThumbColor: Palette.kOrange[50],
                                  disabledActiveTrackColor: Palette.kOrange),
                              child: Slider(value: slider, min: 0, max: 1, onChanged: null)),
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
                                  child: textfields(0, "Pickup Location", pickup))),
                          FocusScope(
                              child: Focus(
                                  onFocusChange: (value) => reference.setfocus(1, value),
                                  child: textfields(1, "Delivery Location", delivery)))
                        ],
                      ))
                    ]),
                  ),
                ],
              ),
              if ((reference.placesList.isNotEmpty && reference.focus[slider.toInt()]) ||
                  reference.savedAddress.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(top: slider == 0 ? 65 : 140),
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  child: Column(
                    children: [
                      if (reference.savedAddress.isNotEmpty)
                        ...ListTile.divideTiles(
                            tiles: List.generate(
                                reference.savedAddress.length, (index) => ListTile(leading: Icon(Icons.home_rounded)))),
                      if (reference.placesList.isNotEmpty && reference.focus[slider.toInt()])
                        Expanded(
                          child: ListView.separated(
                            itemCount: reference.placesList.length,
                            separatorBuilder: (BuildContext context, int index) => const Divider(),
                            itemBuilder: (context, index) {
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                                leading: const Icon(Icons.location_on_outlined),
                                title: Text(reference.placesList[index].description, style: Variables.font()),
                                onTap: () {
                                  if (slider == 0) {
                                    pickup.text = reference.placesList[index].description;
                                    reference.getPlaceDetails(reference.placesList[index].place_id).then((value) {
                                      var location = reference.placesDetails.result.geometry.location;
                                      screenCoordinates = LatLng(location.lat, location.lng);
                                      mapController.animateCamera(CameraUpdate.newCameraPosition(
                                          CameraPosition(target: screenCoordinates!, zoom: 17)));
                                    });
                                  } else {
                                    delivery.text = reference.placesList[index].description;
                                    reference.getPlaceDetails(reference.placesList[index].place_id).then((value) {
                                      var location = reference.placesDetails.result.geometry.location;
                                      screenCoordinates = LatLng(location.lat, location.lng);
                                      mapController.animateCamera(CameraUpdate.newCameraPosition(
                                          CameraPosition(target: screenCoordinates!, zoom: 17)));
                                    });
                                  }
                                  reference.clear(value: true);
                                  reference.setfocus(slider.toInt(), false);
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: reference.isorigin
              ? FloatingActionButton.extended(
                  onPressed: () {
                    if (slider == 0) {
                      reference.setMarkers(mapController, pickup: screenCoordinates);
                      reference.clear(value: false);
                    } else {
                      reference.setMarkers(mapController, delivery: screenCoordinates);
                      reference.clear(value: false, complete: true);
                    }
                  },
                  label: Text(
                    "Cofirm Location",
                    style: Variables.font(color: null, fontSize: 15),
                  ))
              : reference.placeAdress
                  ? FloatingActionButton(
                      onPressed: () => Variables.push(context, const ConfirmAddressPage()),
                      child: const Icon(Icons.keyboard_arrow_right_rounded),
                    )
                  : null);
    });
  }

  Padding textfields(double sliderValue, String labelText, TextEditingController controller) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 15, 10, 10),
        child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.streetAddress,
            onFieldSubmitted: (text) => mapsProvider.setfocus(sliderValue.toInt(), false),
            onTap: () {
              mapsProvider.setfocus(sliderValue.toInt(), true);
              setState(() => slider = sliderValue);
            },
            onChanged: (value) async {
              if (mapsProvider.currentLocation) {
                mapsProvider.savedAddress.removeAt(0);
                mapsProvider.currentLocation = false;
              }
              mapsProvider.filter(value);
              Variables.locations[labelText] = value;
              if (mapsProvider.focus[sliderValue.toInt()]) await mapsProvider.getAutoComplete(value);
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                suffixIcon: controller.text.isNotEmpty && mapsProvider.focus[sliderValue.toInt()]
                    ? IconButton(
                        onPressed: () {
                          Variables.locations[labelText] = null;
                          mapsProvider.clear();
                          controller.clear();
                        },
                        icon: const Icon(Icons.clear_rounded))
                    : null,
                contentPadding: const EdgeInsets.only(right: 10),
                prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0), child: Image.asset("assets/icon/icons8-location-pin-49.png")),
                labelText: labelText,
                hintText: "Search $labelText",
                prefixIconConstraints: const BoxConstraints(maxHeight: 40))));
  }

  @override
  void dispose() {
    mapsProvider.dispose();
    mapController.dispose();
    pickup.dispose();
    delivery.dispose();
    super.dispose();
  }
}
