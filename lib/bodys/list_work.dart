// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ungofficer/models/job_model.dart';
import 'package:ungofficer/models/user_model.dart';
import 'package:ungofficer/utility/my_constant.dart';
import 'package:ungofficer/utility/my_service.dart';
import 'package:ungofficer/widgets/widget_button.dart';
import 'package:ungofficer/widgets/widget_icon_button.dart';
import 'package:ungofficer/widgets/widget_image.dart';
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
  bool? haveJob;
  bool work = false;

  JobModel? jobModel;
  Position? position;
  BitmapDescriptor? officerBitmap, jobBitmap;
  Map<MarkerId, Marker> mapMarker = {};
  Map<CircleId, Circle> mapCircle = {};

  double? distance;
  String? distanceStr;

  File? file;
  var files = <File>[];

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
            ? jobModel == null
                ? Center(
                    child: WidgetText(
                    text: 'Finish All Job',
                    textStyle: MyConstant().h1Style(),
                  ))
                : mainContent()
            : Center(
                child: WidgetText(
                  text: 'No Job',
                  textStyle: MyConstant().h1Style(),
                ),
              );
  }

  LayoutBuilder mainContent() {
    return LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
      return SingleChildScrollView(
        child: Column(
          children: [
            newTitle(boxConstraints, head: 'Job : ', value: jobModel!.job),
            newTitle(boxConstraints,
                head: 'Detail : ', value: jobModel!.detail),
            newTitle(boxConstraints,
                head: 'Date : ',
                value: MyService()
                        .changeDateFormat(dateStr: jobModel!.dateCreate) ??
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
            imageTakePhoto(boxConstraints: boxConstraints),
            gridImage(boxConstraints: boxConstraints),
            buttonFinishJob(boxConstraints: boxConstraints),
          ],
        ),
      );
    });
  }

  Widget buttonFinishJob({required BoxConstraints boxConstraints}) {
    return work
        ? files.isNotEmpty
            ? Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                width: boxConstraints.maxWidth * 0.8,
                child: WidgetButton(
                  label: 'Finish Job',
                  pressFunc: () {
                    processUploadAndEditData();
                  },
                ),
              )
            : const SizedBox()
        : const SizedBox();
  }

  Widget gridImage({required BoxConstraints boxConstraints}) {
    return work
        ? files.isNotEmpty
            ? GridView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: files.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemBuilder: (context, index) => Container(
                  padding: const EdgeInsets.all(4),
                  decoration: MyConstant().curveBox(),
                  width: boxConstraints.maxWidth * 0.33 - 10,
                  height: boxConstraints.maxWidth * 0.33 - 10,
                  child: InkWell(
                    onTap: () {
                      print('Yout tap grid index => $index');
                      file = files[index];
                      setState(() {});
                    },
                    child: Image.file(
                      files[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            : const SizedBox()
        : const SizedBox();
  }

  Widget imageTakePhoto({required BoxConstraints boxConstraints}) {
    return work
        ? Column(
            children: [
              WidgetText(
                text: 'Take Photo',
                textStyle: MyConstant().h2Style(size: 18),
              ),
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    decoration: MyConstant().curveBox(),
                    width: boxConstraints.maxWidth * 0.8,
                    height: boxConstraints.maxWidth * 0.8,
                    child: file == null
                        ? const WidgetImage(
                            path: 'images/image.png',
                          )
                        : Image.file(
                            file!,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 0,
                    child: WidgetIconButton(
                      iconData: Icons.add_a_photo,
                      pressFunc: () {
                        processTakePhoto();
                      },
                    ),
                  ),
                ],
              ),
            ],
          )
        : const SizedBox();
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
    if (jobModel != null) {
      jobModel = null;
      load = true;
    }

    String path =
        'https://www.androidthai.in.th/fluttertraining/getJobWhereIdOfficerUng.php?isAdd=true&idOfficer=${datas[0]}';

    await Dio().get(path).then((value) {
      if (value.toString() == 'null') {
        haveJob = false;
      } else {
        haveJob = true;

        for (var element in json.decode(value.data)) {
          var result = JobModel.fromMap(element);
          if (result.status == 'assign') {
            jobModel = result;
          }
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
      strokeColor: work! ? Colors.green : MyConstant.primary,
      fillColor: work!
          ? Colors.green.withOpacity(0.25)
          : MyConstant.primary.withOpacity(0.25),
    );

    mapCircle[circleIdOfficer] = circleOfficer;

    setState(() {});
  }

  Future<void> processTakePhoto() async {
    var result = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (result != null) {
      file = File(result.path);
      files.add(file!);
      setState(() {});
    }
  }

  Future<void> processUploadAndEditData() async {
    var datas = await MyService().findDatas();
    String path =
        'https://www.androidthai.in.th/fluttertraining/saveFileUng.php';

    var images = <String>[];

    for (var element in files) {
      String nameFile = '${datas[3]}${Random().nextInt(1000000)}.jpg';

      Map<String, dynamic> map = {};
      map['file'] =
          await MultipartFile.fromFile(element.path, filename: nameFile);
      FormData formData = FormData.fromMap(map);
      await Dio().post(path, data: formData).then((value) {
        images.add(nameFile);
      });
    }

    print('images ===> $images');

    String apiGetUserWhereUser =
        'https://www.androidthai.in.th/fluttertraining/getUserWhereUserUng.php?isAdd=true&user=${datas[3]}';

    var finishs = <String>[];

    await Dio().get(apiGetUserWhereUser).then((value) async {
      for (var element in json.decode(value.data)) {
        UserModel userModel = UserModel.fromMap(element);
        if (userModel.finish!.isEmpty) {
          finishs.add(jobModel!.id!);
        } else {
          finishs = MyService().changeStringToList(string: userModel.finish!);

          print('before finishs == $finishs');
          ;

          finishs.add(jobModel!.id!);
        }
      }

      print('last finishs ==> $finishs');
      String apiEditFinish =
          'https://www.androidthai.in.th/fluttertraining/editUserWhereIdFinishUng.php?isAdd=true&id=${datas[0]}&finish=${finishs.toString()}';
      await Dio().get(apiEditFinish).then((value) async {
        String pathEditStatus =
            'https://www.androidthai.in.th/fluttertraining/editJobStatusImagesWhereIdUng.php?isAdd=true&id=${jobModel!.id}&images=${images.toString()}';
        await Dio().get(pathEditStatus).then((value) {
          readMyJob();
        });
      });
    });
  }
}
