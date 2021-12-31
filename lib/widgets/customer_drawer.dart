import 'package:ezshipp/pages/aboutpage.dart';
import 'package:ezshipp/pages/customer_invitepage.dart';
import 'package:ezshipp/pages/customer_profilepage.dart';
import 'package:ezshipp/pages/saved_addresspage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/update_profile_provider.dart';
import '../utils/themes.dart';
import '../utils/variables.dart';

class CustomerDrawer extends StatefulWidget {
  const CustomerDrawer({Key? key}) : super(key: key);

  @override
  _CustomerDrawerState createState() => _CustomerDrawerState();
}

class _CustomerDrawerState extends State<CustomerDrawer> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width * 0.75,
        color: Colors.grey[100],
        child: Consumer<UpdateProfileProvider>(
            builder: (context, reference, child) => Drawer(
                    child: Column(children: [
                  Container(
                      height: size.height * 0.3,
                      color: Palette.kOrange,
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(children: [
                            InkWell(
                                onTap: () => Variables.push(context, const CustomerProfilePage()),
                                child: reference.getProfileImage(size: 100, canEdit: true)),
                            const SizedBox(width: 10),
                            Expanded(
                                child: TextButton(
                                    onPressed: () => Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (context) => const CustomerProfilePage())),
                                    child: Text(
                                      reference.profile.name,
                                      style: Variables.font(fontSize: 24, color: Colors.white),
                                    )))
                          ]))),
                  ListTile(
                    leading: Image.asset("assets/icon/icons8-address-100.png"),
                    title: Text("Saved Address", style: Variables.font(fontSize: 15)),
                    onTap: () => Variables.push(context, const SavedAddressPage()),
                  ),
                  ListTile(
                    leading: Image.asset("assets/icon/icons8-about-100.png"),
                    title: Text("About", style: Variables.font(fontSize: 15)),
                    onTap: () => Variables.push(context, const AboutPage()),
                  ),
                  ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset("assets/icon/icons8-invite-48.png"),
                    ),
                    title: Text("Invite", style: Variables.font(fontSize: 15)),
                    onTap: () => Variables.push(context, CustomerInvitePage(referCode: reference.profile.referralCode)),
                  ),
                  ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Image.asset(
                          "assets/icon/customer-service.png",
                          height: 43,
                        ),
                      ),
                      title: Text("Customer Care", style: Variables.font(fontSize: 15)),
                      onTap: () {}),
                ]))));
  }
}
