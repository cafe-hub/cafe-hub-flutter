import 'dart:ffi';

import 'package:cafe_hub_flutter/model/presentation/cafe_info.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class CafesInfoResponse {
  int id;
  double longitude;
  double latitude;

  CafesInfoResponse({
    required this.id,
    required this.longitude,
    required this.latitude
  });

  CafesInfoResponse.fromJson(Map<String, dynamic> json) :
        id = json['id'],
        longitude = json['longitude'],
        latitude = json['latitude'];



}
