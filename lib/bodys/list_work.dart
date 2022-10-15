import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ungofficer/models/job_model.dart';
import 'package:ungofficer/utility/my_constant.dart';
import 'package:ungofficer/utility/my_service.dart';
import 'package:ungofficer/widgets/widget_icon_button.dart';
import 'package:ungofficer/widgets/widget_progress.dart';
import 'package:ungofficer/widgets/widget_text.dart';

class ListWork extends StatefulWidget {
  const ListWork({super.key});

  @override
  State<ListWork> createState() => _ListWorkState();
}

class _ListWorkState extends State<ListWork> {
  var datas = <String>[];

  bool load = true;
  bool? haveJob, work;

  JobModel? jobModel;
  Position? position;
  BitmapDescriptor? officerBitmap, jobBitmap;
  Map<MarkerId, Marker> mapMarker = {};
  Map<CircleId, Circle> mapCircle = {};

  double? distance;
  String? distanceStr;

  @override
  void initState() {
    super.initState();
    findDatas();
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? const WidgetProgress()
        : haveJob!
            ? LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      newTitle(boxConstraints,
                          head: 'Job : ', value: jobModel!.job),
                      newTitle(boxConstraints,
                          head: 'Detail : ', value: jobModel!.detail),
                      newTitle(boxConstraints,
                          head: 'Date : ',
                          value: MyService().changeDateFormat(
                                  dateStr: jobModel!.dateCreate) ??
                              ''),
                      showMap(boxConstraints),
                      newTitle(boxConstraints,
                          head: 'Distance : ',
                          value: distanceStr ?? '',
                          widget: WidgetIconButton(
                            iconData: Icons.refresh,
                            pressFunc: () {
                              findPosition();
                            },
                          )),
                    ],
                  ),
                );
              })
            : Center(
                child: WidgetText(
                  text: 'No Job',
                  textStyle: MyConstant().h1Style(),
                ),
              );
  }

  Container showMap(BoxConstraints boxConstraints) {
    return Container(
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.symmetric(vertical: 16),
      width: boxConstraints.maxWidth * 0.8,
      height: boxConstraints.maxWidth * 0.8,
      decoration: MyConstant().curveBox(),
      child: position == null
          ? const WidgetProgress()
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(position!.latitude, position!.longitude),
                zoom: 16,
              ),
              onMapCreated: (controller) {},
              markers: Set<Marker>.of(mapMarker.values),
              circles: Set<Circle>.of(mapCircle.values),
            ),
    );
  }

  Row newTitle(BoxConstraints boxConstraints,
      {required String head, required String value, Widget? widget}) {
    return Row(
      children: [
        const SizedBox(
          width: 16,
        ),
        SizedBox(
          width: boxConstraints.maxWidth * 0.3 - 16,
          child: WidgetText(
            text: head,
            textStyle: MyConstant().h2Style(size: 18),
          ),
        ),
        SizedBox(
          width: widget == null
              ? boxConstraints.maxWidth * 0.7 - 16
              : boxConstraints.maxWidth * 0.7 - 48,
          child: WidgetText(text: value),
        ),
        widget ?? const SizedBox(),
      ],
    );
  }

  Future<void> findDatas() async {
    await MyService().findDatas().then((value) {
      datas = value;
      readMyJob();
    });
  }

  Future<void> readMyJob() async {
    String path =
        'https://www.androidthai.in.th/fluttertraining/getJobWhereIdOfficerUng.php?isAdd=true&idOfficer=${datas[0]}';

    await Dio().get(path).then((value) {
      if (value.toString() == 'null') {
        haveJob = false;
      } else {
        haveJob = true;

        for (var element in json.decode(value.data)) {
          jobModel = JobModel.fromMap(element);
        }
      }
      findPosition();
      load = false;
      setState(() {});
    });
  }

  Future<void> findPosition() async {
    officerBitmap = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)), 'images/officer.png');
    jobBitmap = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)), 'images/factory.png');

    position = await MyService().processFindPosition(context: context);

    distance = MyService().calculateDistance(
        position!.latitude,
        position!.longitude,
        double.parse(jobModel!.lat),
        double.parse(jobModel!.lng));

    NumberFormat numberFormat = NumberFormat('#,###.0#', 'en_US');
    distanceStr = numberFormat.format(distance);
    distanceStr = '$distanceStr m';

    if (distance! <= MyConstant.workDistance) {
      work = true;
    } else {
      work = false;
    }

    MarkerId markerIdOfficer = const MarkerId('officer');
    Marker markerOfficer = Marker(
      markerId: markerIdOfficer,
      position: LatLng(
        position!.latitude,
        position!.longitude,
      ),
      icon: officerBitmap!,
    );

    mapMarker[markerIdOfficer] = markerOfficer;

    MarkerId markerIdJob = const MarkerId('job');
    Marker markerJob = Marker(
      markerId: markerIdJob,
      position: LatLng(
        double.parse(jobModel!.lat),
        double.parse(jobModel!.lng),
      ),
      icon: jobBitmap!,
    );

    mapMarker[markerIdJob] = markerJob;

    CircleId circleIdOfficer = const CircleId('officer');
    Circle circleOfficer = Circle(
      circleId: circleIdOfficer,
      center: LatLng(
        position!.latitude,
        position!.longitude,
      ),
      radius: MyConstant.workDistance,
      strokeWidth: 1,
      strokeColor: work! ? Colors.green : MyConstant.primary ,
      fillColor: work! ? Colors.green.withOpacity(0.25) : MyConstant.primary.withOpacity(0.25) ,
    );

    mapCircle[circleIdOfficer] = circleOfficer;

    setState(() {});
  }
}
