import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  static String routeName = "/about";
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              Image.asset("assets/images/Logo.png"),
              Padding(padding: const EdgeInsets.all(8), child: Text("eZShipp", style: Variables.font(fontSize: 16))),
              TextButton(
                  onPressed: () async {
                    await canLaunchUrl(Uri.parse(Variables.urlShare))
                        ? launchUrl(Uri.parse(Variables.urlShare), mode: LaunchMode.externalApplication)
                        : Variables.showtoast(context, "Cant Open browser App", Icons.warning_rounded);
                  },
                  child: Text(
                    "www.ezshipp.com",
                    style: Variables.font(color: Palette.kOrange),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Text(
                    "Ezshipp has made intracity deliveries simpler than ever.It is the easiest and most economical way to get your things delivered within Hyderabad without stepping out of the house.\n\nDeliver almost anything – clothes, documents, keys, laptop, and even food – from one place to another in Hyderabad in just a few clicks.It is as convenient as having your own delivery boy a click/call away.",
                    style: Variables.font(fontWeight: FontWeight.w300, color: Colors.grey, fontSize: 16),
                    textAlign: TextAlign.center),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 19.0),
            child: IconButton(onPressed: () => Variables.pop(context), icon: const Icon(LineIcons.arrowLeft)),
          )
        ],
      ),
    );
  }
}
