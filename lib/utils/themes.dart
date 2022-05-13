import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData lighttheme(BuildContext context) => ThemeData(
      primarySwatch: Palette.kOrange,
      scaffoldBackgroundColor: Colors.grey[200],
      switchTheme: SwitchThemeData(thumbColor: MaterialStateProperty.all<Color>(Palette.kOrange)),
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, elevation: 2, iconTheme: IconThemeData(color: Palette.deepgrey)),
      bottomAppBarColor: Colors.white,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 20,
          backgroundColor: Palette.deepgrey,
          splashColor: Palette.kOrange,
          focusColor: Palette.kOrange,
          hoverColor: Palette.kOrange,
          hoverElevation: 100,
          highlightElevation: 5),
      tabBarTheme: TabBarTheme(
          labelPadding: const EdgeInsets.all(8),
          unselectedLabelColor: Palette.deepgrey,
          labelColor: Palette.kOrange,
          labelStyle: Variables.font(fontSize: 17),
          unselectedLabelStyle: Variables.font(fontSize: 15)),
      indicatorColor: Palette.kOrange[50]);
}

class Palette {
  static const Color deepgrey = Color(0xff282828);
  static const MaterialColor kOrange = MaterialColor(
    0xffff6801, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xffe65e01), //10%
      100: Color(0xffcc5301), //20%
      200: Color(0xffb34901), //30%
      300: Color(0xff993e01), //40%
      400: Color(0xff803401), //50%
      500: Color(0xff662a00), //60%
      600: Color(0xff4c1f00), //70%
      700: Color(0xff331500), //80%
      800: Color(0xff190a00), //90%
      900: Color(0xff000000), //100%
    },
  );
}
