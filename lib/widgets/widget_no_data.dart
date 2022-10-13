import 'package:flutter/material.dart';
import 'package:ungofficer/utility/my_constant.dart';
import 'package:ungofficer/widgets/widget_text.dart';

class WidgetNoData extends StatelessWidget {
  const WidgetNoData({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: WidgetText(
        text: 'No Job',
        textStyle: MyConstant().h1Style(),
      ),
    );
  }
}
