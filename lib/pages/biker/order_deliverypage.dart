import 'dart:async';

import 'package:ezshipp/APIs/new_orderlist.dart';
import 'package:ezshipp/Provider/maps_provider.dart';
import 'package:ezshipp/Provider/update_screenprovider.dart';
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
  String index;
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

  @override
  void initState() {
    super.initState();
    orderController = Provider.of<OrderController>(context, listen: false);
    mapsProvider = Provider.of<MapsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderController>(builder: (context, reference, child) {
      var indexWhere = reference.acceptedList.indexWhere((element) => element.orderSeqId == widget.index);
      var indexWhere2 = reference.deliveredList.indexWhere((element) => element.orderSeqId == widget.index);
      int index = widget.accepted
          ? indexWhere >= 0
              ? indexWhere
              : indexWhere2
          : indexWhere2 >= 0
              ? indexWhere2
              : 0;
      if (index != -1) {
        NewOrderList list = widget.accepted ? reference.acceptedList[index] : reference.deliveredList[index];
        Variables.list = list;
        Variables.index2 = index;
        Variables.list1 = list;
        Variables.index2 = index;
        return Scaffold(
            appBar: Variables.app(),
            body: Stack(children: [
              Consumer2<MapsProvider, UpdateScreenProvider>(builder: (context, reference1, reference2, child) {
                return GoogleMap(
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  initialCameraPosition: const CameraPosition(target: LatLng(17.387140, 78.491684), zoom: 11.0),
                  markers: {
                    if (reference1.pickmark != null) reference1.pickmark!,
                    if (reference1.dropmark != null) reference1.dropmark!
                  },
                  onMapCreated: (controller) async {
                    try {
                      await reference1.directions(mounted, context, controller, list).then((value) {
                        var latLngBounds =
                            LatLngBounds(southwest: reference1.boundsMap[1], northeast: reference1.boundsMap[0]);
                        controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 50));
                      });
                    } catch (e) {
                      reference1.pickmark = null;
                      reference1.dropmark = null;
                      reference1.info.clear();
                      reference2.updateScreen();
                    }
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
                                        if (list.statusId > 5 && list.statusId < 11)
                                          TextButton(
                                              onPressed: () async {
                                                Variables.index3 = list.id;
                                                await Variables.push(context, ZonedPage.routeName);
                                                // if (!mounted) return;
                                                // Variables.pop(context);
                                              },
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
                                        Flexible(
                                          child: FittedBox(
                                            child: Variables.text(context,
                                                head: "Status: ", value: list.status, valueColor: Palette.kOrange),
                                          ),
                                        ),
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
                                              Text("Pickup Address", style: Variables.font(fontSize: 17)),
                                              IconButton(
                                                  onPressed: () async {
                                                    String urlString =
                                                        "https://www.google.com/maps/dir/?api=1&origin=${Variables.updateOrderMap.latitude},${Variables.updateOrderMap.longitude} &destination=${list.pickLatitude},${list.pickLongitude}";
                                                    await canLaunchUrl(Uri.parse(urlString))
                                                        ? launchUrl(Uri.parse(urlString),
                                                            mode: LaunchMode.externalApplication)
                                                        : Variables.showtoast(context, "Can't open Google Maps App",
                                                            Icons.cancel_outlined);
                                                  },
                                                  icon: Image.asset("assets/icon/icons8-google-maps-64.png"))
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
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20))),
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
                                              Text("Drop Address", style: Variables.font(fontSize: 17)),
                                              IconButton(
                                                  onPressed: () async {
                                                    String urlString =
                                                        "https://www.google.com/maps/dir/?api=1&origin=${Variables.updateOrderMap.latitude},${Variables.updateOrderMap.longitude} &destination=${list.dropLatitude},${list.dropLongitude}";
                                                    await canLaunchUrl(Uri.parse(urlString))
                                                        ? launchUrl(Uri.parse(urlString),
                                                            mode: LaunchMode.externalApplication)
                                                        : Variables.showtoast(context, "Can't open Google Maps App",
                                                            Icons.cancel_outlined);
                                                  },
                                                  icon: Image.asset("assets/icon/icons8-google-maps-64.png"))
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
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20))),
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
                                              // void launchApps(urlString) async {
                                              //   await canLaunchUrl(Uri.parse(urlString))
                                              //       ? launchUrl(Uri.parse(urlString),
                                              //           mode: LaunchMode.externalApplication)
                                              //       : Variables.showtoast(
                                              //           context, "Can't open Google Maps", Icons.cancel_outlined);
                                              // }

                                              await getLiveLocation();

                                              if (list.statusId < 5) {
                                                if (!mounted) return;
                                                if (list.statusId < 4) {
                                                  await Variables.updateOrder(mounted, context, list.id, 4);
                                                }
                                                if (!mounted) return;
                                                if (list.statusId == 4) {
                                                  await Variables.updateOrder(mounted, context, list.id, 5);
                                                }

                                                // launchApps(
                                                //     "https://www.google.com/maps/dir/?api=1&origin=${Variables.updateOrderMap.latitude},${Variables.updateOrderMap.longitude} &destination=${list.pickLatitude},${list.pickLongitude}");
                                              } else if (list.statusId >= 5 && list.statusId < 11) {
                                                if (!mounted) return;
                                                if (list.statusId < 6) {
                                                  await Variables.updateOrder(mounted, context, list.id, 6);
                                                }
                                                if (!mounted) return;
                                                if (list.statusId == 6) {
                                                  await Variables.updateOrder(mounted, context, list.id, 9);
                                                }
                                                if (!mounted) return;
                                                if (list.statusId == 9) {
                                                  await Variables.updateOrder(mounted, context, list.id, 11);
                                                }
                                                // launchApps(
                                                // "https://www.google.com/maps/dir/?api=1&origin=${Variables.updateOrderMap.latitude},${Variables.updateOrderMap.longitude} &destination=${list.dropLatitude},${list.dropLongitude}");
                                              } else if (list.statusId == 11) {
                                                Variables.isdetail = false;
                                                if (!mounted) return;
                                                Variables.push(context, DeliveredPage.routeName);
                                              }

                                              if (!mounted) return;
                                              await reference.getAcceptedAndinProgressOrders();
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Palette.kOrange,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                            child: Row(children: [
                                              list.statusId != 5 && list.statusId != 11
                                                  ? Image.asset("assets/icon/icons8-pointer-64.png",
                                                      height: 22, color: Colors.white)
                                                  : const Icon(Icons.check_rounded),
                                              const SizedBox(width: 5),
                                              Text(
                                                Variables.statusCode(list.statusId),
                                                style: Variables.font(color: Colors.white, fontSize: 15),
                                              )
                                            ]))
                                      ]),
                                  ],
                                ))),
                      ))
            ]));
      } else {
        return Container();
      }
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
    super.dispose();
  }
}
