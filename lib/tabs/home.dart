import 'package:flutter/material.dart';
import '../pages/book_orderpage.dart';
import '../utils/routes.dart';
import '../utils/themes.dart';
import '../utils/variables.dart';
import '../widgets/customer_drawer.dart';


class HomeTab extends StatelessWidget {
  const HomeTab({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const CustomerDrawer(),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Palette.kOrange,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                            title: Text("Alert!", style: Variables.font(fontSize: 20)),
                            content: Text("Are you sure,you want to sign out?", style: Variables.font(fontSize: 16)),
                            actionsAlignment: MainAxisAlignment.spaceEvenly,
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("NO", style: Variables.font(fontSize: 16, color: Colors.white)),
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).popAndPushNamed(MyRoutes.loginpage);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "YES",
                                      style: Variables.font(fontSize: 16, color: Colors.white),
                                    ),
                                  ))
                            ])),
                icon: const Icon(
                  Icons.power_settings_new_rounded,
                ))
          ],
        ),
        body: SizedBox(
          height: size.height - 80,
          child: Stack(
            children: [
              Container(
                color: Palette.kOrange,
                height: size.height * 0.4,
                width: size.width,
                child: Stack(
                  children: [
                    Positioned(
                        top: size.height * 0.1,
                        left: (size.width - 200) * 0.5,
                        child: Image.asset(
                          "assets/images/Logo-Light.png",
                          height: 60,
                        )),
                    Positioned(
                        top: size.height * 0.2,
                        left: (size.width - 207) * 0.5,
                        child: Text(
                          "A Fastest Delivery App",
                          style: Variables.font(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500),
                        )),
                  ],
                ),
              ),
              Positioned(
                top: size.height * 0.3,
                left: (size.width - 280) * 0.5,
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/package_fly.png",
                        width: 200,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: SizedBox(
                          width: 130,
                          child: Text(
                            "Ship\n your package",
                            style: Variables.font(fontSize: 19, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          elevation: 5,
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const BookOrderPage(),
          )),
          child: const Icon(Icons.keyboard_arrow_right_rounded),
        ));
  }
}
