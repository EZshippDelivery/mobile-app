import 'package:ezshipp/pages/aboutpage.dart';
import 'package:ezshipp/pages/customer/customer_invitepage.dart';
import 'package:ezshipp/pages/customer/customer_profilepage.dart';
import 'package:ezshipp/pages/biker/saved_addresspage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Provider/update_profile_provider.dart';
import '../utils/themes.dart';
import '../utils/variables.dart';

class CustomerDrawer extends StatefulWidget {
  const CustomerDrawer({Key? key}) : super(key: key);

  @override
  CustomerDrawerState createState() => CustomerDrawerState();
}

class CustomerDrawerState extends State<CustomerDrawer> {
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
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () => Variables.push(context, CustomerProfilePage.routeName),
                              child: Hero(
                                tag: "Customer Profile",
                                child: reference.getProfileImage(size: size.width / 3.6, canEdit: true),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                                child: TextButton(
                                    onPressed: () => Variables.push(context, CustomerProfilePage.routeName),
                                    child: Text(
                                      reference.customerProfile!.name,
                                      style: Variables.font(fontSize: 24, color: Colors.white),
                                    )))
                          ]))),
                  ListTile(
                    leading: Image.asset("assets/icon/icons8-address-100.png"),
                    title: Text("Saved Address", style: Variables.font(fontSize: 15)),
                    onTap: () => Variables.push(context, SavedAddressPage.routeName),
                  ),
                  ListTile(
                    leading: Image.asset("assets/icon/icons8-about-100.png"),
                    title: Text("About", style: Variables.font(fontSize: 15)),
                    onTap: () => Variables.push(context, AboutPage.routeName),
                  ),
                  ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset("assets/icon/icons8-invite-48.png"),
                    ),
                    title: Text("Invite", style: Variables.font(fontSize: 15)),
                    onTap: () => Variables.push(context, CustomerInvitePage.routeName),
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
                      onTap: () async {
                        var url = "tel:04049674477";
                        await canLaunchUrl(Uri.parse(url))
                            ? launchUrl(Uri.parse(url))
                            : Variables.showtoast(context, "Unable to open Phone App", Icons.cancel_outlined);
                      }),
                ]))));
  }
}
