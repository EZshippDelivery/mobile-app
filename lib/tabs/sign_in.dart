import 'package:ezshipp/widgets/textfield.dart';
import 'package:flutter/material.dart';

import '../utils/variables.dart';

// ignore: must_be_immutable
class SignIn extends StatefulWidget {
  static final formkey1 = GlobalKey<FormState>();
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  GlobalKey<FormState> formkey3 = GlobalKey<FormState>();
  String code = "";

  store() async {
    var islogin = Variables.write(key: "password", value: TextFields.data["Password"].toString());
    return islogin;
  }

  alertdialog(context) {
    return (context) => SimpleDialog(
          title: const Text("Need Help!"),
          contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
          children: [
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                "Enter your registered email address to reset your password",
                style: Variables.font(fontWeight: FontWeight.w300, fontSize: 17.5, color: Colors.grey[600]),
              ),
            ),
            TextFields(
                title: "Email id", icon: const Icon(Icons.email_rounded), type: TextInputType.phone, radius: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(10.0)),
                    child: const Text("Cancel")),
                ElevatedButton(
                    onPressed: () async {
                      if (TextFields.data["Email id"]!.contains(RegExp(r"\s")) || TextFields.data["Email id"]!.contains(RegExp("@"))) {
                        await resetPassword(context);
                        Navigator.of(context).pop();
                      } else {
                        Variables.showtoast(context,"Enter valid Email id",Icons.warning_rounded);
                      }
                    },
                    child: const Text("Send")),
              ],
            )
          ],
        );
  }

  @override
  Widget build(BuildContext context) {
    final maxH = (MediaQuery.of(context).size.height * 0.7);
    return SingleChildScrollView(
      child: Form(
          key: SignIn.formkey1,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFields(title: "Username", icon: const Icon(Icons.email_rounded), type: TextInputType.emailAddress),
                TextFields(
                    title: "Password",
                    icon: const Icon(Icons.lock_outline),
                    type: TextInputType.visiblePassword,
                    hidepass: true),
                const SizedBox(height: 10),
                TextButton(
                  child: Text(
                    "Forgot Password?",
                    style: Variables.font(color: null),
                  ),
                  onPressed: () => showDialog(context: context, builder: alertdialog(context)),
                ),
                SizedBox(
                  height: maxH * (0.35),
                ),
              ],
            ),
          )),
    );
  }

  

  Future<void> resetPassword(context) async {
    await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text("Reset Password"),
        contentPadding: const EdgeInsets.all(10),
        children: [
          Form(
            key: formkey3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Reset your password",
                    style: Variables.font(fontWeight: FontWeight.w300, fontSize: 18, color: Colors.grey[600]),
                  ),
                ),
                TextFields(
                    title: "New Password",
                    icon: const Icon(Icons.lock_outline),
                    type: TextInputType.visiblePassword,
                    hidepass: true,
                    radius: 4),
                TextFields(
                    title: "Confirm Password",
                    icon: const Icon(Icons.lock_outline),
                    type: TextInputType.visiblePassword,
                    hidepass: true,
                    radius: 4),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)))),
                    onPressed: () async {
                      if (formkey3.currentState!.validate()) {
                        await store();
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text("Reset"),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
