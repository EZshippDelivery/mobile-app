import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class CustomerInvitePage extends StatelessWidget {
  String referCode;
  CustomerInvitePage({
    Key? key,
    required this.referCode,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Variables.referalCode = referCode;
    return Scaffold(
      appBar: Variables.app(),
      body: Column(
        children: [
          dividerName("SHARE eZShipp"),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Text(
                "Share eZShipp with your friends and family and we will reward you with some great deals and offers",
                style: Variables.font(fontSize: 19, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              )),
          Text(
            "Referal Code:",
            style: Variables.font(fontSize: 15, color: Colors.grey[600]),
          ),
          GestureDetector(
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: referCode));
                Variables.showtoast("Copied to Clipboard");
              },
              child: Text(referCode, style: TextStyle(fontSize: 37, color: Colors.grey[600], letterSpacing: 3))),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset("assets/images/Logo.png", height: 38),
          ),
          dividerName("SHARE YOUR CODE"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (String links in Variables.share.keys)
                apps(Variables.share[links][1], Variables.share[links][0], links)
            ],
          ),
        ],
      ),
    );
  }

  void launchApps(urlString, app) async {
    await canLaunch(urlString) ? launch(urlString) : Variables.showtoast("Can't open $app App");
  }

  apps(String path, String urlString, String app) {
    try {
      return FloatingActionButton(
          heroTag: app,
          elevation: 3,
          mini: true,
          onPressed: () => launchApps(urlString, app),
          child: Image.asset(
            path,
            fit: BoxFit.cover,
          ));
    } catch (e) {
      Variables.showtoast("Unable to locate $e");
    }
    return IconButton(onPressed: () {}, icon: const Icon(Icons.ac_unit));
  }

  Padding dividerName(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Row(children: [
        const Expanded(
            child: Divider(
          indent: 10,
          endIndent: 10,
          thickness: 2,
        )),
        Text(
          name,
          style: Variables.font(fontSize: 15, color: Colors.grey),
        ),
        const Expanded(
            child: Divider(
          indent: 10,
          endIndent: 10,
          thickness: 2,
        )),
      ]),
    );
  }
}
