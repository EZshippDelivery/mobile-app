import 'package:ezshipp/Provider/update_profile_provider.dart';
import 'package:ezshipp/pages/biker/editprofilepage.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/variables.dart';

class ProfilePage extends StatefulWidget {
  static String routeName = "/profile";
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                                      child: Text("+91 " + reference.riderProfile!.phone.toString(),
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
                            : "₹ " + reference.riderProfile!.lastOrderAmount.toString()),
                    profileOrders(
                        "Today Earnings",
                        reference.riderProfile!.todayEarnings == 0
                            ? "0"
                            : "₹ " + reference.riderProfile!.todayEarnings.toString()),
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
