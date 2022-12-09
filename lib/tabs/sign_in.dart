import 'package:ezshipp/Provider/update_screenprovider.dart';
import 'package:ezshipp/widgets/textfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/user_controller.dart';
import '../utils/variables.dart';

// ignore: must_be_immutable
class SignIn extends StatefulWidget {
  static final formkey1 = GlobalKey<FormState>(debugLabel: "_signIn");
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  GlobalKey<FormState> formkey3 = GlobalKey<FormState>(debugLabel: "_changePassword");
  GlobalKey<FormState> formkey4 = GlobalKey<FormState>(debugLabel: "_resetPassword");
  TextEditingController username = TextEditingController();
  TextEditingController username1 = TextEditingController();
  ValueNotifier<bool> iconChange = ValueNotifier<bool>(false);
  late UserController userController;

  String code = "";

  @override
  void initState() {
    super.initState();
    userController = Provider.of<UserController>(context, listen: false);
  }

  store() async {
    var islogin = Variables.write(key: "password", value: TextFields.data["Password"].toString());
    return islogin;
  }

  alertdialog(context) {
    username1.text = "";
    return (context) => StatefulBuilder(builder: (context, snapshot) {
          return SimpleDialog(
            title: const Text("Need Help!"),
            contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  "Enter your registered email address/phone number to reset your password",
                  style: Variables.font(fontWeight: FontWeight.w300, fontSize: 17.5, color: Colors.grey[600]),
                ),
              ),
              Form(
                key: formkey4,
                child: ValueListenableBuilder<bool>(
                    valueListenable: iconChange,
                    builder: (context, value, child) {
                      return TextFields(
                          title: "Username",
                          icon: !value ? const Icon(Icons.email_rounded) : const Icon(Icons.phone),
                          type: TextInputType.name,
                          valueNotifier: iconChange,
                          controller: username1,
                          radius: 4);
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(10.0)),
                      child: const Text("Cancel")),
                  ElevatedButton(
                      onPressed: () async {
                        if (formkey4.currentState!.validate()) {
                          await resetPassword(context);
                          Navigator.of(context).pop();
                        } else {
                          Variables.showtoast(context, "Enter valid Username", Icons.warning_rounded);
                        }
                      },
                      child: const Text("Send")),
                ],
              )
            ],
          );
        });
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
                ValueListenableBuilder<bool>(
                    valueListenable: iconChange,
                    builder: (context, value, child) {
                      return TextFields(
                          title: "Username",
                          icon: !value ? const Icon(Icons.email_rounded) : const Icon(Icons.phone),
                          type: TextInputType.emailAddress,
                          controller: username,
                          valueNotifier: iconChange);
                    }),
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
                  onPressed: () =>
                      showDialog(context: context, barrierDismissible: false, builder: alertdialog(context)),
                ),
                if (kReleaseMode == false)
                  Row(
                    children: [
                      Consumer<UpdateScreenProvider>(builder: (context, snapshot, data) {
                        return DropdownButton(
                            items: const [
                              DropdownMenuItem(value: "https", child: Text("HTTPS")),
                              DropdownMenuItem(value: "http", child: Text("HTTP"))
                            ],
                            value: Variables.urlSchema,
                            onChanged: (value) {
                              snapshot.updateScreen();
                              Variables.urlSchema = value!;
                            });
                      }),
                      Expanded(
                        child: TextFormField(
                          controller: TextEditingController.fromValue(TextEditingValue(text: Variables.urlhost)),
                          onChanged: (value) {
                            Variables.urlhost = value;
                          },
                        ),
                      )
                    ],
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
    dynamic message = await userController.resetPassword(mounted, context, TextFields.data["Username"]!);
    if (message is Map<String, dynamic>) {
      if (message['code'] == 200) {
        await showDialog(
          context: context,
          barrierDismissible: false,
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
                    TextFields(title: "Reset Code", icon: const Icon(Icons.password), radius: 4),
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
                            if (message["data"] == TextFields.data["Reset Code"]) {
                              dynamic response = await userController.changePassword(
                                  context,
                                  mounted,
                                  TextFields.data["Username"]!,
                                  TextFields.data["Password"]!,
                                  TextFields.data["Reset Code"]!);
                              if (response is Map<String, dynamic>) {
                                if (!mounted) return;
                                Variables.showtoast(context, response["message"], Icons.info);
                              }
                              await store();
                              if (!mounted) return;
                              Navigator.of(context).pop();
                            } else {
                              Variables.showtoast(context, "Reset code is incorrect", Icons.warning_amber_rounded);
                            }
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
      } else {
        Variables.showtoast(context, message['message'], Icons.cancel_outlined);
      }
    }
  }
}
