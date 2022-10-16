import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungofficer/states/authen.dart';
import 'package:ungofficer/states/authen_web.dart';
import 'package:ungofficer/states/main_boss.dart';
import 'package:ungofficer/states/main_officer.dart';
import 'package:ungofficer/utility/my_constant.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Map<String, WidgetBuilder> map = {
  MyConstant.routeAuthen: (context) => const Authen(),
  MyConstant.routeBoss: (context) => const MainBoss(),
  MyConstant.routeOfficer: (context) => const MainOfficer(),
  MyConstant.routeWeb: (context) => const AuthenWeb(),
};

String? firstState;

Future<void> main() async {
  HttpOverrides.global = MyHttpOverride();

  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    //Web Status
    firstState = MyConstant.routeWeb;
    runApp(const MyApp());
  } else {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var result = preferences.getStringList('data');
    print('result main = $result');

    if (result != null) {
      var datas = <String>[];
      // datas = result;
      datas.addAll(result);

      switch (datas[1]) {
        case 'boss':
          firstState = MyConstant.routeBoss;
          break;
        case 'officer':
          firstState = MyConstant.routeOfficer;
          break;
        default:
          firstState = MyConstant.routeAuthen;
          break;
      }
    }

    await Firebase.initializeApp().then((value) {
      runApp(const MyApp());
    });
  }
} // endMain

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: map,
      initialRoute: firstState ?? MyConstant.routeAuthen,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: MyConstant.dark,
          elevation: 0,
        ),
      ),
    );
  }
}

class MyHttpOverride extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
