// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ungofficer/utility/my_constant.dart';

class WidgetIconButton extends StatelessWidget {
  final IconData iconData;
  final Function() pressFunc;
  final Color? color;
  const WidgetIconButton({
    Key? key,
    required this.iconData,
    required this.pressFunc,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: pressFunc,
      icon: Icon(
        iconData,
        color: color ?? MyConstant.active,
      ),
    );
  }
}
