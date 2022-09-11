import 'dart:ffi';
import 'dart:html';

import 'package:cafe_hub_flutter/model/presentation/cafe_info.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class CafeInfoResponse {
  Long id;
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

  List<String> photoUrl = []; // 수정될 수 있음.

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
    required this.plugStatus
  });

  CafeInfoResponse.fromJson(Map json) :
        id = json['id'],
        cafeName = json['cafeName'],
        location = json['cafeName'],
        monday = json['cafeName'],
        tuesday = json['tuesday'],
        wednesday = json['wednesday'],
        thursday = json['thursday'],
        friday = json['friday'],
        saturday = json['saturday'],
        sunday = json['sunday'],
        plugStatus = json['plugStatus'];

  CafeInfo toEntity() {
    int today = DateTime.now().weekday;
    List<String?> weekHours = [monday, tuesday, wednesday, thursday, friday, saturday, sunday];
    String? todayHours = weekHours[today-1] ?? "휴무일";

    return CafeInfo(id.toString(), cafeName, location, todayHours, weekHours, plugStatus, LatLng(37.4964860, 127.0283615));
  }
}
