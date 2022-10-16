import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart';
import 'package:ungofficer/bodys/my_job.dart';
import 'package:ungofficer/utility/my_constant.dart';
import 'package:ungofficer/utility/my_dialog.dart';
import 'package:ungofficer/utility/my_service.dart';
import 'package:ungofficer/widgets/widget_drawer_header.dart';
import 'package:ungofficer/widgets/widget_icon_button.dart';
import 'package:ungofficer/widgets/widget_listtile.dart';
import 'package:ungofficer/widgets/widget_sign_out.dart';
import 'package:ungofficer/widgets/widget_text.dart';

class MainOfficer extends StatefulWidget {
  const MainOfficer({super.key});

  @override
  State<MainOfficer> createState() => _MainOfficerState();
}

class _MainOfficerState extends State<MainOfficer> {
  var datas = <String>[];
  int indexBody = 0;
  var bodys = <Widget>[];
  var titleAppBars = <String>['My Job'];

  @override
  void initState() {
    super.initState();
    findDatas();
    bodys.add(const MyJob());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          WidgetIconButton(
            iconData: Icons.qr_code,
            pressFunc: () async {
              var result = await scan();
              MyDialog(context: context)
                  .normalDialog(title: 'QRcode', subTitle: result.toString());
            },
          )
        ],
        centerTitle: true,
        title: WidgetText(
          text: titleAppBars[indexBody],
          textStyle: MyConstant().h2Style(),
        ),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            const WidgetSingOut(),
            datas.isEmpty
                ? const SizedBox()
                : Column(
                    children: [
                      WidgetDrawerHeader(datas: datas, type: 'Officer'),
                      WidgetListtile(
                        leadWidget: Icon(
                          Icons.home_outlined,
                          size: 36,
                          color: Colors.green.shade700,
                        ),
                        title: 'My Job',
                        subTitle: 'Work Job and Finish Job',
                        tapFunc: () {
                          indexBody = 0;
                          setState(() {});
                          Navigator.pop(context);
                        },
                      ),
                      Divider(
                        color: MyConstant.dark,
                      ),
                    ],
                  ),
          ],
        ),
      ),
      body: bodys[indexBody],
    );
  }

  Future<void> findDatas() async {
    await MyService().findDatas().then((value) {
      datas = value;
      aboutNoti();
      setState(() {});
    });
  }

  Future<void> aboutNoti() async {
    await MyService().processNotification(context: context, idUser: datas[0]);
  }
}
