import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class CustomerInvitePage extends StatelessWidget {
  static String routeName = "/invite";
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
          Variables.dividerName("SHARE eZShipp"),
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
                Variables.showtoast(context, "Copied to Clipboard", Icons.check);
              },
              child: Text(referCode, style: TextStyle(fontSize: 37, color: Colors.grey[600], letterSpacing: 3))),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset("assets/images/Logo.png", height: 38),
          ),
          Variables.dividerName("SHARE YOUR CODE"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (String links in Variables.share.keys)
                apps(Variables.share[links][1], Variables.share[links][0], links, context)
            ],
          ),
        ],
      ),
    );
  }

  void launchApps(BuildContext context, String urlString, String app) async {
    await canLaunchUrl(Uri.parse(urlString))
        ? launchUrl(Uri.parse(urlString), mode: LaunchMode.externalApplication)
        : Variables.showtoast(context, "Can't open $app App", Icons.cancel_outlined);
  }

  apps(String path, String urlString, String app, BuildContext context) {
    try {
      return FloatingActionButton(
          heroTag: app,
          elevation: 3,
          mini: true,
          onPressed: () => launchApps(context, urlString, app),
          child: Image.asset(
            path,
            fit: BoxFit.cover,
          ));
    } catch (e) {
      Variables.showtoast(context, "Unable to locate $e", Icons.cancel_outlined);
    }
    return IconButton(onPressed: () {}, icon: const Icon(Icons.ac_unit));
  }
}
