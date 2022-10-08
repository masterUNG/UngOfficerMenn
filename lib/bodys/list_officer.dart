import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ungofficer/models/user_model.dart';
import 'package:ungofficer/utility/my_constant.dart';
import 'package:ungofficer/widgets/widget_progress.dart';
import 'package:ungofficer/widgets/widget_text.dart';

class ListOfficer extends StatefulWidget {
  const ListOfficer({super.key});

  @override
  State<ListOfficer> createState() => _ListOfficerState();
}

class _ListOfficerState extends State<ListOfficer> {
  bool load = true;
  var userModels = <UserModel>[];

  @override
  void initState() {
    super.initState();
    readMyOfficer();
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? const WidgetProgress()
        : ListView.builder(
            itemCount: userModels.length,
            itemBuilder: (context, index) {
              return Card(
                color: index % 2 == 1 ? Colors.white : Colors.grey.shade200,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WidgetText(
                        text: userModels[index].name,
                        textStyle: MyConstant().h2Style(size: 18),
                      ),
                      Row(
                        children: [
                          WidgetText(
                            text: 'Position : ',
                            textStyle: MyConstant().h3ActiveStyle(),
                          ),
                          WidgetText(text: userModels[index].user)
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
  }

  Future<void> readMyOfficer() async {
    String urlAPI =
        'https://www.androidthai.in.th/fluttertraining/getUserWhereOfficerUng.php?isAdd=true';
    await Dio().get(urlAPI).then((value) {
      for (var element in json.decode(value.data)) {
        UserModel userModel = UserModel.fromMap(element);
        userModels.add(userModel);
      }

      load = false;
      setState(() {});
    });
  }
}
