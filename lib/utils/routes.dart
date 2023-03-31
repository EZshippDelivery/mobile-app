import 'package:ezshipp/pages/loginpage.dart';
import 'package:flutter/material.dart';

class MyRoutes {

  static routelogin() {
    return PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secAnimation, child) {
          animation = Tween(begin: 0.0, end: 1.0).animate(animation);
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
            const LoginPage());
  }
}
