// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:ungofficer/models/job_model.dart';
import 'package:ungofficer/models/user_model.dart';
import 'package:ungofficer/utility/my_constant.dart';
import 'package:ungofficer/utility/my_dialog.dart';
import 'package:ungofficer/utility/my_service.dart';
import 'package:ungofficer/widgets/widget_button.dart';
import 'package:ungofficer/widgets/widget_progress.dart';
import 'package:ungofficer/widgets/widget_text.dart';

class AssignJob extends StatefulWidget {
  final JobModel jobModel;
  const AssignJob({
    Key? key,
    required this.jobModel,
  }) : super(key: key);

  @override
  State<AssignJob> createState() => _AssignJobState();
}

class _AssignJobState extends State<AssignJob> {
  JobModel? jobModel;
  var userModels = <UserModel>[];
  UserModel? assignUserModel;

  @override
  void initState() {
    super.initState();
    jobModel = widget.jobModel;
    readOfficerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: newAppBar(),
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return ListView(
          children: [
            newHead(
                boxConstraints: boxConstraints,
                head: 'Date Create : ',
                value: jobModel!.dateCreate),
            newHead(
                boxConstraints: boxConstraints,
                head: 'Detail :',
                value: jobModel!.detail),
            newMap(boxConstraints),
            titleAssingJob(),
            drowDownType(boxConstraints),
            buttonSaveAssign(boxConstraints),
          ],
        );
      }),
    );
  }

  Row buttonSaveAssign(BoxConstraints boxConstraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: boxConstraints.maxWidth * 0.8,
          margin: const EdgeInsets.symmetric(vertical: 16),
          child: WidgetButton(
            label: 'Save Assign',
            pressFunc: () {
              if (assignUserModel == null) {
                MyDialog(context: context).normalDialog(
                    title: 'No Assign Officer',
                    subTitle: 'Please Choose Assign Officer by tap Dropdown');
              } else {
                processEditJob();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget drowDownType(BoxConstraints boxConstraints) {
    return userModels.isEmpty
        ? const WidgetProgress()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 16),
                decoration: MyConstant().curveBox(),
                width: boxConstraints.maxWidth * 0.8,
                child: DropdownButton(
                  focusColor: Colors.white,
                  underline: const SizedBox(),
                  isExpanded: true,
                  items: userModels
                      .map(
                        (e) => DropdownMenuItem(
                          // ignore: sort_child_properties_last
                          child: Row(
                            children: [
                              WidgetText(text: e.name),
                              WidgetText(
                                text: ' (id = ${e.id})',
                                textStyle: MyConstant().h3ActiveStyle(),
                              )
                            ],
                          ),
                          value: e,
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    assignUserModel = value;
                    setState(() {});
                  },
                  value: assignUserModel,
                  hint: WidgetText(
                    text: 'โปรดเลือก Officer',
                    textStyle: MyConstant().h3ActiveStyle(),
                  ),
                ),
              ),
            ],
          );
  }

  AppBar newAppBar() {
    return AppBar(
      centerTitle: true,
      title: WidgetText(
        text: jobModel!.job,
        textStyle: MyConstant().h2Style(),
      ),
    );
  }

  Container titleAssingJob() {
    return Container(
      margin: const EdgeInsets.only(left: 16, bottom: 32),
      child: WidgetText(
        text: 'Assing Job :',
        textStyle: MyConstant().h2Style(size: 18),
      ),
    );
  }

  Row newMap(BoxConstraints boxConstraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: MyConstant().curveBox(),
          margin: const EdgeInsets.symmetric(vertical: 32),
          width: boxConstraints.maxWidth * 0.8,
          height: boxConstraints.maxHeight * 0.4,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
                target: LatLng(
                  double.parse(jobModel!.lat),
                  double.parse(jobModel!.lng),
                ),
                zoom: 16),
            onMapCreated: (controller) {},
            // ignore: prefer_collection_literals
            markers: <Marker>[
              Marker(
                markerId: const MarkerId('id'),
                position: LatLng(
                  double.parse(jobModel!.lat),
                  double.parse(jobModel!.lng),
                ),
              ),
            ].toSet(),
          ),
        ),
      ],
    );
  }

  Row newHead(
      {required BoxConstraints boxConstraints,
      required String head,
      required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 8),
          width: boxConstraints.maxWidth * 0.25,
          child: WidgetText(
            text: head,
            textStyle: MyConstant().h2Style(size: 16),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          width: boxConstraints.maxWidth * 0.75,
          child: WidgetText(text: value),
        ),
      ],
    );
  }

  Future<void> readOfficerData() async {
    String path =
        'https://www.androidthai.in.th/fluttertraining/getUserWhereTypeUng.php?isAdd=true&type=officer';
    await Dio().get(path).then((value) {
      for (var element in json.decode(value.data)) {
        UserModel userModel = UserModel.fromMap(element);
        if (userModel.idJob!.isEmpty) {
          userModels.add(userModel);
        }
      }
      setState(() {});
    });
  }

  Future<void> processEditJob() async {
    String path =
        'https://www.androidthai.in.th/fluttertraining/editJobWhereIdUng.php?isAdd=true&id=${jobModel!.id}&idOfficer=${assignUserModel!.id}';
    await Dio().get(path).then((value) async {
      String pathEditUser =
          'https://www.androidthai.in.th/fluttertraining/editUserWhereIdUng.php?isAdd=true&id=${assignUserModel!.id}&idJob=${jobModel!.id}';
      await Dio().get(pathEditUser).then((value) async {
        // Wait noti

        await MyService()
            .processSendNoti(
                title: 'Require Job',
                body: jobModel!.detail,
                token: assignUserModel!.token!)
            .then((value) {
           Navigator.pop(context);
        });

       
      });
    });
  }
}
