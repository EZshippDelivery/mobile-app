import 'package:ezshipp/Provider/maps_provider.dart';
import 'package:ezshipp/Provider/update_profile_provider.dart';
import 'package:ezshipp/utils/routes.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/aboutpage.dart';
import '../pages/contact_page.dart';
import '../pages/profilepage.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.73,
      color: Colors.grey[100],
      child: Consumer<UpdateProfileProvider>(builder: (context, reference, child) {
        return Drawer(
            child: Column(
          children: [
            Container(
                height: size.height * 0.3,
                color: Palette.kOrange,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () => Variables.push(context, const ProfilePage()),
                        child: Hero(
                          tag: "Driver Profile",
                          child: reference.getProfileImage(size: size.width / 3.7, canEdit: true),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                          child: TextButton(
                              onPressed: () => Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) => const ProfilePage())),
                              child: Text(
                                reference.fullName,
                                style: Variables.font(fontSize: 24, color: Colors.white),
                              )))
                    ]))),
            Consumer<MapsProvider>(builder: (context, reference1, child) {
              return ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(reference1.isOnline ? "Online" : "Offline", style: Variables.font(fontSize: 15)),
                ),
                trailing: Switch.adaptive(
                    value: reference1.isOnline, onChanged: (value) => reference1.online(value, Variables.driverId)),
              );
            }),
            ...ListTile.divideTiles(context: context, tiles: [
              ListTile(
                  onTap: () {
                    Variables.pop(context);
                    Variables.push(context, const ContactPage());
                  },
                  leading: Image.asset("assets/icon/icons8-online-support-150.png"),
                  title: Text("Contact us", style: Variables.font(fontSize: 15))),
              ListTile(
                  onTap: () {
                    Variables.pop(context);
                    Variables.push(context, const AboutPage());
                  },
                  leading: Image.asset("assets/icon/icons8-about-100.png"),
                  title: Text("About", style: Variables.font(fontSize: 15))),
              ListTile(
                  onTap: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                              title: Text("Alert!", style: Variables.font(fontSize: 20)),
                              content: Text("Are you sure,you want to sign out?", style: Variables.font(fontSize: 16)),
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
                                    onPressed: () {
                                      Navigator.of(context).popAndPushNamed(MyRoutes.loginpage);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "YES",
                                        style: Variables.font(fontSize: 16, color: Colors.white),
                                      ),
                                    ))
                              ])),
                  leading: Image.asset("assets/icon/icons8-logout-150.png"),
                  title: Text("Sign out", style: Variables.font(fontSize: 15)))
            ]),
          ],
        ));
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
