import 'package:ezshipp/Provider/update_profile_provider.dart';
import 'package:ezshipp/pages/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/themes.dart';
import '../utils/variables.dart';
import 'editprofilepage.dart';

class CustomerProfilePage extends StatefulWidget {
  const CustomerProfilePage({Key? key}) : super(key: key);

  @override
  _CustomerProfilePageState createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
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
        return Column(
          children: [
            ClipPath(
                clipper: Clipper(cut: 30),
                child: Container(
                    color: Palette.kOrange,
                    height: size.height / 2.5,
                    margin: const EdgeInsets.only(bottom: 3),
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ClipPath(
                        clipper: Clipper(cut: 40),
                        child: Container(
                            color: Colors.amber[800],
                            margin: const EdgeInsets.only(bottom: 5),
                            padding: const EdgeInsets.only(bottom: 20),
                            child: ClipPath(
                                clipper: Clipper(cut: 55, curve: 16),
                                child: Container(
                                    color: Palette.deepgrey,
                                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                                      const SizedBox(height: 30),
                                      Hero(
                                          tag: "Customer Profile",
                                          child: reference.getProfileImage(size: size.width / 3.1, isNotEqual: true)),
                                      const SizedBox(height: 5),
                                      Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: Text(reference.fullName,
                                            style: Variables.font(color: Colors.grey[300], fontSize: 16)),
                                      ),
                                      Text(reference.profile.email, style: Variables.font(color: Colors.grey)),
                                      if (reference.profile.phone != 0)
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text("+91 " + reference.profile.phone.toString(),
                                              style: Variables.font(color: Colors.grey)),
                                        ),
                                      const SizedBox(height: 10),
                                      Row(),
                                    ]))))))),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text("More Details", style: Variables.font(color: Colors.grey, fontSize: 25)),
            ),
            Variables.text1(
                head: "Your Plan",
                value: reference.plan,
                hpadding: 30,
                vpadding: 4,
                headStyle: Variables.font(fontSize: 15, color: Colors.grey[600]),
                valueStyle: Variables.font(fontSize: 16)),
            Variables.text1(
                head: "Your Total Orders",
                value: reference.orderscount.toString(),
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
                      onPressed: () => Variables.push(context, const EditProfilePage()),
                      icon: const Icon(Icons.edit_outlined),
                      label: Text(
                        "Edit",
                        style: Variables.font(color: null),
                      )),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
