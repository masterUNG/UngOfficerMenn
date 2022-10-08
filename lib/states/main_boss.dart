// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:ungofficer/bodys/list_job.dart';
import 'package:ungofficer/bodys/list_officer.dart';
import 'package:ungofficer/bodys/news.dart';
import 'package:ungofficer/utility/my_constant.dart';
import 'package:ungofficer/utility/my_service.dart';
import 'package:ungofficer/widgets/widget_drawer_header.dart';
import 'package:ungofficer/widgets/widget_image.dart';
import 'package:ungofficer/widgets/widget_listtile.dart';
import 'package:ungofficer/widgets/widget_progress.dart';
import 'package:ungofficer/widgets/widget_sign_out.dart';
import 'package:ungofficer/widgets/widget_text.dart';

class MainBoss extends StatefulWidget {
  const MainBoss({super.key});

  @override
  State<MainBoss> createState() => _MainBossState();
}

class _MainBossState extends State<MainBoss> {
  var bodys = <Widget>[];
  var titles = <String>[
    'List Job',
    'List Officer',
    'News',
  ];
  int indexBody = 0;

  var datas = <String>[];

  @override
  void initState() {
    super.initState();

    findUserLogin();
  }

  Future<void> findUserLogin() async {
    datas = await MyService().findDatas();

    bodys.add(const ListJob());
    bodys.add(const ListOfficer());
    bodys.add(News(nameLogin: datas[2]));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: WidgetText(
          text: titles[indexBody],
          textStyle: MyConstant().h2Style(),
        ),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            const WidgetSingOut(),
            Column(
              children: [
                WidgetDrawerHeader(
                  datas: datas,
                  type: 'Boss',
                ),
                WidgetListtile(
                    tapFunc: () {
                      indexBody = 0;
                      Navigator.pop(context);
                      setState(() {});
                    },
                    leadWidget: const WidgetImage(
                      path: 'images/list.png',
                    ),
                    title: titles[0],
                    subTitle: 'List Job In my Response'),
                Divider(
                  color: MyConstant.dark,
                ),
                WidgetListtile(
                    tapFunc: () {
                      indexBody = 1;
                      Navigator.pop(context);
                      setState(() {});
                    },
                    leadWidget: const WidgetImage(
                      path: 'images/logo.png',
                    ),
                    title: titles[1],
                    subTitle: 'List officer of Company'),
                Divider(
                  color: MyConstant.dark,
                ),

                 WidgetListtile(
                    tapFunc: () {
                      indexBody = 2;
                      Navigator.pop(context);
                      setState(() {});
                    },
                    leadWidget: const WidgetImage(
                      path: 'images/news.png',
                    ),
                    title: titles[2],
                    subTitle: 'News of Company'),
                Divider(
                  color: MyConstant.dark,
                ),
                
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
          child: bodys.isEmpty ? const WidgetProgress() : bodys[indexBody]),
    );
  }
}
