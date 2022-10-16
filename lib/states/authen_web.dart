import 'package:flutter/material.dart';
import 'package:ungofficer/utility/my_constant.dart';
import 'package:ungofficer/widgets/widget_text.dart';

class AuthenWeb extends StatelessWidget {
  const AuthenWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: WidgetText(
          text: 'This is Website',
          textStyle: MyConstant().h2Style(),
        ),
      ),
    );
  }
}
