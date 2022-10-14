import 'package:flutter/material.dart';
import 'package:ungofficer/bodys/list_finish.dart';
import 'package:ungofficer/bodys/list_work.dart';
import 'package:ungofficer/utility/my_constant.dart';
import 'package:ungofficer/widgets/widget_text.dart';

class MyJob extends StatefulWidget {
  const MyJob({super.key});

  @override
  State<MyJob> createState() => _MyJobState();
}

class _MyJobState extends State<MyJob> {
  var bottomNavigationBarItems = <BottomNavigationBarItem>[];
  var titles = <String>[
    'Work',
    'Finish',
  ];
  var iconDatas = <IconData>[
    Icons.business_center_outlined,
    Icons.library_add_check_outlined,
  ];

  var bodys = <Widget>[
    const ListWork(),
    const ListFinish(),
  ];

  int indexbody = 0;

  @override
  void initState() {
    super.initState();
    setupNavigationBar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: bodys[indexbody],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexbody,
        selectedItemColor: MyConstant.active,
        unselectedItemColor: Colors.grey.shade500,
        items: bottomNavigationBarItems,
        onTap: (value) {
          indexbody = value;
          setState(() {});
        },
      ),
    );
  }

  void setupNavigationBar() {
    for (var i = 0; i < titles.length; i++) {
      bottomNavigationBarItems.add(
        BottomNavigationBarItem(
          label: titles[i],
          icon: Icon(
            iconDatas[i],
          ),
        ),
      );
    }
  }
}
