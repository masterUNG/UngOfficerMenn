import 'package:flutter/material.dart';

class MyConstant {
  //Field

  static String routeAuthen = '/authen';
  static String routeOfficer = '/officer';
  static String routeBoss = '/boss';

  static String appName = 'Ung Officer';
  static Color dark = const Color.fromARGB(255, 3, 26, 68);
  static Color primary = const Color.fromARGB(255, 16, 101, 158);
  static Color active = const Color.fromARGB(255, 196, 6, 69);

  //Method

  BoxDecoration imageBox() {
    return const BoxDecoration(
      image: DecorationImage(
          image: AssetImage('images/bg.jpg'), fit: BoxFit.cover),
    );
  }

  BoxDecoration colorBox() {
    return BoxDecoration(color: primary.withOpacity(0.25));
  }

  BoxDecoration gradientBox() {
    return BoxDecoration(
      gradient: RadialGradient(
        radius: 1.5,
        center: Alignment.topLeft,
        colors: [Colors.white, primary],
      ),
    );
  }

  BoxDecoration whiteBox() {
    return BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(100),
          topRight: Radius.circular(100),
        ));
  }

  TextStyle h1Style({Color? color}) {
    return TextStyle(
      fontSize: 36,
      color: color ?? dark,
      fontWeight: FontWeight.bold,
      fontFamily: 'Mali',
    );
  }

  TextStyle h2Style({double? size}) {
    return TextStyle(
      fontSize: size ?? 24,
      color: dark,
      fontWeight: FontWeight.w700,
      fontFamily: 'Mali',
    );
  }

  TextStyle h3Style() {
    return TextStyle(
      fontSize: 15,
      color: dark,
      fontWeight: FontWeight.normal,
      fontFamily: 'Mali',
    );
  }

  TextStyle h3ActiveStyle() {
    return TextStyle(
      fontSize: 16,
      color: active,
      fontWeight: FontWeight.w500,
      fontFamily: 'Mali',
    );
  }

  TextStyle h3ButtonStyle() {
    return const TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontFamily: 'Mali',
    );
  }
}
