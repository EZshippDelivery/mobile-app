import 'package:ezshipp/Provider/update_profile_provider.dart';
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
        backgroundColor: Colors.transparent,
        title: Text(
          "Profile",
          style: Variables.font(fontSize: 17, color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () => Variables.push(context, const EditProfilePage()), icon: const Icon(Icons.edit_outlined))
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
                    if (reference.profile.phone != 0)
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text("+91 " + reference.profile.phone.toString(),
                            style: Variables.font(color: Colors.grey.shade500, fontSize: 15)),
                      )
                  ])),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text("More Details", style: Variables.font(color: Colors.grey, fontSize: 25)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Your Plan", style: Variables.font(fontSize: 15)),
                    Text(
                      reference.plan,
                      style: Variables.font(fontSize: 16, color: Colors.grey[600]),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Your Total Orders", style: Variables.font(fontSize: 15)),
                    Text(
                      reference.orderscount.toString(),
                      style: Variables.font(fontSize: 16, color: Colors.grey[600]),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
