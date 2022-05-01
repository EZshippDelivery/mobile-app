import 'dart:async';
import 'dart:io';

import 'package:ezshipp/pages/biker/rider_homepage.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:ezshipp/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
import 'package:path_provider/path_provider.dart';

class EnterKYC extends StatefulWidget {
  static GlobalKey<FormState> formkey4 = GlobalKey<FormState>();
  const EnterKYC({Key? key}) : super(key: key);

  @override
  EnterKYCState createState() => EnterKYCState();
}

class EnterKYCState extends State<EnterKYC> {
  int currentStep = 0;
  bool? license, vehicle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Variables.app(elevation: 0),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Complete KYC", style: Variables.font(fontSize: 20)),
          ),
          Stepper(
            steps: steps(),
            currentStep: currentStep,
            onStepTapped: (value) => setState(() => currentStep = value),
            onStepContinue: () async {
              if (currentStep == 0) {
                if (EnterKYC.formkey4.currentState!.validate()) setState(() => currentStep += 1);
              } else if (currentStep == 2) {
                if (license! && vehicle!) {
                  Timer timer = Timer.periodic(
                      const Duration(seconds: 3), (time) => Navigator.of(context, rootNavigator: true).pop(true));
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => SimpleDialog(
                              title: Text(
                                "Accepted",
                                style: Variables.font(fontSize: 22),
                                textAlign: TextAlign.center,
                              ),
                              children: [
                                Image.asset(
                                  "assets/icon/check_circle.gif",
                                  height: 100,
                                ),
                                Text(
                                  "Visit office to complete Human verification of KYC",
                                  style: Variables.font(color: Colors.grey.shade700, fontSize: 17),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "Lets Go!",
                                  style: Variables.font(color: Colors.grey.shade700, fontSize: 17),
                                  textAlign: TextAlign.center,
                                )
                              ])).then((value) {
                    timer.cancel();

                    Navigator.pushNamed(context, HomePage.routeName);
                  });
                  await Variables.write(key: "enterKYC", value: false.toString());
                } else {
                  Variables.showtoast(context, "Your KYC is not verified Properly.\nMake sure every image is verified",
                      Icons.warning_rounded);
                }
              } else {
                setState(() => currentStep += 1);
              }
            },
            onStepCancel: () {
              if (currentStep == 0) {
              } else {
                setState(() => currentStep -= 1);
              }
            },
          )
        ]),
      ),
    );
  }

  Future<bool> scantext({String value = "", String name = ""}) async {
    List<OcrText> texts = [];
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    try {
      texts = await FlutterMobileVision.read(
          multiple: true,
          showText: false,
          waitTap: true,
          forceCloseCameraOnTap: true,
          fps: 5.0,
          imagePath: "${documentDirectory.path}/$name");
      for (OcrText ocr in texts) {
        if (ocr.value == value) return true;
      }
    } on Exception {
      return false;
    }
    return false;
  }

  steps() {
    return [
      Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: Text("Enter KYC details", style: Variables.font(fontSize: 15)),
          content: Form(
            key: EnterKYC.formkey4,
            child: Column(
              children: [
                inputText(title: "License Number", helperText: "ex: XXXXXXXXXXXXXXX"),
                inputText(title: "Vehicle Reg. Number", helperText: "ex: TSXXXXXXXX")
              ],
            ),
          )),
      Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: Text("License Proof", style: Variables.font(fontSize: 15)),
          content: Column(
            children: [
              Row(
                children: [
                  Text("Front Side:", style: Variables.font(fontSize: 15)),
                  const SizedBox(width: 3),
                  FloatingActionButton.small(
                      heroTag: "Lfront",
                      elevation: 1,
                      onPressed: () => setState(() {
                            scantext(value: TextFields.data["License Number"] ?? "", name: "LFront.png")
                                .then((value) => license = value);
                          }),
                      backgroundColor: Palette.kOrange,
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                      )),
                  const SizedBox(width: 10),
                  if (license != null)
                    if (license == true) const Icon(Icons.check_circle_rounded, color: Colors.green),
                  if (license != null)
                    if (license == false) const Icon(Icons.cancel_rounded, color: Colors.red)
                ],
              ),
              Row(
                children: [
                  Text("Back Side:", style: Variables.font(fontSize: 15)),
                  const SizedBox(width: 4),
                  FloatingActionButton.small(
                    heroTag: "Lback",
                    elevation: 1,
                    onPressed: () => scantext(name: "Lback.png"),
                    backgroundColor: Palette.kOrange,
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                    ),
                  )
                ],
              )
            ],
          )),
      Step(
          state: currentStep == 2 && true ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: Text("Vehicle Proof", style: Variables.font(fontSize: 15)),
          content: Column(
            children: [
              Row(
                children: [
                  Text("Front Side:", style: Variables.font(fontSize: 15)),
                  const SizedBox(width: 3),
                  FloatingActionButton.small(
                      heroTag: "Vfront",
                      elevation: 1,
                      onPressed: () => setState(() {
                            scantext(value: TextFields.data["Vehicle Reg. Number"]!, name: "VFront.png")
                                .then((value) => vehicle = value);
                          }),
                      backgroundColor: Palette.kOrange,
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                      )),
                  if (vehicle != null)
                    if (vehicle == true) const Icon(Icons.check_circle_rounded, color: Colors.green),
                  if (vehicle != null)
                    if (vehicle == false) const Icon(Icons.cancel_rounded, color: Colors.red)
                ],
              ),
              Row(
                children: [
                  Text("Back Side:", style: Variables.font(fontSize: 15)),
                  const SizedBox(width: 4),
                  FloatingActionButton.small(
                    heroTag: "Vback",
                    elevation: 1,
                    onPressed: () => scantext(name: "VBack.png"),
                    backgroundColor: Palette.kOrange,
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                    ),
                  )
                ],
              )
            ],
          ))
    ];
  }

  Widget inputText(
      {required String title, required String helperText, TextInputType keboardType = TextInputType.name}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        inputFormatters: [FilteringTextInputFormatter(RegExp(r'[\S]'), allow: true)],
        keyboardType: keboardType,
        onChanged: (value) => setState(() => TextFields.data[title] = value),
        validator: (value) {
          switch (title) {
            case "License Number":
              if (TextFields.data[title]!.length < 16 || TextFields.data[title]!.length > 16) {
                return "Enter valid $title";
              }
              break;
            case "Vehicle Reg. Number":
              if (TextFields.data[title]!.length < 10 || TextFields.data[title]!.length > 10) {
                return "Enter valid $title";
              }
              break;
          }
          return null;
        },
        decoration: InputDecoration(labelText: title, hintText: "Enter $title", helperText: helperText),
      ),
    );
  }
}
