import 'package:ezshipp/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otp/otp.dart';
import 'package:sms_advanced/sms_advanced.dart';
import 'package:sms_autofill/sms_autofill.dart';

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
    var islogin = Variables.pref.write(key: "password", value: TextFields.data["Password"].toString());
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
                "Enter your phone number below to receive OTP",
                style: Variables.font(fontWeight: FontWeight.w300, fontSize: 18, color: Colors.grey[600]),
              ),
            ),
            TextFields(
                title: "Phone number", icon: const Icon(Icons.phone_rounded), type: TextInputType.phone, radius: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(10.0)),
                    child: const Text("Cancel")),
                ElevatedButton(
                    onPressed: () async {
                      if (TextFields.data["Phone number"]!.length == 10) {
                        if (await showdialog(context, TextFields.data["Phone number"].toString())) {
                          await resetPassword(context);
                        }
                        Navigator.of(context).pop();
                      } else {
                        Variables.showtoast("Enter valid phone number");
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
                TextFields(title: "Username", icon: const Icon(Icons.phone_rounded), type: TextInputType.phone),
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

  showdialog(BuildContext context, String phonenumber) async {
    final code = OTP.generateTOTPCodeString('JBSWY3DPEHPK3PXP', DateTime.now().millisecondsSinceEpoch,
        interval: 20, algorithm: Algorithm.SHA512);
    Future.delayed(const Duration(seconds: 2), () async {
      await SmsAutoFill().listenForCode();
      SmsSender()
          .sendSms(SmsMessage(phonenumber, 'ezShipp: Your code is $code.\n${await SmsAutoFill().getAppSignature}'));
    });
    return await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            contentPadding: const EdgeInsets.all(17),
            alignment: Alignment.center,
            children: [
              SvgPicture.asset("assets/images/otp & two-factor.svg"),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text("Enter OTP",
                    textAlign: TextAlign.center,
                    style: Variables.font(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                    )),
              ),
              Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    "Enter OTP code to verify your phone number",
                    textAlign: TextAlign.center,
                    style: Variables.font(fontWeight: FontWeight.w300, fontSize: 18, color: Colors.grey[600]),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 13),
                child: Align(
                    alignment: Alignment.center,
                    child: PinFieldAutoFill(
                        codeLength: 6,
                        keyboardType: TextInputType.number,
                        onCodeChanged: (p0) => this.code = p0!,
                        onCodeSubmitted: (p0) => this.code = p0)),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)))),
                  onPressed: () {
                    if (this.code == code) {
                      Variables.showtoast("Your Phone number is verified");
                      Navigator.of(context).pop(true);
                    } else {
                      Variables.showtoast("OTP is incorrect ${this.code}");
                      Navigator.of(context).pop(false);
                    }
                  },
                  child: const Text("Verify"))
            ],
          );
        });
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
