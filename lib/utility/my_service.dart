// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungofficer/models/job_model.dart';
import 'package:ungofficer/utility/my_dialog.dart';
import 'package:ungofficer/widgets/windget_text_button.dart';

class MyService {

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
