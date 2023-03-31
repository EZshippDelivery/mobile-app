import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  static String routeName = "/contact";
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Variables.app(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 64),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 37, vertical: 37),
              child: Column(children: [
                Image.asset("assets/icon/Contact-us-icon-1.png"),
                Text("Find US", style: Variables.font(fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Text("1st Floor, Karan Arcade, Patrika Nagar, Hyderabad, Telangana – 500081.",
                    style: Variables.font(fontWeight: FontWeight.w300, color: Colors.grey.shade600),
                    textAlign: TextAlign.center)
              ]),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 67, vertical: 50),
              child: Column(children: [
                Image.asset("assets/icon/Contact-us-icon-2.png"),
                Text("Make a Call", style: Variables.font(fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Text("+91 9949529308",
                    style: Variables.font(fontWeight: FontWeight.w300, color: Colors.grey.shade600),
                    textAlign: TextAlign.center)
              ]),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(children: [
                Image.asset("assets/icon/Contact-us-icon-3.png"),
                Text("Send a Mail", style: Variables.font(fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Text("contact@ezshipp.com",
                    style: Variables.font(fontWeight: FontWeight.w300, color: Colors.grey.shade600),
                    textAlign: TextAlign.center)
              ]),
            ),
          )
        ],
      ),
    );
  }
}
