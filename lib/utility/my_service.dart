// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungofficer/models/job_model.dart';
import 'package:ungofficer/utility/my_dialog.dart';
import 'package:ungofficer/widgets/windget_text_button.dart';

class MyService {
  Future<void> processSendNoti(
      {required String title,
      required String body,
      required String token}) async {
    String apiNoti = 'https://www.androidthai.in.th/fluttertraining/apiNotiUng.php?isAdd=true&token=$token&title=$title&body=$body';
    await Dio().get(apiNoti).then((value) => print('Send Noti Success'));
  }

  Future<void> processNotification(
      {required BuildContext context, required String idUser}) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    print('token ===> $token');

    String apiUpdateToken =
        'https://www.androidthai.in.th/fluttertraining/editUserWhereIdTokenUng.php?isAdd=true&id=$idUser&token=$token';
    await Dio()
        .get(apiUpdateToken)
        .then((value) => print('Update Token Success'));

    //Open App
    FirebaseMessaging.onMessage.listen((event) {
      String? title = event.notification!.title;
      String? body = event.notification!.body;
      MyDialog(context: context).normalDialog(title: title!, subTitle: body!);
    });

    //Close App
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      String? title = event.notification!.title;
      String? body = event.notification!.body;
      MyDialog(context: context).normalDialog(title: title!, subTitle: body!);
    });
  }

  List<String> changeStringToList({required String string}) {
    var strings = <String>[];

    print('start strings ==> $strings');

    String result = string.substring(1, string.length - 1);

    print('result ==> $result');

    strings = result.split(',');

    for (var i = 0; i < strings.length; i++) {
      strings[i] = strings[i].trim();
    }

    print('strings return ==> $strings');

    return strings;
  }

  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double distance = 0;

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    distance = 12742 * asin(sqrt(a)) * 1000;

    return distance;
  }

  String? changeDateFormat({required String dateStr}) {
    String? result;

    var strings = dateStr.split(' ');
    var string2s = strings[0].trim().split('-');
    result = '${string2s[2]}/${string2s[1]}/${string2s[0]}';

    return result;
  }

  Future<JobModel?> findJobWherId({required String idJob}) async {
    JobModel? jobModel;
    String path =
        'https://www.androidthai.in.th/fluttertraining/getJobWhereIdUng.php?isAdd=true&id=$idJob';

    var result = await Dio().get(path);
    for (var element in json.decode(result.data)) {
      jobModel = JobModel.fromMap(element);
    }

    return jobModel;
  }

  Future<Position?> processFindPosition({required BuildContext context}) async {
    bool locationServiceEnable = await Geolocator.isLocationServiceEnabled();
    LocationPermission locationPermission = await Geolocator.checkPermission();
    Position? position;

    if (locationServiceEnable) {
      print('Open Location Service');

      if (locationPermission == LocationPermission.deniedForever) {
        locationDialog(
          context,
          title: 'Denied Forver ?',
          subTitle: 'Please Alway Permision',
          actionFunc: () {
            Geolocator.openAppSettings();
            exit(0);
          },
        );
      } else {
        if (locationPermission == LocationPermission.denied) {
          // denied
          locationPermission = await Geolocator.requestPermission();

          if ((locationPermission != LocationPermission.always) &&
              (locationPermission != LocationPermission.whileInUse)) {
            //denineForver
            locationDialog(
              context,
              title: 'Denied Forver ?',
              subTitle: 'Please Alway Permision',
              actionFunc: () {
                Geolocator.openAppSettings();
                exit(0);
              },
            );
          } else {
            // Alway, WhileInUse
            position = await Geolocator.getCurrentPosition();
          }
        } else {
          // Alway, WhileInUse
          position = await Geolocator.getCurrentPosition();
        }
      }
    } else {
      print('Off Location Service');
      locationDialog(context, actionFunc: () {
        Geolocator.openLocationSettings();
        exit(0);
      },
          title: 'Location Service Off ?',
          subTitle: 'Please Open Location Service');
    }
    return position;
  }

  void locationDialog(BuildContext context,
      {required String title,
      required String subTitle,
      required Function() actionFunc}) {
    MyDialog(context: context).normalDialog(
        title: title,
        subTitle: subTitle,
        textButtonWidget: WidgetTextButton(
          label: 'Open Service & Exit',
          pressFunc: actionFunc,
        ));
  }

  Future<List<String>> findDatas() async {
    var results = <String>[];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    results = preferences.getStringList('data')!;
    return results;
  }
}
