import 'package:ezshipp/Provider/update_login_provider.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:ezshipp/widgets/textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Provider/update_profile_provider.dart';

// ignore: must_be_immutable
class SignUp extends StatefulWidget {
  bool check = false;
  static final formkey2 = GlobalKey<FormState>();

  SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  int index = 0;
  DecorationImage? decorationImage;

  getcolor() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      index = pref.getInt("color_index") ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    getcolor();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
          key: SignUp.formkey2,
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Consumer2<UpdateLoginProvider, UpdateProfileProvider>(
                  builder: (context, reference, reference1, child) {
                return Column(children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 25),
                      child: InkWell(
                          onTap: () => reference1.inkwell(context), child: reference1.getProfileImage(canEdit: true))),
                  TextFields(title: "First Name", icon: const Icon(Icons.person_outline_rounded), onchange: reference1),
                  TextFields(title: "Last Name", icon: const Icon(Icons.person_outline_rounded), onchange: reference1),
                  TextFields(
                      title: "Email id", icon: const Icon(Icons.email_rounded), type: TextInputType.emailAddress),
                  TextFields(
                    title: "Phone number",
                    icon: const Icon(Icons.phone_enabled_rounded),
                    type: TextInputType.number,
                    verify: reference.userType != "driver",
                  ),
                  TextFields(
                      title: "Password",
                      icon: const Icon(Icons.lock_outline),
                      type: TextInputType.visiblePassword,
                      hidepass: true),
                  TextFields(
                      title: "Confirm Password",
                      icon: const Icon(Icons.lock_outline),
                      type: TextInputType.visiblePassword,
                      hidepass: true),
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Checkbox(
                      value: widget.check,
                      onChanged: (value) => setState(() => widget.check = value!),
                      activeColor: Palette.kOrange,
                    ),
                    Expanded(
                        child: RichText(
                            text: TextSpan(
                                text: "I accept ",
                                style: Variables.font(color: Palette.deepgrey, fontSize: 15),
                                children: [
                          TextSpan(
                              text: "Terms & Conditions",
                              style: Variables.font(color: Palette.kOrange, fontSize: 15),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => _launchURL("https://www.ezshipp.com/terms-conditions/")),
                          const TextSpan(text: " and "),
                          TextSpan(
                              text: "Package & Delivery Policies",
                              style: Variables.font(color: Palette.kOrange, fontSize: 15),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => _launchURL("https://www.ezshipp.com/package-delivery-policy/"))
                        ])))
                  ]),
                  const SizedBox(
                    height: 50,
                  )
                ]);
              }))),
    );
  }

  _launchURL(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }

  showoptions(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          "Choose",
          style: Variables.font(fontSize: 23, color: Palette.deepgrey),
        ),
        children: [
          ListTile(
            onTap: () {
              Navigator.of(context).pop(ImageSource.camera);
            },
            title: Text("Camera", style: Variables.font(fontSize: 18)),
          ),
          ListTile(
            onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            title: Text("Gallery", style: Variables.font(fontSize: 18)),
          ),
          ListTile(
            onTap: () => Navigator.of(context).pop(),
            title: Text("None", style: Variables.font(fontSize: 18)),
          )
        ],
      ),
    );
  }
}
