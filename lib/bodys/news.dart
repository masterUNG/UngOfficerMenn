// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:ungofficer/widgets/widget_text.dart';

class News extends StatelessWidget {
  final String nameLogin;
  const News({
    Key? key,
    required this.nameLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetText(text: 'This is News for $nameLogin');
  }
}
