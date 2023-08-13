import 'package:ezshipp/Provider/auth_controller.dart';
import 'package:ezshipp/Provider/biker_controller.dart';
import 'package:ezshipp/Provider/update_profile_provider.dart';
import 'package:ezshipp/pages/biker/editprofilepage.dart';
import 'package:ezshipp/pages/loginpage.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../utils/variables.dart';

class ProfilePage extends StatefulWidget {
  static String routeName = "/profile";
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Palette.deepgrey,
        elevation: 0,
        title: Text(
          "Profile",
          style: Variables.font(fontSize: 17, color: Colors.white),
        ),
        actions: [
          FloatingActionButton.extended(
              heroTag: "driver_edit",
              elevation: 0,
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                          title: Text("Alert!", style: Variables.font(fontSize: 20)),
                          content: Text("Are you sure, you really want to delete your account?",
                              style: Variables.font(fontSize: 16)),
                          actionsAlignment: MainAxisAlignment.spaceEvenly,
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("NO", style: Variables.font(fontSize: 16, color: Colors.white)),
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  AuthController authController = Provider.of<AuthController>(context, listen: false);
                                  BikerController bikerController =
                                      Provider.of<BikerController>(context, listen: false);
                                  UpdateProfileProvider profileController =
                                      Provider.of<UpdateProfileProvider>(context, listen: false);
                                  await authController.storeLoginStatus(false);
                                  await Variables.pref.deleteAll(aOptions: Variables.getAndroidOptions());
                                  if (!mounted) return;
                                  if (bikerController.timer != null) bikerController.timer!.cancel();
                                  if (!mounted) return;
                                  String subject = "Account Deletion Request";
                                  String sendText =
                                      "\nDear Ezshipp Support Team,\n\nI am writing to formally request the deletion of my Ezshipp account. After careful consideration, I have decided to discontinue my association with Ezshipp and would appreciate your assistance in permanently deleting my account.\n\nI understand that this process will involve the removal of all my personal information and associated data from your systems. Please ensure that this deletion is completed promptly and confirm the successful closure of my account at your earliest convenience.\n\nThank you for your prompt attention to this matter.\n\nSincerely,\n\n${profileController.fullName}";
                                  var uri =
                                      Uri(scheme: "mailto",path: "info@ezshipp.com", queryParameters: {"subject": subject, "body": sendText});
                                  if (await canLaunchUrl(uri)) {
                                    if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                                      Variables.showtoast(context, "Your", Icons.cancel_outlined);
                                    }
                                  } else {
                                    Variables.showtoast(context, "Can't open mail App", Icons.cancel_outlined);
                                  }
                                  if (!mounted) return;
                                  Navigator.pop(context);
                                  Navigator.pushNamedAndRemoveUntil(context, LoginPage.routeName, (route) => false);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "YES",
                                    style: Variables.font(fontSize: 16, color: Colors.white),
                                  ),
                                ))
                          ])),
              label: const Icon(Icons.edit_outlined))
        ],
      ),
      body: Consumer<UpdateProfileProvider>(builder: (context, reference, child) {
        return Column(children: [
          ClipPath(
              clipper: Clipper(cut: 30),
              child: Container(
                  color: Palette.kOrange,
                  height: size.height * 0.38,
                  margin: const EdgeInsets.only(bottom: 3),
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ClipPath(
                      clipper: Clipper(cut: 40),
                      child: Container(
                          color: Colors.amber[800],
                          margin: const EdgeInsets.only(bottom: 2),
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ClipPath(
                              clipper: Clipper(cut: 55, curve: 16),
                              child: Container(
                                  color: Palette.deepgrey,
                                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                                    const SizedBox(height: 20),
                                    Hero(
                                        tag: "Driver Profile",
                                        child: reference.getProfileImage(size: size.width / 3.5, isNotEqual: true)),
                                    Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: Text(reference.fullName,
                                          style: Variables.font(color: Colors.grey[300], fontSize: 16)),
                                    ),
                                    Text(reference.riderProfile!.email, style: Variables.font(color: Colors.grey)),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text("+91 ${reference.riderProfile!.phone}",
                                          style: Variables.font(color: Colors.grey)),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(),
                                  ]))))))),
          Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              elevation: 3,
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    profileOrders("Total Orders", reference.riderProfile!.totalOrdersDelivered.toString()),
                    profileOrders(
                        "Last Bill",
                        reference.riderProfile!.lastOrderAmount == 0
                            ? "0"
                            : "₹ ${reference.riderProfile!.lastOrderAmount}"),
                    profileOrders(
                        "Today Earnings",
                        reference.riderProfile!.todayEarnings == 0
                            ? "0"
                            : "₹ ${reference.riderProfile!.todayEarnings}"),
                  ]))),
          const SizedBox(height: 15),
          // Variables.text1(
          //     head: "Aadhar Number",
          //     value: reference.profile.aadhaarNumber.toString(),
          //     hpadding: 30,
          //     vpadding: 4,
          //     headStyle: Variables.font(fontSize: 15, color: Colors.grey[600]),
          //     valueStyle: Variables.font(fontSize: 16)),
          Variables.text1(
              head: "License Number",
              value: reference.riderProfile!.licenseNumber.toString().isEmpty
                  ? "Not Registered"
                  : reference.riderProfile!.licenseNumber.toString(),
              hpadding: 30,
              vpadding: 4,
              headStyle: Variables.font(fontSize: 15, color: Colors.grey[600]),
              valueStyle: Variables.font(fontSize: 16)),
          Variables.text1(
              head: "Vehicle Number",
              value: reference.riderProfile!.numberPlate.toString().isEmpty
                  ? "Not Registered"
                  : reference.riderProfile!.numberPlate.toString(),
              hpadding: 30,
              vpadding: 4,
              headStyle: Variables.font(fontSize: 15, color: Colors.grey[600]),
              valueStyle: Variables.font(fontSize: 16)),
          const Spacer(),
          Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: (48 / 2) - 3),
                  RotatedBox(
                      quarterTurns: 2,
                      child: ClipPath(
                          clipper: Clipper(cut: 30, curve: 10),
                          child: Container(
                            color: Palette.kOrange,
                            height: size.height * 0.1,
                          ))),
                ],
              ),
              Align(
                alignment: Alignment.topCenter,
                child: FloatingActionButton.extended(
                    onPressed: () => Variables.push(context, EditProfilePage.routeName),
                    icon: const Icon(Icons.edit_outlined),
                    label: Text(
                      "Edit",
                      style: Variables.font(color: null),
                    )),
              ),
            ],
          ),
        ]);
      }),
    );
  }

  Column profileOrders(String head, String value) {
    return Column(
      children: [
        Text(head, style: Variables.font(fontSize: 15, color: Colors.grey[600])),
        const SizedBox(height: 5),
        Text(
          value,
          style: Variables.font(fontSize: 25),
        )
      ],
    );
  }
}

class Clipper extends CustomClipper<Path> {
  int _cut = 0;
  int _curve = 0;
  Clipper({required int cut, int curve = 0}) {
    _cut = cut;
    _curve = curve;
  }

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - _cut);
    var controlpoint = Offset(size.width / 2, size.height + 10 + _curve);
    var endpoint = Offset(size.width, size.height - _cut);
    path.quadraticBezierTo(controlpoint.dx, controlpoint.dy, endpoint.dx, endpoint.dy);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
