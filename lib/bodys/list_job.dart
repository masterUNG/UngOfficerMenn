import 'package:flutter/material.dart';
import 'package:ungofficer/states/add_job.dart';
import 'package:ungofficer/widgets/widget_button.dart';

class ListJob extends StatelessWidget {
  const ListJob({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
      return Stack(
        children: [
          Positioned(
            bottom: 16,
            right: 16,
            child: WidgetButton(
              label: 'Add Job',
              pressFunc: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const AddJob();
                  },
                )).then((value) {});
              },
            ),
          ),
        ],
      );
    });
  }
}
