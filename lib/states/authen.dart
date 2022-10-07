// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ungofficer/models/user_model.dart';
import 'package:ungofficer/utility/my_constant.dart';
import 'package:ungofficer/utility/my_dialog.dart';
import 'package:ungofficer/widgets/widget_button.dart';
import 'package:ungofficer/widgets/widget_form.dart';
import 'package:ungofficer/widgets/widget_icon_button.dart';
import 'package:ungofficer/widgets/widget_image.dart';
import 'package:ungofficer/widgets/widget_text.dart';

class Authen extends StatefulWidget {
  const Authen({super.key});

  @override
  State<Authen> createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  bool redEye = true;
  String? user, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return SafeArea(
          child: GestureDetector(
            onTap: () {
              return FocusScope.of(context).requestFocus(
                FocusScopeNode(),
              );
            },
            child: Stack(
              children: [
                Container(
                  height: boxConstraints.maxHeight,
                  width: boxConstraints.maxWidth,
                  decoration: MyConstant().imageBox(),
                  child: newHead(boxConstraints),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        left: 36,
                        top: 72,
                        right: 36,
                      ),
                      decoration: MyConstant().whiteBox(),
                      width: boxConstraints.maxWidth,
                      height: boxConstraints.maxHeight * 0.75,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WidgetText(
                              text: 'Login :',
                              textStyle: MyConstant().h2Style(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 16),
                                  width: 250,
                                  child: Column(
                                    children: [
                                      WidgetForm(
                                        changeFunc: (p0) {
                                          user = p0.trim();
                                        },
                                        hint: 'User :',
                                        iconData: Icons.person_outline,
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      WidgetForm(
                                        changeFunc: (p0) {
                                          password = p0.trim();
                                        },
                                        suffixWidget: WidgetIconButton(
                                          iconData: redEye
                                              ? Icons.remove_red_eye
                                              : Icons.remove_red_eye_outlined,
                                          pressFunc: () {
                                            redEye = !redEye;
                                            print('redEye = $redEye');
                                            setState(() {});
                                          },
                                        ),
                                        obsecu: redEye,
                                        hint: 'Password :',
                                        iconData: Icons.lock_outline,
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      SizedBox(
                                        width: 250,
                                        child: WidgetButton(
                                          label: 'Login',
                                          pressFunc: () {
                                            print(
                                                'user = $user, password = $password');

                                            if ((user?.isEmpty ?? true) ||
                                                (password?.isEmpty ?? true)) {
                                              print('have space');

                                              MyDialog(context: context)
                                                  .normalDialog(
                                                      title: 'Have Space ?',
                                                      subTitle:
                                                          'Please Fill Every Blank');
                                            } else {
                                              print('no space');
                                              processLogin();
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<void> processLogin() async {
    String urlAPI =
        'https://www.androidthai.in.th/fluttertraining/getUserWhereUserUng.php?isAdd=true&user=$user';

    await Dio().get(urlAPI).then((value) {
      print('value = $value');

      if (value.toString() == 'null') {
        MyDialog(context: context).normalDialog(
            title: 'User False ?', subTitle: 'No $user in Database');
      } else {
        //User True
        var result = json.decode(value.data);
        print('result = $result');

        for (var element in result) {
          print('element = $element');
          UserModel model = UserModel.fromMap(element);

          if (password == model.password) {
            // Password True
            String type = model.type;
            print('type = $type');

            switch (type) {
              case 'boss':
                Navigator.pushNamedAndRemoveUntil(
                    context, MyConstant.routeBoss, (route) => false);
                break;
              case 'officer':
                Navigator.pushNamedAndRemoveUntil(
                    context, MyConstant.routeOfficer, (route) => false);
                break;
              default:
                Navigator.pushNamedAndRemoveUntil(
                    context, MyConstant.routeAuthen, (route) => false);
                break;
            }
          } else {
            MyDialog(context: context).normalDialog(
                title: 'Password False ?',
                subTitle: 'Please Try Again Password False');
          }
        }
      }
    });
  }

  Container newHead(BoxConstraints boxConstraints) {
    return Container(
      margin: const EdgeInsets.only(
        left: 16,
        top: 48,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          newImage(boxConstraints),
          const SizedBox(
            width: 16,
          ),
          WidgetText(
            text: MyConstant.appName,
            textStyle: MyConstant().h1Style(color: Colors.white),
          ),
        ],
      ),
    );
  }

  SizedBox newImage(BoxConstraints boxConstraints) {
    return SizedBox(
      width: boxConstraints.maxWidth * 0.2,
      child: const WidgetImage(),
    );
  }
}
