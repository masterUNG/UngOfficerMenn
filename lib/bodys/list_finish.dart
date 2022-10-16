import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ungofficer/models/job_model.dart';
import 'package:ungofficer/models/user_model.dart';
import 'package:ungofficer/utility/my_constant.dart';
import 'package:ungofficer/utility/my_service.dart';
import 'package:ungofficer/widgets/widget_progress.dart';
import 'package:ungofficer/widgets/widget_text.dart';

class ListFinish extends StatefulWidget {
  const ListFinish({super.key});

  @override
  State<ListFinish> createState() => _ListFinishState();
}

class _ListFinishState extends State<ListFinish> {
  var jobModels = <JobModel>[];
  bool load = true;
  bool? haveFinish;

  @override
  void initState() {
    super.initState();
    readJobFinish();
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? const WidgetProgress()
        : haveFinish!
            ? ListView.builder(itemCount: jobModels.length,
                itemBuilder: (context, index) => WidgetText(
                  text: jobModels[index].job,
                  textStyle: MyConstant().h2Style(),
                ),
              )
            : Center(
                child: WidgetText(
                  text: 'No Finish',
                  textStyle: MyConstant().h1Style(),
                ),
              );
  }

  Future<void> readJobFinish() async {
    var datas = await MyService().findDatas();

    String apiGetUserWhereUser =
        'https://www.androidthai.in.th/fluttertraining/getUserWhereUserUng.php?isAdd=true&user=${datas[3]}';
    await Dio().get(apiGetUserWhereUser).then((value) async {
      for (var element in json.decode(value.data)) {
        UserModel userModel = UserModel.fromMap(element);

        if (userModel.finish!.isEmpty) {
          haveFinish = false;
        } else {
          haveFinish = true;

          var finishs =
              MyService().changeStringToList(string: userModel.finish!);

          for (var element in finishs) {
            String apiGetJobWhereIdJob =
                'https://www.androidthai.in.th/fluttertraining/getJobWhereIdUng.php?isAdd=true&id=$element';
            await Dio().get(apiGetJobWhereIdJob).then((value) {
              for (var element in json.decode(value.data)) {
                JobModel jobModel = JobModel.fromMap(element);
                jobModels.add(jobModel);
              }
            });
          }
        }
      }

      load = false;
      setState(() {});
    });
  }
}
