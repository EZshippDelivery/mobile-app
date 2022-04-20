// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';

import 'package:ezshipp/APIs/register.dart';
import 'package:ezshipp/Provider/auth_controller.dart';
import 'package:ezshipp/pages/customer/customer_homepage.dart';
import 'package:ezshipp/pages/biker/rider_homepage.dart';
import 'package:ezshipp/tabs/sign_in.dart';
import 'package:ezshipp/tabs/sign_up.dart';
import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:ezshipp/widgets/tabbar.dart';
import 'package:ezshipp/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../Provider/customer_controller.dart';
import 'biker/enter_kycpage.dart';

class LoginPage extends StatefulWidget {
  static String routeName = "/login";
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late Animation _anim, _anim2;
  late AnimationController animController, animController2;
  late TabController tabController;
  late AuthController authController;
  late CustomerController customerController;
  late Timer timer;

  ValueNotifier<bool> isResend = ValueNotifier<bool>(false);
  ValueNotifier<int> count = ValueNotifier<int>(45); //OTP Timer

  int typeIndex = 0;
  String code = "";
  bool enterKYC = false;
  String? value;
  String userType = "";
  Map<String, dynamic>? profile;
  List types = ["Delivery Person", "Customer"];

  @override
  void initState() {
    super.initState();
    authController = Provider.of<AuthController>(context, listen: false);
    customerController = Provider.of<CustomerController>(context, listen: false);
    animController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    animController2 = AnimationController(vsync: this, duration: const Duration(milliseconds: 750));
    _anim = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animController, curve: Curves.fastOutSlowIn));
    _anim2 = Tween(begin: 0.7, end: 1.0).animate(CurvedAnimation(parent: animController2, curve: Curves.fastOutSlowIn));
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      if (tabController.index == 1) {
        animController2.forward();
      } else if (tabController.index == 0) {
        animController2.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    animController.forward();
    return Scaffold(
      backgroundColor: Palette.kOrange,
      body: SafeArea(
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) => Stack(children: [
                    Positioned(
                        //Company Logo
                        top: (constraints.maxHeight - 60.0) * (0.15),
                        left: (constraints.maxWidth - 200) * 0.5,
                        height: 60,
                        child: Image.asset("assets/images/Logo-Light.png")),
                    AnimatedBuilder(
                        animation: _anim,
                        builder: (context, outerChild) {
                          return AnimatedBuilder(
                              animation: _anim2,
                              builder: (context, innerChild) {
                                return Align(
                                    alignment: Alignment.bottomCenter,
                                    child: SizedBox(
                                        height: (constraints.maxHeight * _anim2.value * _anim.value),
                                        child: outerChild));
                              });
                        },
                        child: Scaffold(
                          extendBodyBehindAppBar: true,
                          body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Expanded(
                                flex: 10,
                                child: Center(
                                    child: TabBarView(
                                        controller: tabController,
                                        physics: const NeverScrollableScrollPhysics(),
                                        children: const [SignIn(), SignUp()])))
                          ]),
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
                                        show(context).then((value) => authController.setUserType(value));
                                      }
                                    } else {
                                      animController2.reverse();
                                    }
                                  },
                                  tabs: TabBars.tabs)),
                          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                          floatingActionButton: floatingbutton(context),
                        ))
                  ]))),
    );
  }

  floatingbutton(BuildContext context) => FloatingActionButton(
      heroTag: "login_button",
      onPressed: () async {
        if (await InternetConnectionChecker().hasConnection) {
          if (tabController.index == 0) {
            if (SignIn.formkey1.currentState!.validate()) {
              await readDetails();
              authController.storeLoginStatus(true);
              if (enterKYC && userType.toLowerCase() == "driver") {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const EnterKYC()));
              } else if (!enterKYC && userType.toLowerCase() == "driver") {
                Navigator.pushReplacementNamed(context, HomePage.routeName);
              } else if (!enterKYC && userType.toLowerCase() == "customer") {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CustomerHomePage()));
              } else {
                Variables.showtoast(context, "Sign In is failed", Icons.cancel_outlined);
              }
            } else {
              Variables.showtoast(context, "Sign In is failed", Icons.cancel_outlined);
            }
          } else if (tabController.index == 1) {
            if (SignUp.formkey2.currentState!.validate() && SignUp.check) {
              if (authController.userType == "Customer") {
                Variables.deviceInfo["userType"] = "CUSTOMER";
              } else {
                Variables.deviceInfo["userType"] = "DRIVER";
              }
              await writeDetails();
              Map? response = await authController.registerUser(
                  context, Register.from2Maps(Variables.deviceInfo, TextFields.data).toJson());
              if (authController.userType == "Customer" && response != null) {
                if (await showdialog(
                    context, TextFields.data["Phone number"]!, TextFields.data["Email id"]!, response["id"])) {
                  animController2.reverse();
                  tabController.index = 0;
                }
              } else if (response != null) {
                animController2.reverse();
                tabController.index = 0;
              }
            } else if (!SignUp.check) {
              Variables.showtoast(context, "Accept Terms & Conditions", Icons.warning_rounded);
            } else {
              Variables.showtoast(context, "Something went wrong. Please Try Again", Icons.warning_rounded);
            }
          }
        } else {
          Variables.overlayNotification();
        }
      },
      child: const Icon(Icons.keyboard_arrow_right_rounded));

  writeDetails() async {
    await Variables.write(key: "username", value: TextFields.data["Email id"].toString());
    await Variables.write(key: "password", value: TextFields.data["Password"].toString());
    await Variables.write(key: "usertype", value: authController.userType);
    await Variables.write(key: "FirstTime", value: "true");
    await Variables.write(key: "mobileSignUp", value: true.toString());
    if (authController.userType == "driver") {
      await Variables.write(key: "enterKYC", value: true.toString());
    } else {
      await Variables.write(key: "enterKYC", value: false.toString());
    }
  }

  readDetails() async {
    try {
      bool username = (await Variables.read(key: "username")) == TextFields.data["Email id"];
      bool password = (await Variables.read(key: "password")) == TextFields.data["Password"];
      final kyc = await Variables.read(key: "enterKYC");
      enterKYC = kyc == null ? false : kyc.toLowerCase() == "true";

      if (username && password) {
        userType = await Variables.read(key: "usertype") ?? "";
      } else {
        await authController.authenticateUser(
            context, {"password": TextFields.data["Password"], "username": TextFields.data["Email id"]});
        if (Variables.driverId == -1 && authController.userType == "") return null;
        writeDetails();
        userType = authController.userType;
      }
    } catch (e) {
      Variables.showtoast(context, "Sign In is not successfull", Icons.cancel_outlined);
    }
  }

  show(context, [bool text = false]) => showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => SimpleDialog(
              titleTextStyle: Variables.font(fontSize: 22),
              title: const Text("Choose Your Profession"),
              contentPadding: const EdgeInsets.all(20),
              children: [
                Text(
                  (text ? "C" : "Before you fill the details, c") + "hoose the type of user you like to be",
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
              ]));

  showdialog(BuildContext context, String phonenumber, String email, int id) async {
    var code;
    resendOTP(id, email, phonenumber);
    return await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
              contentPadding: const EdgeInsets.all(17),
              alignment: MediaQuery.of(context).viewInsets.bottom > 0 ? Alignment.topCenter : Alignment.center,
              children: [
                SvgPicture.asset("assets/images/otp & two-factor.svg"),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text("OTP Verification",
                      textAlign: TextAlign.center, style: Variables.font(fontSize: 20, fontWeight: FontWeight.w400)),
                ),
                Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("We have send verification code to \n +91 ${TextFields.data["Phone number"]}",
                        textAlign: TextAlign.center,
                        style: Variables.font(fontWeight: FontWeight.w300, fontSize: 16, color: Colors.grey[600]))),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Align(
                        alignment: Alignment.center,
                        child: TextField(
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            style: Variables.font(fontSize: 19, fontWeight: FontWeight.bold),
                            onChanged: (value) {
                              code = value;
                            },
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 5),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)))))),
                Column(children: [
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
                              resendOTP(id, email, phonenumber);
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
                      })
                ]),
                ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)))),
                    onPressed: () async {
                      var validate =
                          await customerController.verifyOTP(context, {"otp": code, "phoneNumber": phonenumber});
                      if (validate != null) {
                        if (validate["otpVerified"]) {
                          Variables.showtoast(context, "Your Phone number is verified", Icons.check);
                          Variables.pop(context, value: true);
                        } else {
                          Variables.showtoast(context, "OTP is incorrect. Please try again", Icons.warning_rounded);
                          Variables.pop(context, value: false);
                        }
                      }
                    },
                    child: Text("Verify", style: Variables.font()))
              ]);
        });
  }

  void resendOTP(id, email, phonenumber) {
    customerController.challengeOTP(
        context, jsonEncode({"authType": "SMS", "customerId": id, "email": email, "phone": phonenumber}));
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
