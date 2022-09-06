import 'package:cafe_hub_flutter/model/presentation/cafe_info.dart';
import 'package:get/get.dart' as getx;
import 'package:naver_map_plugin/naver_map_plugin.dart';

class HomeController extends getx.GetxController {
  var bottomSheetVisibility = false.obs;
  List<Marker> markers = [
    Marker(
      markerId: DateTime.now().toIso8601String(),
      position: LatLng(37.563600, 126.962370),
      infoWindow: '테스트'
    )
  ];

  var cafes = [
    CafeInfo('미스터디유커피1', '인천 연수구 아카데미로 119', '10:30 ~ 17:30', '콘센트 많음'),
    CafeInfo('미스터디유커피2', '인천 연수구 아카데미로 119', '10:30 ~ 17:30', '콘센트 많음'),
    CafeInfo('미스터디유커피3', '인천 연수구 아카데미로 119', '10:30 ~ 17:30', '콘센트 많음')
  ].obs;
}