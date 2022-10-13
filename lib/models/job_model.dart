import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class JobModel {
  final String? id;
  final String job;
  final String detail;
  final String? status;
  final String idBoss;
  final String? idOfficer;
  final String? images;
  final String lat;
  final String lng;
  final String? remark;
  final String dateCreate;
  JobModel({
    this.id,
    required this.job,
    required this.detail,
    this.status,
    required this.idBoss,
    this.idOfficer,
    this.images,
    required this.lat,
    required this.lng,
    this.remark,
    required this.dateCreate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'job': job,
      'detail': detail,
      'status': status,
      'idBoss': idBoss,
      'idOfficer': idOfficer,
      'images': images,
      'lat': lat,
      'lng': lng,
      'remark': remark,
      'dateCreate': dateCreate,
    };
  }

  factory JobModel.fromMap(Map<String, dynamic> map) {
    return JobModel(
      id: map['id'] != null ? map['id'] as String : null,
      job: (map['job'] ?? '') as String,
      detail: (map['detail'] ?? '') as String,
      status: map['status'] != null ? map['status'] as String : null,
      idBoss: (map['idBoss'] ?? '') as String,
      idOfficer: map['idOfficer'] != null ? map['idOfficer'] as String : null,
      images: map['images'] != null ? map['images'] as String : null,
      lat: (map['lat'] ?? '') as String,
      lng: (map['lng'] ?? '') as String,
      remark: map['remark'] != null ? map['remark'] as String : null,
      dateCreate: (map['dateCreate'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory JobModel.fromJson(String source) => JobModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
