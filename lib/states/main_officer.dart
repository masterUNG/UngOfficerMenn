import 'package:flutter/material.dart';
import 'package:ungofficer/widgets/widget_text.dart';

class MainOfficer extends StatelessWidget {
  const MainOfficer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,
        title: WidgetText(text: 'Officer'),
      ),
    );
  }
}
