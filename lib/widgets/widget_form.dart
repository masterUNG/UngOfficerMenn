// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:ungofficer/utility/my_constant.dart';

class WidgetForm extends StatelessWidget {
  final String hint;
  final IconData iconData;
  const WidgetForm({
    Key? key,
    required this.hint,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextFormField(
        style: MyConstant().h3Style(),
        decoration: InputDecoration(
          suffixIcon: Icon(iconData),
          fillColor: Colors.white,
          filled: true,
          hintText: hint,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.dark),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: MyConstant.active),
              borderRadius: BorderRadius.all(Radius.circular(15))),
        ),
      ),
    );
  }
}
