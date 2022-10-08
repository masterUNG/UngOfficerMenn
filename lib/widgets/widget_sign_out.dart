import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungofficer/utility/my_constant.dart';
import 'package:ungofficer/widgets/widget_listtile.dart';

class WidgetSingOut extends StatelessWidget {
  const WidgetSingOut({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [ Divider(color: MyConstant.dark,),
        WidgetListtile(
          leadWidget: Icon(
            Icons.exit_to_app,
            size: 36,
            color: Colors.red.shade700,
          ),
          title: 'Sign Out',
          subTitle: 'SignOut and Move to Authen',
          tapFunc: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
                preferences.clear().then((value) => Navigator.pushNamedAndRemoveUntil(context, MyConstant.routeAuthen, (route) => false));
          },
        ),
      ],
    );
  }
}
