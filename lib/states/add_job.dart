// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ungofficer/models/job_model.dart';
import 'package:ungofficer/utility/my_constant.dart';
import 'package:ungofficer/utility/my_dialog.dart';
import 'package:ungofficer/utility/my_service.dart';
import 'package:ungofficer/widgets/widget_button.dart';
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

  Map<MarkerId, Marker> markerMap = {};
  BitmapDescriptor? bitmapDescriptor;

  String? name, detail;
  LatLng? jobLatLng;

  @override
  void initState() {
    super.initState();

    createIconMarker();

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
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            print('You tap Screen');
            FocusScope.of(context).requestFocus(FocusScopeNode());
          },
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  formName(boxConstraints),
                  formDetail(boxConstraints),
                  mapJob(boxConstraints),
                  buttonSave(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  WidgetButton buttonSave() {
    return WidgetButton(
      label: 'Save Job',
      pressFunc: () {
        if ((name?.isEmpty ?? true) || (detail?.isEmpty ?? true)) {
          MyDialog(context: context).normalDialog(
              title: 'Have Space ?', subTitle: 'Please Fill Every Blank');
        } else if (jobLatLng == null) {
          MyDialog(context: context).normalDialog(
              title: 'No Position', subTitle: 'Please Tap on Map');
        } else {
          processInsertJob();
        }
      },
    );
  }

  Row mapJob(BoxConstraints boxConstraints) {
    return makeCenter(
      boxConstraints,
      widget: Container(
        height: boxConstraints.maxHeight * 0.6,
        decoration: MyConstant().curveBox(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: load
              ? const WidgetProgress()
              : GoogleMap(
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(position!.latitude, position!.longitude),
                    zoom: 16,
                  ),
                  onMapCreated: (controller) {},
                  onTap: (argument) {
                    print('tab ${argument.latitude}, ${argument.longitude}');

                    jobLatLng = argument;

                    MarkerId markerId = const MarkerId('id');
                    Marker marker = Marker(
                      markerId: markerId,
                      position: argument,
                      infoWindow: const InfoWindow(
                          title: 'Job Position', snippet: 'Work From Here'),
                      icon: bitmapDescriptor ??
                          BitmapDescriptor.defaultMarkerWithHue(60),
                      // icon: BitmapDescriptor.defaultMarkerWithHue(60),
                    );
                    markerMap[markerId] = marker;
                    setState(() {});
                  },
                  markers: Set<Marker>.of(markerMap.values),
                ),
        ),
      ),
      width: boxConstraints.maxWidth * 0.8,
    );
  }

  Row formDetail(BoxConstraints boxConstraints) {
    return makeCenter(boxConstraints,
        widget: WidgetForm(
          hint: 'Detail Job',
          iconData: Icons.details,
          changeFunc: (p0) {
            detail = p0.trim();
          },
        ));
  }

  Row formName(BoxConstraints boxConstraints) {
    return makeCenter(boxConstraints,
        widget: WidgetForm(
          hint: 'Name Job',
          iconData: Icons.work,
          changeFunc: (p0) {
            name = p0.trim();
          },
        ));
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

  void createIconMarker() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(72, 72)), 'images/factory.png')
        .then((value) {
      bitmapDescriptor = value;
    });
  }

  Future<void> processInsertJob() async {
    var datas = await MyService().findDatas();
    print('datas = $datas');

    DateTime dateTime = DateTime.now();
    print('dateCreate = ${dateTime.toString()}');

    JobModel jobModel = JobModel(
        job: name!,
        detail: detail!,
        idBoss: datas[0].trim(),
        lat: jobLatLng!.latitude.toString(),
        lng: jobLatLng!.longitude.toString(),
        dateCreate: dateTime.toString());

    print('jobModel ==> ${jobModel.toMap()}');

    String path =
        'https://www.androidthai.in.th/fluttertraining/insertJobUng.php?isAdd=true&job=$name&detail=$detail&idBoss=${jobModel.idBoss}&lat=${jobModel.lat}&lng=${jobModel.lng}&dateCreate=${jobModel.dateCreate}';

    await Dio().get(path).then((value) {
      var stationCode = value.statusCode;
      print('stationCode ==> $stationCode');

      Navigator.pop(context);
    });
  }
}
