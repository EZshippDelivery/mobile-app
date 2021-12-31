import 'package:ezshipp/Provider/update_profile_provider.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/variables.dart';
import 'editprofilepage.dart';

class ProfilePage extends StatefulWidget {
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
        backgroundColor: Colors.transparent,
        title: Text(
          "Profile",
          style: Variables.font(fontSize: 17, color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () => Variables.push(context, const EditProfilePage()),
              icon: const Icon(Icons.edit_outlined))
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Consumer<UpdateProfileProvider>(builder: (context, reference, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  color: Palette.deepgrey,
                  height: size.height * 0.6,
                  width: size.width,
                  child: Column(children: [
                    SizedBox(height: size.height * 0.2),
                    reference.getProfileImage(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(reference.fullName, style: Variables.font(color: Colors.white, fontSize: 27)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(reference.profile.email,
                          style: Variables.font(color: Colors.grey.shade500, fontSize: 15)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text("+91 " + reference.profile.phone.toString(),
                          style: Variables.font(color: Colors.grey.shade500, fontSize: 15)),
                    )
                  ])),
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text("Total Orders", style: Variables.font(fontSize: 15, color: Colors.grey[600])),
                        const SizedBox(height: 5),
                        Text(
                          reference.profile.totalOrdersDelivered.toString(),
                          style: Variables.font(fontSize: 25),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text("Last Bill", style: Variables.font(fontSize: 15, color: Colors.grey[600])),
                        const SizedBox(height: 5),
                        Text(
                          reference.profile.lastOrderAmount == 0
                              ? "0"
                              : "₹ " + reference.profile.lastOrderAmount.toString(),
                          style: Variables.font(fontSize: 25),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text("Today Earnings", style: Variables.font(fontSize: 15, color: Colors.grey[600])),
                        const SizedBox(height: 5),
                        Text(
                          reference.profile.todayEarnings == 0
                              ? "0"
                              : "₹ " + reference.profile.todayEarnings.toString(),
                          style: Variables.font(fontSize: 25),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Aadhar Number", style: Variables.font(fontSize: 15)),
                    Text(reference.profile.aadhaarNumber.toString(),
                        style: Variables.font(fontSize: 15, color: Colors.grey[600]))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("License Number", style: Variables.font(fontSize: 15)),
                    Text(reference.profile.licenseNumber.toString(),
                        style: Variables.font(fontSize: 15, color: Colors.grey[600]))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Vehicle Number", style: Variables.font(fontSize: 15)),
                    Text(reference.profile.numberPlate.toString(),
                        style: Variables.font(fontSize: 15, color: Colors.grey[600]))
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  
}
