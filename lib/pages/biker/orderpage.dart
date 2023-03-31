import 'dart:async';

import 'package:ezshipp/APIs/new_orderlist.dart';
import 'package:ezshipp/Provider/maps_provider.dart';
import 'package:ezshipp/pages/biker/deliver_page.dart';
import 'package:ezshipp/pages/biker/zonepage.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Provider/order_controller.dart';

// ignore: must_be_immutable
class Order extends StatefulWidget {
  static String routeName = "/order-tracking";
  int index;
  bool accepted;
  Order({
    Key? key,
    required this.index,
    this.accepted = false,
  }) : super(key: key);

  @override
  OrderState createState() => OrderState();
}

class OrderState extends State<Order> {
  late Animation anim;

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  late OrderController orderController;
  late MapsProvider mapsProvider;
  TextEditingController controller = TextEditingController();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    orderController = Provider.of<OrderController>(context, listen: false);
    mapsProvider = Provider.of<MapsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderController>(builder: (context, reference, child) {
      NewOrderList list =
          widget.accepted ? reference.acceptedList[widget.index] : reference.deliveredList[widget.index];
      Variables.list = list;
      Variables.index2 = widget.index;
      Variables.list1 = list;
      Variables.index2 = widget.index;
      return Scaffold(
          appBar: Variables.app(actions: [
            if (list.statusId > 5 && list.statusId < 11)
              IconButton(
                  onPressed: () async {
                    Variables.updateOrderMap.barcode = await Variables.scantext(context, controller);
                    if (!mounted) return;
                    Variables.updateOrder(mounted, context, list.id, 8);
                    if (timer != null) timer!.cancel();
                    Variables.pop(context);
                  },
                  icon: const Icon(Icons.qr_code_scanner_rounded))
          ]),
          body: Stack(children: [
            Consumer<MapsProvider>(builder: (context, reference1, child) {
              return GoogleMap(
                zoomControlsEnabled: false,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                initialCameraPosition: const CameraPosition(target: LatLng(17.387140, 78.491684), zoom: 11.0),
                markers: {
                  if (reference1.pickmark != null) reference1.pickmark!,
                  if (reference1.dropmark != null) reference1.dropmark!
                },
                onMapCreated: (controller) {
                  // await reference1.directions(context, controller, null,
                  //     places: [reference1.pickmark!.position, reference1.dropmark!.position]).then((value) {
                  //   var latLngBounds =
                  //       LatLngBounds(southwest: reference1.boundsMap[1], northeast: reference1.boundsMap[0]);
                  //   controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 50));
                  // });
                },
                polylines: {Polyline(polylineId: const PolylineId("origin"), points: reference1.info, width: 3)},
              );
            }),
            DraggableScrollableSheet(
                builder: (context, scrollController) => SingleChildScrollView(
                      controller: scrollController,
                      child: Card(
                          margin: const EdgeInsets.all(8),
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Align(
                                                alignment: Alignment.topCenter,
                                                child: Variables.text(context,
                                                    head: "Order Id: ", value: list.orderSeqId))),
                                      ),
                                      if (list.statusId > 5 && list.statusId < 12)
                                        TextButton(
                                            onPressed: () => Variables.push(context, ZonedPage.routeName),
                                            child: Text(
                                              "Zone At Hub",
                                              style: Variables.font(fontSize: 15, color: null),
                                            )),
                                    ],
                                  ),
                                  const Divider(),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Variables.text(context,
                                          head: "Status: ", value: list.status, valueColor: Palette.kOrange),
                                      TextButton(
                                          onPressed: () {
                                            Variables.isdetail = true;
                                            Variables.push(context, DeliveredPage.routeName);
                                          },
                                          child: Text(
                                            "View more",
                                            style: Variables.font(color: null),
                                          ))
                                    ],
                                  ),
                                  Variables.text(context,
                                      head: "Delivery distance: ", value: "${list.pickToDropDistance} km"),
                                  Variables.text(context,
                                      head: "Delivery duration: ", value: "${list.pickToDropDuration} min"),
                                  const SizedBox(height: 15),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(children: [
                                            Image.asset(
                                              "assets/icon/icons8-location-48.png",
                                              height: 20,
                                              color: Colors.green,
                                            ),
                                            const SizedBox(width: 3),
                                            Text("Pickup Address", style: Variables.font(fontSize: 17))
                                          ]),
                                          ElevatedButton(
                                              onPressed: () async {
                                                var url = "tel:${list.senderPhone}";
                                                await canLaunchUrl(Uri.parse(url))
                                                    ? launchUrl(Uri.parse(url))
                                                    : Variables.showtoast(
                                                        context, "Unable to open Phone App", Icons.cancel_outlined);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  shape:
                                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.phone_rounded, size: 17),
                                                  const SizedBox(width: 2),
                                                  Text(
                                                    "Call",
                                                    style: Variables.font(color: Colors.white, fontSize: 15),
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Variables.text(context,
                                          head: "Name: ",
                                          value: list.senderName,
                                          valueFontSize: 15,
                                          valueColor: Colors.grey),
                                      Variables.text(context,
                                          head: "Phone number: ",
                                          value: list.senderPhone,
                                          valueFontSize: 15,
                                          valueColor: Colors.grey),
                                      Variables.text(context,
                                          head: "Address:\n",
                                          value: list.pickAddress,
                                          valueFontSize: 15,
                                          valueColor: Colors.grey),
                                      if (list.pickLandmark.isEmpty)
                                        Variables.text(context,
                                            head: "Landmark:",
                                            value: list.pickLandmark,
                                            valueFontSize: 15,
                                            valueColor: Colors.grey)
                                    ],
                                  ),
                                  const Divider(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(children: [
                                            Image.asset(
                                              "assets/icon/icons8-location-48.png",
                                              height: 20,
                                              color: Colors.red,
                                            ),
                                            const SizedBox(width: 3),
                                            Text("Drop Address", style: Variables.font(fontSize: 17))
                                          ]),
                                          ElevatedButton(
                                              onPressed: () async {
                                                var url = "tel:${list.receiverPhone}";

                                                await canLaunchUrl(Uri.parse(url))
                                                    ? launchUrl(Uri.parse(url))
                                                    : Variables.showtoast(
                                                        context, "Unable to open Phone App", Icons.cancel_outlined);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  shape:
                                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.phone_rounded, size: 17),
                                                  const SizedBox(width: 2),
                                                  Text(
                                                    "Call",
                                                    style: Variables.font(color: Colors.white, fontSize: 15),
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Variables.text(context,
                                          head: "Name: ",
                                          value: list.receiverName,
                                          valueFontSize: 15,
                                          valueColor: Colors.grey),
                                      Variables.text(context,
                                          head: "Phone number: ",
                                          value: list.receiverPhone,
                                          valueFontSize: 15,
                                          valueColor: Colors.grey),
                                      Variables.text(context,
                                          head: "Address:\n",
                                          value: list.dropAddress,
                                          valueFontSize: 15,
                                          valueColor: Colors.grey),
                                      if (list.dropLandmark.isEmpty)
                                        Variables.text(context,
                                            head: "Landmark:",
                                            value: list.dropLandmark,
                                            valueFontSize: 15,
                                            valueColor: Colors.grey)
                                    ],
                                  ),
                                  if (list.statusId < 12)
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                      ElevatedButton(
                                          onPressed: () async {
                                            bool comment = await showDialog(
                                              context: context,
                                              builder: (context) => SimpleDialog(
                                                title: Text("Cancel Reasons",
                                                    textAlign: TextAlign.center, style: Variables.font(fontSize: 18)),
                                                children: [
                                                  ...ListTile.divideTiles(
                                                    context: context,
                                                    tiles: List.generate(
                                                        Variables.cancelReasons.length,
                                                        (index) => ListTile(
                                                              onTap: () {
                                                                Variables.updateOrderMap.cancelReason =
                                                                    Variables.cancelReasons[index][1];
                                                                Variables.updateOrderMap.cancelReasonId =
                                                                    Variables.cancelReasons[index][0];
                                                                Variables.updateOrder(mounted, context, list.id, 14);
                                                                Variables.pop(context,
                                                                    value: Variables.cancelReasons[index][3] == 1
                                                                        ? true
                                                                        : false);
                                                              },
                                                              title: Text(Variables.cancelReasons[index][1]),
                                                            )),
                                                  ),
                                                ],
                                              ),
                                            );
                                            if (comment) {
                                              String? value1;
                                              Variables.updateOrderMap.driverComments = await showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                          content: Form(
                                                              key: formkey,
                                                              child: TextFormField(
                                                                  onChanged: (value) => value1 = value,
                                                                  validator: (value) {
                                                                    if (value!.isEmpty) {
                                                                      return "Enter  comment ";
                                                                    }
                                                                    return null;
                                                                  },
                                                                  decoration: const InputDecoration(
                                                                      hintText: "Enter comment",
                                                                      labelText: "Comment*"))),
                                                          actions: [
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  if (formkey.currentState!.validate()) {
                                                                    Variables.pop(context, value: value1);
                                                                  }
                                                                },
                                                                child: Text(
                                                                  "Send",
                                                                  style: Variables.font(fontSize: 15, color: null),
                                                                ))
                                                          ]));
                                            }
                                            if (!mounted) return;
                                            Variables.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Palette.kOrange,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                          child: Row(children: [
                                            const Icon(Icons.cancel_outlined),
                                            const SizedBox(width: 5),
                                            Text(
                                              "Cancel",
                                              style: Variables.font(color: Colors.white, fontSize: 15),
                                            ),
                                          ])),
                                      ElevatedButton(
                                          onPressed: () async {
                                            void launchApps(urlString) async {
                                              await canLaunchUrl(urlString)
                                                  ? launchUrl(urlString)
                                                  : Variables.showtoast(
                                                      context, "Can't open Google Maps", Icons.cancel_outlined);
                                            }

                                            await getLiveLocation();

                                            if (list.statusId < 5) {
                                              if (!mounted) return;
                                              await mapsProvider.directions(mounted, context, null, null, places: [
                                                LatLng(Variables.updateOrderMap.latitude,
                                                    Variables.updateOrderMap.longitude),
                                                LatLng(list.pickLatitude, list.pickLongitude)
                                              ]);
                                              Timer.periodic(const Duration(seconds: 10), (timer) {
                                                // ignore: avoid_print
                                                print("Timer is calling ${DateTime.now()}");
                                              });
                                              int temp = mapsProvider.directioDetails[0]["value"];
                                              Timer.periodic(const Duration(minutes: 1), (timer) async {
                                                await mapsProvider.directions(mounted, context, null, null, places: [
                                                  LatLng(Variables.updateOrderMap.latitude,
                                                      Variables.updateOrderMap.longitude),
                                                  LatLng(list.pickLatitude, list.pickLongitude)
                                                ]);
                                                if (temp > mapsProvider.directioDetails[0]["value"]) {
                                                  if (!mounted) return;
                                                  Variables.updateOrder(mounted, context, list.id, 4);
                                                }
                                                timer.cancel();
                                              });
                                              Timer.periodic(
                                                  Duration(seconds: mapsProvider.directioDetails[1]["value"]),
                                                  (timer) async {
                                                await mapsProvider.directions(mounted, context, null, null, places: [
                                                  LatLng(Variables.updateOrderMap.latitude,
                                                      Variables.updateOrderMap.longitude),
                                                  LatLng(list.pickLatitude, list.pickLongitude)
                                                ]);
                                                if (mapsProvider.directioDetails[0]["value"] < 1000) {
                                                  if (!mounted) return;
                                                  Variables.updateOrder(mounted, context, list.id, 5);
                                                }
                                                timer.cancel();
                                              });
                                              launchApps(
                                                  "https://www.google.com/maps/dir/?api=1&origin=${Variables.updateOrderMap.latitude},${Variables.updateOrderMap.longitude} &destination=${list.pickLatitude},${list.pickLongitude}");
                                            } else if (list.statusId >= 5 && list.statusId < 11) {
                                              if (!mounted) return;
                                              Variables.updateOrder(mounted, context, list.id, 6);
                                              await mapsProvider.directions(mounted, context, null, null, places: [
                                                LatLng(Variables.updateOrderMap.latitude,
                                                    Variables.updateOrderMap.longitude),
                                                LatLng(list.dropLatitude, list.dropLongitude)
                                              ]);
                                              int temp = mapsProvider.directioDetails[0]["value"];
                                              Timer.periodic(const Duration(minutes: 1), (timer) async {
                                                await mapsProvider.directions(mounted, context, null, null, places: [
                                                  LatLng(Variables.updateOrderMap.latitude,
                                                      Variables.updateOrderMap.longitude),
                                                  LatLng(list.dropLatitude, list.dropLongitude)
                                                ]);
                                                if (temp > mapsProvider.directioDetails[0]["value"]) {
                                                  if (!mounted) return;
                                                  Variables.updateOrder(mounted, context, list.id, 9);
                                                }
                                                timer.cancel();
                                              });
                                              timer = Timer.periodic(
                                                  Duration(seconds: mapsProvider.directioDetails[1]["value"]),
                                                  (timer) async {
                                                await mapsProvider.directions(mounted, context, null, null, places: [
                                                  LatLng(Variables.updateOrderMap.latitude,
                                                      Variables.updateOrderMap.longitude),
                                                  LatLng(list.dropLatitude, list.dropLongitude)
                                                ]);
                                                if (mapsProvider.directioDetails[0]["value"] <
                                                    mapsProvider.directioDetails[0]["value"] * 0.1) {
                                                  if (!mounted) return;
                                                  Variables.updateOrder(mounted, context, list.id, 11);
                                                }
                                                timer.cancel();
                                              });
                                              launchApps(
                                                  "https://www.google.com/maps/dir/?api=1&origin=${Variables.updateOrderMap.latitude},${Variables.updateOrderMap.longitude} &destination=${list.dropLatitude},${list.dropLongitude}");
                                            } else if (list.statusId == 11) {
                                              Variables.isdetail = false;
                                              if (!mounted) return;
                                              Variables.push(context, DeliveredPage.routeName);
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              primary: Palette.kOrange,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                          child: Row(children: [
                                            list.statusId < 5
                                                ? Image.asset(
                                                    "assets/icon/icons8-pointer-64.png",
                                                    height: 22,
                                                    color: Colors.white,
                                                  )
                                                : const Icon(Icons.check_rounded),
                                            const SizedBox(width: 5),
                                            Text(
                                              list.statusId < 5
                                                  ? "Start"
                                                  : list.statusId == 5
                                                      ? "Pick"
                                                      : list.statusId == 6
                                                          ? "Picked"
                                                          : list.statusId < 11
                                                              ? "Start"
                                                              : list.statusId == 11
                                                                  ? "Complete"
                                                                  : "",
                                              style: Variables.font(color: Colors.white, fontSize: 15),
                                            )
                                          ]))
                                    ]),
                                ],
                              ))),
                    ))
          ]));
    });
  }

  Future<void> getLiveLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    var currentlocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    Variables.updateOrderMap.latitude = currentlocation.latitude;
    Variables.updateOrderMap.longitude = currentlocation.longitude;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
