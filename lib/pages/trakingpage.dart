import 'dart:convert';

import 'package:ezshipp/APIs/new_orderlist.dart';
import 'package:ezshipp/Provider/maps_provider.dart';
import 'package:ezshipp/Provider/update_screenprovider.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/themes.dart';

// ignore: must_be_immutable
class TrackingPage extends StatefulWidget {
  NewOrderList order;
  static double rating = 0;

  static bool complete = false;
  TrackingPage(this.order, {Key? key}) : super(key: key);

  @override
  _TrackingPageState createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> with TickerProviderStateMixin {
  int _stepper = 0;
  bool laststep = false;
  DecorationImage? decorationImage;
  String name = "";
  int index = 0;
  late AnimationController animationController;
  late Animation animation;
  late UpdateScreenProvider updateScreen;
  late MapsProvider mapsProvider;
  bool value = false;
  @override
  void initState() {
    super.initState();
    updateScreen = Provider.of<UpdateScreenProvider>(context, listen: false);
    mapsProvider = Provider.of<MapsProvider>(context, listen: false);
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    animation =
        Tween(end: 0.2, begin: 0.3).animate(CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn));
    if (widget.order.bikerProfileUrl.isNotEmpty) {
      if (widget.order.bikerProfileUrl.length < 3) {
        index = int.parse(widget.order.bikerProfileUrl);
      } else {
        decorationImage = DecorationImage(image: MemoryImage(base64Decode(widget.order.bikerProfileUrl)));
      }
    }
    if (widget.order.bikerName.contains(RegExp(r'\s'))) {
      name = widget.order.bikerName[0] + widget.order.bikerName[widget.order.bikerName.indexOf(' ') + 1];
    } else {
      name = widget.order.bikerName[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Variables.pop(context);
        mapsProvider.timer1!.cancel();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: Variables.app(),
        body: Stack(
          children: [
            Consumer<MapsProvider>(builder: (context, reference1, child) {
              return GoogleMap(
                zoomControlsEnabled: false,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                initialCameraPosition: const CameraPosition(target: LatLng(17.387140, 78.491684), zoom: 11.0),
                markers: {
                  if (reference1.driver != null) reference1.driver!,
                },
                onMapCreated: (controller) {},
              );
            }),
            DraggableScrollableSheet(
                builder: (context, scrollController) => SingleChildScrollView(
                    controller: scrollController,
                    child: Card(
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(children: [
                              Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Variables.text(head: "Order Id: ", value: widget.order.orderSeqId)),
                              Variables.dividerName("Order Status", hpadding: 0, vpadding: 5),
                              const SizedBox(height: 5),
                              Consumer<UpdateScreenProvider>(builder: (context, reference, child) {
                                if (widget.order.statusId >= 2) {
                                  _stepper = 1;
                                } else if (widget.order.statusId >= 3) {
                                  _stepper = 2;
                                } else if (widget.order.statusId >= 6) {
                                  _stepper = 3;
                                } else if (widget.order.statusId >= 12) {
                                  TrackingPage.complete = true;
                                }
                                return SizedBox(
                                  height: 75,
                                  width: MediaQuery.of(context).size.width - 32,
                                  child: Stepper(
                                    currentStep: _stepper,
                                    type: StepperType.horizontal,
                                    margin: EdgeInsets.zero,
                                    elevation: 0,
                                    // onStepTapped: (value) {
                                    //   setState(() {
                                    //     _stepper = value;
                                    //   });
                                    // },
                                    controlsBuilder: (context, controlDetails) => Container(),
                                    steps: [
                                      step("Order Received",
                                          Variables.datetime(widget.order.orderCreatedTime, timeNeed: true), 0),
                                      step("Order Accepted",
                                          Variables.datetime(widget.order.acceptedTime, timeNeed: true), 1),
                                      step("Order Picked", Variables.datetime(DateTime.now(), timeNeed: true), 2),
                                      step("Order Delivered",
                                          Variables.datetime(widget.order.deliveredTime, timeNeed: true), 3),
                                    ],
                                  ),
                                );
                              }),
                              Variables.dividerName("Biker Details", hpadding: 0),
                              AnimatedBuilder(
                                  animation: animation,
                                  builder: (context, child) {
                                    return InkWell(
                                        onTap: () {
                                          if (value) {
                                            animationController.forward();
                                          } else {
                                            animationController.reverse();
                                          }
                                          value = !value;
                                        },
                                        child: getProfileImage(
                                            size: MediaQuery.of(context).size.width * animation.value,
                                            canEdit: true,
                                            isNotEqual: true));
                                  }),
                              Row(children: [
                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  const SizedBox(height: 10),
                                  Variables.text(head: "Biker Name: ", value: widget.order.bikerName, vpadding: 4),
                                  Row(children: [
                                    Variables.text(
                                        head: "Biker Phone: ", value: widget.order.bikerPhone.toString(), vpadding: 4),
                                    FloatingActionButton.small(
                                        onPressed: () async {
                                          var url = "telto:${widget.order.bikerPhone}";
                                          await canLaunch(url)
                                              ? launch(url)
                                              : Variables.showtoast("Unable to open Phone App");
                                        },
                                        child: const Icon(Icons.phone, size: 17),
                                        elevation: 3),
                                  ]),
                                  const SizedBox(height: 15),
                                  Consumer<UpdateScreenProvider>(builder: (context, reference, child) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Variables.text(head: "Rate your biker: ", value: "${TrackingPage.rating}"),
                                    );
                                  })
                                ])
                              ]),
                              RatingBar.builder(
                                  glow: false,
                                  updateOnDrag: true,
                                  itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                                  itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: Colors.amber[700],
                                      ),
                                  onRatingUpdate: (value) {
                                    TrackingPage.rating = value;
                                    updateScreen.updateScreen();
                                    updateScreen.bikerRating(widget.order.bikerId, widget.order.id, value.ceil());
                                  })
                            ])))))
          ],
        ),
      ),
    );
  }

  Step step(String title, String subtitle, int index) {
    return Step(
        title: _stepper == index ? Text(title, style: Variables.font()) : Container(),
        content: Container(),
        isActive: _stepper > index || TrackingPage.complete,
        state: _stepper > index || TrackingPage.complete
            ? StepState.complete
            : _stepper == index
                ? StepState.editing
                : StepState.indexed);
  }

  getProfileImage({double size = 150, bool canEdit = false, bool isNotEqual = false}) {
    return Material(
      shape: const CircleBorder(),
      elevation: 2,
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: isNotEqual ? Colors.white : Colors.primaries[index],
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
              height: size,
              width: size,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.primaries[index], image: decorationImage),
              child: decorationImage == null
                  ? Stack(
                      children: [
                        Center(child: Text(name, style: Variables.font(fontSize: size / 2.5, color: Colors.white))),
                        if (canEdit)
                          Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                decoration: const BoxDecoration(shape: BoxShape.circle, color: Palette.deepgrey),
                                child: Padding(
                                  padding: EdgeInsets.all(size * 0.05),
                                  child: Icon(Icons.photo_size_select_small_rounded,
                                      color: Colors.white, size: size < 130 ? 13 : 25),
                                ),
                              ))
                      ],
                    )
                  : null),
        ),
      ),
    );
  }
}
