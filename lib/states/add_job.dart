import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ungofficer/utility/my_constant.dart';
import 'package:ungofficer/utility/my_service.dart';
import 'package:ungofficer/widgets/widget_form.dart';
import 'package:ungofficer/widgets/widget_progress.dart';
import 'package:ungofficer/widgets/widget_text.dart';

class AddJob extends StatefulWidget {
  const AddJob({super.key});

  @override
  State<AddJob> createState() => _AddJobState();
}

class _AddJobState extends State<AddJob> {
  Position? position;
  bool load = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, (() {
      findPosition(context: context);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: WidgetText(
          text: 'Add Job',
          textStyle: MyConstant().h2Style(),
        ),
      ),
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return ListView(
          children: [
            makeCenter(boxConstraints,
                widget: WidgetForm(
                  hint: 'Name Job',
                  iconData: Icons.work,
                  changeFunc: (p0) {},
                )),
            makeCenter(boxConstraints,
                widget: WidgetForm(
                  hint: 'Detail Job',
                  iconData: Icons.details,
                  changeFunc: (p0) {},
                )),
            makeCenter(
              boxConstraints,
              widget: Container(
                height: boxConstraints.maxHeight * 0.6,
                decoration: MyConstant().curveBox(),
                child:  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: load ? const WidgetProgress() : WidgetText(text: 'Position = ${position.toString()}') ,
                ),
              ),
              width: boxConstraints.maxWidth * 0.8,
            ),
          ],
        );
      }),
    );
  }

  Row makeCenter(BoxConstraints boxConstraints,
      {required Widget widget, double? width}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          width: width ?? boxConstraints.maxWidth * 0.6,
          child: widget,
        ),
      ],
    );
  }

  Future<void> findPosition({required BuildContext context}) async {
    await MyService().processFindPosition(context: context).then((value) {
      position = value;
      print('position on addJob ==> $position');
      load = false;
      setState(() {});
    });
  }
}
