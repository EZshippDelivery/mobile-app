import 'dart:async';

import 'package:ezshipp/pages/biker/rider_homepage.dart';
import 'package:ezshipp/utils/textformater.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:ezshipp/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EnterKYC extends StatefulWidget {
  const EnterKYC({Key? key}) : super(key: key);

  @override
  State<EnterKYC> createState() => _EnterKYCState();
}

class _EnterKYCState extends State<EnterKYC> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Variables.app(),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Text("Enter KYC details", style: Variables.font(fontSize: 15)),
          Form(
            key: formkey,
            child: Column(
              children: [
                inputText(title: "License Number", helperText: "ex: XXXXXXXXXXXXXXX"),
                inputText(title: "Vehicle Reg. Number", helperText: "ex: TSXXXXXXXX")
              ],
            ),
          )
        ],
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (formkey.currentState!.validate()) {
            Timer.periodic(const Duration(seconds: 2), (time) {
              time.cancel();
              Navigator.of(context, rootNavigator: true).pop(true);
              Navigator.pushNamed(context, HomePage.routeName);
            });
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
                            "Visit office to complete KYC",
                            style: Variables.font(color: Colors.grey.shade700, fontSize: 17),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Lets Go!",
                            style: Variables.font(color: Colors.grey.shade700, fontSize: 17),
                            textAlign: TextAlign.center,
                          )
                        ]));
            await Variables.write(key: "enterKYC", value: false.toString());
          } else {
            Variables.showtoast(context, "Your KYC is not verified Properly.\nMake sure every image is verified",
                Icons.warning_rounded);
          }
        },
      ),
    );
  }

  Widget inputText(
      {required String title, required String helperText, TextInputType keboardType = TextInputType.name}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        inputFormatters: [
          FilteringTextInputFormatter(RegExp(r'[\S]'), allow: true),
          LengthLimitingTextInputFormatter(title == "License Number" ? 16 : 10),
          UpperCaseTextFormatter()
        ],
        keyboardType: keboardType,
        onChanged: (value) => setState(() => TextFields.data[title] = value),
        validator: (value) {
          switch (title) {
            case "License Number":
              if (TextFields.data[title]!.length != 16) {
                return "Enter valid $title";
              }
              break;
            case "Vehicle Reg. Number":
              if (TextFields.data[title]!.length != 10) {
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

// ignore: must_be_immutable
// class EnterKYC extends StatefulWidget {
//   GlobalKey<FormState> formkey4 = GlobalKey<FormState>();
//   EnterKYC({Key? key}) : super(key: key);

//   @override
//   EnterKYCState createState() => EnterKYCState();
// }

// class EnterKYCState extends State<EnterKYC> {
//   int currentStep = 0;
//   bool? license, vehicle;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: Variables.app(elevation: 0),
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text("Complete KYC", style: Variables.font(fontSize: 20)),
//           ),
//           Consumer<UpdateScreenProvider>(builder: (context, snapshot, child) {
//             return Stepper(
//               steps: steps(),
//               currentStep: currentStep,
//               onStepTapped: (value) {
//                 currentStep = value;
//                 snapshot.updateScreen();
//               },
//               onStepContinue: () async {
//                 if (currentStep == 0) {
//                   if (widget.formkey4.currentState!.validate()) {
//                     currentStep += 1;
//                     snapshot.updateScreen();
//                   }
//                 } else if (currentStep == 2) {
//                   if (license! && vehicle!) {
//                     Timer.periodic(const Duration(seconds: 2), (time) {
//                       time.cancel();
//                       Navigator.of(context, rootNavigator: true).pop(true);
//                       Navigator.pushNamed(context, HomePage.routeName);
//                     });
//                     showDialog(
//                         context: context,
//                         barrierDismissible: false,
//                         builder: (context) => SimpleDialog(
//                                 title: Text(
//                                   "Accepted",
//                                   style: Variables.font(fontSize: 22),
//                                   textAlign: TextAlign.center,
//                                 ),
//                                 children: [
//                                   Image.asset(
//                                     "assets/icon/check_circle.gif",
//                                     height: 100,
//                                   ),
//                                   Text(
//                                     "Visit office to complete KYC",
//                                     style: Variables.font(color: Colors.grey.shade700, fontSize: 17),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                   Text(
//                                     "Lets Go!",
//                                     style: Variables.font(color: Colors.grey.shade700, fontSize: 17),
//                                     textAlign: TextAlign.center,
//                                   )
//                                 ]));
//                     await Variables.write(key: "enterKYC", value: false.toString());
//                   } else {
//                     Variables.showtoast(context,
//                         "Your KYC is not verified Properly.\nMake sure every image is verified", Icons.warning_rounded);
//                   }
//                 } else {
//                   currentStep += 1;
//                   snapshot.updateScreen();
//                 }
//               },
//               onStepCancel: () {
//                 if (currentStep == 0) {
//                 } else {
//                   currentStep -= 1;
//                   snapshot.updateScreen();
//                 }
//               },
//             );
//           })
//         ]),
//       ),
//     );
//   }

//   Future<bool> scantext({String value = "", String name = ""}) async {
//     Directory documentDirectory = await getApplicationDocumentsDirectory();
//     try {
//       final image = await ImagePicker().pickImage(source: ImageSource.camera);
//       if (image != null) {
//         Variables.loadingDialogue(context: context);
//         final file = File("$documentDirectory/$name");
//         file.writeAsBytesSync(await image.readAsBytes());
//         if (name.contains("Front")) {
//           final textRecognizer = GoogleMlKit.vision.textRecognizer();
//           final recognizedText = await textRecognizer.processImage(InputImage.fromFilePath(image.path));
//           for (TextBlock block in recognizedText.blocks) {
//             if (block.text.contains(value)) {
//               if (!mounted) return false;
//               Navigator.pop(context);
//               return true;
//             }
//           }
//         }
//       }
//       if (!mounted) return false;
//       Navigator.pop(context);
//     } on Exception {
//       if (!mounted) return false;
//       Navigator.pop(context);
//       return false;
//     }
//     return false;
//   }

//   steps() {
//     return [
//       Step(
//           state: currentStep > 0 ? StepState.complete : StepState.indexed,
//           isActive: currentStep >= 0,
//           title: Text("Enter KYC details", style: Variables.font(fontSize: 15)),
//           content: Form(
//             key: widget.formkey4,
//             child: Column(
//               children: [
//                 inputText(title: "License Number", helperText: "ex: XXXXXXXXXXXXXXX"),
//                 inputText(title: "Vehicle Reg. Number", helperText: "ex: TSXXXXXXXX")
//               ],
//             ),
//           )),
//       Step(
//           state: currentStep > 1 ? StepState.complete : StepState.indexed,
//           isActive: currentStep >= 1,
//           title: Text("License Proof", style: Variables.font(fontSize: 15)),
//           content: Column(
//             children: [
//               Row(
//                 children: [
//                   Text("Front Side:", style: Variables.font(fontSize: 15)),
//                   const SizedBox(width: 3),
//                   FloatingActionButton.small(
//                       heroTag: "Lfront",
//                       elevation: 1,
//                       onPressed: () => setState(() {
//                             scantext(value: TextFields.data["License Number"] ?? "", name: "LFront.png")
//                                 .then((value) => license = value);
//                           }),
//                       backgroundColor: Palette.kOrange,
//                       child: const Icon(
//                         Icons.camera_alt_rounded,
//                         color: Colors.white,
//                       )),
//                   const SizedBox(width: 10),
//                   if (license != null)
//                     if (license == true) const Icon(Icons.check_circle_rounded, color: Colors.green),
//                   if (license != null)
//                     if (license == false) const Icon(Icons.cancel_rounded, color: Colors.red)
//                 ],
//               ),
//               Row(
//                 children: [
//                   Text("Back Side:", style: Variables.font(fontSize: 15)),
//                   const SizedBox(width: 4),
//                   FloatingActionButton.small(
//                     heroTag: "Lback",
//                     elevation: 1,
//                     onPressed: () => scantext(name: "Lback.png"),
//                     backgroundColor: Palette.kOrange,
//                     child: const Icon(
//                       Icons.camera_alt_rounded,
//                       color: Colors.white,
//                     ),
//                   )
//                 ],
//               )
//             ],
//           )),
//       Step(
//           state: currentStep == 2 && true ? StepState.complete : StepState.indexed,
//           isActive: currentStep >= 2,
//           title: Text("Vehicle Proof", style: Variables.font(fontSize: 15)),
//           content: Column(
//             children: [
//               Row(
//                 children: [
//                   Text("Front Side:", style: Variables.font(fontSize: 15)),
//                   const SizedBox(width: 3),
//                   FloatingActionButton.small(
//                       heroTag: "Vfront",
//                       elevation: 1,
//                       onPressed: () => setState(() {
//                             scantext(value: TextFields.data["Vehicle Reg. Number"]!, name: "VFront.png")
//                                 .then((value) => vehicle = value);
//                           }),
//                       backgroundColor: Palette.kOrange,
//                       child: const Icon(
//                         Icons.camera_alt_rounded,
//                         color: Colors.white,
//                       )),
//                   if (vehicle != null)
//                     if (vehicle == true) const Icon(Icons.check_circle_rounded, color: Colors.green),
//                   if (vehicle != null)
//                     if (vehicle == false) const Icon(Icons.cancel_rounded, color: Colors.red)
//                 ],
//               ),
//               Row(
//                 children: [
//                   Text("Back Side:", style: Variables.font(fontSize: 15)),
//                   const SizedBox(width: 4),
//                   FloatingActionButton.small(
//                     heroTag: "Vback",
//                     elevation: 1,
//                     onPressed: () => scantext(name: "VBack.png"),
//                     backgroundColor: Palette.kOrange,
//                     child: const Icon(
//                       Icons.camera_alt_rounded,
//                       color: Colors.white,
//                     ),
//                   )
//                 ],
//               )
//             ],
//           ))
//     ];
//   }

//   Widget inputText(
//       {required String title, required String helperText, TextInputType keboardType = TextInputType.name}) {
//     return Padding(
//       padding: const EdgeInsets.all(5.0),
//       child: TextFormField(
//         inputFormatters: [
//           FilteringTextInputFormatter(RegExp(r'[\S]'), allow: true),
//           LengthLimitingTextInputFormatter(title == "License Number" ? 16 : 10),
//           UpperCaseTextFormatter()
//         ],
//         keyboardType: keboardType,
//         onChanged: (value) => setState(() => TextFields.data[title] = value),
//         validator: (value) {
//           switch (title) {
//             case "License Number":
//               if (TextFields.data[title]!.length != 16) {
//                 return "Enter valid $title";
//               }
//               break;
//             case "Vehicle Reg. Number":
//               if (TextFields.data[title]!.length != 10) {
//                 return "Enter valid $title";
//               }
//               break;
//           }
//           return null;
//         },
//         decoration: InputDecoration(labelText: title, hintText: "Enter $title", helperText: helperText),
//       ),
//     );
//   }
// }
