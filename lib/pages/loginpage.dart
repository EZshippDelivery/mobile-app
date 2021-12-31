// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';

import 'package:ezshipp/APIs/register.dart';
import 'package:ezshipp/Provider/update_login_provider.dart';
import 'package:ezshipp/pages/customer_homepage.dart';
import 'package:ezshipp/tabs/sign_in.dart';
import 'package:ezshipp/tabs/sing_up.dart';
import 'package:ezshipp/utils/routes.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:ezshipp/widgets/tabbar.dart';
import 'package:ezshipp/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'enter_kycpage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late Animation _anim, _anim2;
  late AnimationController animController, animController2;
  late TabController tabController;
  List types = ["Delivery Person", "Customer"];
  bool enterKYC = false;
  String? value;
  List<String>? userType;
  Map<String, dynamic>? profile;
  late UpdateLoginProvider updateLoginProvider;
  int typeIndex = 0;
  ValueNotifier<bool> isResend = ValueNotifier<bool>(false);
  ValueNotifier<int> count = ValueNotifier<int>(45);
  String code = "";
  late Timer timer;

  @override
  void initState() {
    super.initState();
    updateLoginProvider = Provider.of<UpdateLoginProvider>(context, listen: false);
    animController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    animController2 = AnimationController(vsync: this, duration: const Duration(milliseconds: 750));
    animController.addListener(() => setState(() {}));
    animController2.addListener(() => setState(() {}));
    _anim = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animController, curve: Curves.fastOutSlowIn));
    _anim2 = Tween(begin: 0.7, end: 1.0).animate(CurvedAnimation(parent: animController2, curve: Curves.fastOutSlowIn));
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {
        if (tabController.index == 1) {
          animController2.forward();
        } else if (tabController.index == 0) {
          animController2.reverse();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    animController.forward();
    var signin = const SignIn();
    var signup = SignUp();
    return Scaffold(
      backgroundColor: Palette.kOrange,
      body: SafeArea(
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) => Stack(
                  children: [
                    Positioned(
                        top: (constraints.maxHeight - 60.0) * (0.15),
                        left: (constraints.maxWidth - 200) * 0.5,
                        height: 60,
                        child: Image.asset("assets/images/Logo-Light.png")),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: (constraints.maxHeight * _anim2.value * _anim.value),
                        decoration: const BoxDecoration(),
                        child: Scaffold(
                          extendBodyBehindAppBar: true,
                          // appBar: AppBar(
                          //   toolbarHeight: 45,
                          //   shape: const RoundedRectangleBorder(
                          //       borderRadius: BorderRadiusDirectional.only(
                          //           topStart: Radius.circular(20), topEnd: Radius.circular(20))),
                          //   title: TabBar(
                          //       controller: tabController,
                          //       onTap: (value) {
                          //         if (value == 1) {
                          //           animController2.forward();
                          //         } else {
                          //           animController2.reverse();
                          //         }
                          //       },
                          //       tabs: TabBars.tabs),
                          // ),
                          body: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Material(
                              //     color: Palette.kOrange,
                              //     child: SizedBox(
                              //       height: 45,
                              //       child: Container(),
                              //     )),
                              Expanded(
                                  flex: 10,
                                  child: Center(
                                    child: TabBarView(
                                        controller: tabController,
                                        physics: const NeverScrollableScrollPhysics(),
                                        children: [signin, signup]),
                                  ))
                            ],
                          ),
                          bottomNavigationBar: BottomAppBar(
                            shape: const CircularNotchedRectangle(),
                            child: TabBar(
                                labelPadding: const EdgeInsets.all(10),
                                indicatorWeight: 4.0,
                                controller: tabController,
                                onTap: (value) async {
                                  if (value == 1) {
                                    animController2.forward();
                                    if (Variables.showdialog) {
                                      Variables.showdialog = false;
                                      show(context).then((value) => setState(() {
                                            updateLoginProvider.setUsetType(value);
                                          }));
                                    }
                                  } else {
                                    animController2.reverse();
                                  }
                                },
                                tabs: TabBars.tabs),
                          ),
                          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                          floatingActionButton: floatingbutton(context, signin, signup),
                        ),
                      ),
                    ),
                  ],
                )),
      ),
    );
  }

  floatingbutton(BuildContext context, SignIn signin, SignUp signup) => FloatingActionButton(
        heroTag: "login_button",
        onPressed: () async {
          if (tabController.index == 0) {
            if (SignIn.formkey1.currentState!.validate()) {
              updateLoginProvider.store();
              bool value = await getdetails();
              String type = "";
              if (value) {
                if (userType!.length == 2) {
                  typeIndex = await settype(userType!.indexOf(await show(context)));
                  type = userType![typeIndex];
                } else if (userType!.length == 1) {
                  type = userType![typeIndex];
                } else {
                  type = "driver";
                }
              }
              if (value && enterKYC && type == "driver") {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const EnterKYC()));
              } else if (value && !enterKYC && type == "driver") {
                Navigator.pushReplacementNamed(context, MyRoutes.homepage);
              } else if (value && !enterKYC && type != "driver") {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomerHomePage(),
                    ));
              }
            } else {
              Variables.showtoast("Sign In is failed");
            }
          } else if (tabController.index == 1) {
            if (SignUp.formkey2.currentState!.validate() && signup.check) {
              if (updateLoginProvider.userType == "Customer") {
                setState(() {
                  Variables.deviceInfo["userType"] = "CUSTOMER";
                });
              } else {
                setState(() {
                  Variables.deviceInfo["userType"] = "DRIVER";
                });
              }
              await setdetails();
              var response = await updateLoginProvider.httpost(
                  context, Register.from2Maps(Variables.deviceInfo, TextFields.data).toJson());
              if (updateLoginProvider.userType == "Customer") {
                if (await showdialog(
                    context, TextFields.data["Phone number"]!, TextFields.data["Email id"]!, response["id"])) {
                  animController2.reverse();
                  tabController.index = 0;
                }
              }
            } else if (!signup.check) {
              Variables.showtoast("Accept Terms & Conditions");
            } else {
              Variables.showtoast("Something went wrong. Please Try Again");
            }
          }
        },
        child: const Icon(Icons.keyboard_arrow_right_rounded),
      );

  setdetails() async {
    var pref = await SharedPreferences.getInstance();
    pref.setString("username", TextFields.data["Phone number"].toString());
    pref.setString("password", TextFields.data["Password"].toString());
    var data = pref.getStringList("usertype") ?? [];
    if (data.isEmpty) {
      pref.setStringList("usertype", [updateLoginProvider.userType]);
      await settype(0);
    } else {
      var data1 = data.toSet();
      data1.add(updateLoginProvider.userType);
      pref.setStringList("usertype", data1.toList());
      if (data1.length == 1) {
        await settype(0);
      } else {
        await settype(1);
      }
    }
    pref.setBool("mobileSignUp", true);
    if (updateLoginProvider.userType == "driver") {
      pref.setBool("enterKYC", true);
    } else {
      pref.setBool("enterKYC", false);
    }
  }

  settype(int index) async {
    var pref = await SharedPreferences.getInstance();
    pref.setInt("type-index", index);
    return index;
  }

  getdetails() async {
    var pref = await SharedPreferences.getInstance();
    pref.setBool("islogin", true);
    try {
      bool username = pref.getString("username") == TextFields.data["Phone number"];
      bool username1 = pref.getString("username1") == TextFields.data["Phone number"];
      bool username2 = pref.getString("username2") == TextFields.data["Phone number"];
      bool password = pref.getString("password") == TextFields.data["Password"];
      bool password1 = pref.getString("password1") == TextFields.data["Password"];
      bool password2 = pref.getString("password2") == TextFields.data["Password"];
      enterKYC = pref.getBool("enterKYC") ?? false;
      typeIndex = pref.getInt("type-index") ?? 0;

      if (username && password) {
        userType = pref.getStringList("usertype") ?? ["driver"];
      } else if (username1 && password1) {
        userType = [pref.getString("usertype1") ?? "driver"];
      } else if (username2 && password2) {
        userType = [pref.getString("usertype2") ?? "customer"];
      } else {
        throw "error";
      }
      return true;
    } catch (e) {
      Variables.showtoast("Sign In is not successfull");
      return false;
    }
  }

  show(context) => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => SimpleDialog(
            titleTextStyle: Variables.font(fontSize: 22),
            title: const Text("Choose Your Profession"),
            contentPadding: const EdgeInsets.all(20),
            children: [
              Text(
                "Before you fill the details, choose the type of user you like to be",
                style: TextStyle(fontSize: 17, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 10),
              ...ListTile.divideTiles(
                  context: context,
                  tiles: types
                      .map((e) => ListTile(
                            title: Text(e),
                            onTap: () => Variables.pop(context, value: e == "Delivery Person" ? "driver" : e),
                          ))
                      .toList())
            ]),
      );

  showdialog(BuildContext context, String phonenumber, String email, int id) async {
    var code;
    return await showDialog(
        context: context,
        builder: (context) {
          resend(id, email, phonenumber);
          return SimpleDialog(
            contentPadding: const EdgeInsets.all(17),
            alignment: MediaQuery.of(context).viewInsets.bottom > 0 ? Alignment.topCenter : Alignment.center,
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
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Align(
                    alignment: Alignment.center,
                    child: PinFieldAutoFill(
                      codeLength: 6,
                      keyboardType: TextInputType.number,
                      onCodeChanged: (p0) => code = p0!,
                      onCodeSubmitted: (p0) => setState(() => code = p0),
                    )),
              ),
              Column(
                children: [
                  Text(
                    "Didn't recieve any code? ",
                    style: Variables.font(),
                    textAlign: TextAlign.center,
                  ),
                  ValueListenableBuilder(
                      valueListenable: isResend,
                      builder: (context, bool value1, child) {
                        return TextButton(
                            onPressed: () {
                              if (value1) return;
                              resend(id, email, phonenumber);
                            },
                            child: ValueListenableBuilder(
                                valueListenable: count,
                                builder: (context, value, child) {
                                  return Text(
                                    value1 ? "Try again in $value" : "Resend OTP",
                                    textAlign: TextAlign.center,
                                    style: Variables.font(fontSize: 15),
                                  );
                                }));
                      }),
                ],
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)))),
                  onPressed: () async {
                    var validate = await updateLoginProvider.verifyOTP({"otp": code, "phoneNumber": phonenumber});
                    if (validate != null) {
                      if (validate["otpVerified"]) {
                        Variables.showtoast("Your Phone number is verified");
                        Variables.pop(context, value: true);
                      } else {
                        Variables.showtoast("OTP is incorrect. Please try again");
                        Variables.pop(context, value: false);
                      }
                    }
                  },
                  child: Text(
                    "Verify",
                    style: Variables.font(),
                  ))
            ],
          );
        });
  }

  void resend(id, email, phonenumber) {
    updateLoginProvider.getOTP(jsonEncode({"authType": "SMS", "customerId": id, "email": email, "phone": phonenumber}));
    isResend.value = true;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (count.value == 0) {
        count.value = 45;
        isResend.value = false;
        timer.cancel();
      } else {
        count.value--;
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    animController.dispose();
    animController2.dispose();
    isResend.dispose();
    count.dispose();
    super.dispose();
  }
}
