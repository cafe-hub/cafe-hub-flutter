import 'dart:ffi';

import 'package:cafe_hub_flutter/model/presentation/cafe_info.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class CafeInfoResponse {
  int id;
  String cafeName;
  String location;
  String plugStatus;
  String? monday;
  String? tuesday;
  String? wednesday;
  String? thursday;
  String? friday;
  String? saturday;
  String? sunday;
  List<String> photoUrl;

  CafeInfoResponse({
    required this.id,
    required this.cafeName,
    required this.location,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
    required this.plugStatus,
    required this.photoUrl
  });
  //CafeInfoResponse.fromJson(Map json) :
  //자료형 안 써도 되는지 모르겠음
  CafeInfoResponse.fromJson(Map<String, dynamic> json) :
        id = json['id'],
        cafeName = json['cafeName'],
        location = json['location'],
        monday = json['monday'],
        tuesday = json['tuesday'],
        wednesday = json['wednesday'],
        thursday = json['thursday'],
        friday = json['friday'],
        saturday = json['saturday'],
        sunday = json['sunday'],
        plugStatus = json['plugStatus'] == "null" ? "콘센트 정보 없음" : json['plugStatus'],
        photoUrl = List<String>.from(json['photoUrl'].map((e) => e.toString()));


  CafeInfo toEntity() {
    int today = DateTime.now().weekday;
    List<String> weekHours = [monday, tuesday, wednesday, thursday, friday, saturday, sunday].map((time) => time ?? "휴무일").toList();
    String? todayHours = weekHours[today-1];

    return CafeInfo(id.toString(), cafeName, location, todayHours, weekHours, plugStatus, LatLng(37.4964860, 127.0283615), photoUrl);
  }
}
