// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:ungofficer/utility/my_constant.dart';
import 'package:ungofficer/widgets/widget_text.dart';

class WidgetListtile extends StatelessWidget {
  final Widget leadWidget;
  final String title;
  final String subTitle;
  const WidgetListtile({
    Key? key,
    required this.leadWidget,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leadWidget,
      title: WidgetText(
        text: title,
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: WidgetText(text: subTitle),
    );
  }
}
