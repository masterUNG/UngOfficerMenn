import 'package:flutter/material.dart';
import 'package:ungofficer/utility/my_constant.dart';
import 'package:ungofficer/widgets/widget_button.dart';
import 'package:ungofficer/widgets/widget_form.dart';
import 'package:ungofficer/widgets/widget_image.dart';
import 'package:ungofficer/widgets/widget_text.dart';

class Authen extends StatelessWidget {
  const Authen({super.key});

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
                                    const WidgetForm(
                                      hint: 'User :',
                                      iconData: Icons.person_outline,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    const WidgetForm(
                                      hint: 'Password :',
                                      iconData: Icons.lock_outline,
                                    ),
                                    const SizedBox(height: 8,),
                                    SizedBox(width: 250,
                                      child: WidgetButton(
                                        label: 'Login',
                                        pressFunc: () {},
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
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
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
