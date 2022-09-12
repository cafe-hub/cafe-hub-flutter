import 'package:cafe_hub_flutter/model/presentation/cafe_info.dart';
import 'package:get/get.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:cafe_hub_flutter/service/cafe_service.dart';
//다건조회
class HomeController extends GetxController {
  var bottomSheetVisibility = false.obs;
  //var cafes = <CafeInfo>[].obs;

  List<Marker> getMarkers(void Function(Marker? marker, Map<String, int?> iconSize) action) {
    return cafes.map(
            (cafeInfo) => Marker(
            markerId: cafeInfo.id,
            position: cafeInfo.latLng,
            onMarkerTab: action,)
    ).toList();
  }



  var cafes = [
    CafeInfo('1', '미스터디유커피1', '인천 연수구 아카데미로 119', '10:30 ~ 17:30',[] , '콘센트 많음', LatLng(37.563600, 126.962370), []),
    CafeInfo('2', '미스터디유커피2', '인천 연수구 아카데미로 119', '10:30 ~ 17:30',[] , '콘센트 많음', LatLng(37.270200, 126.421500), []),
    CafeInfo('3', '미스터디유커피3', '인천 연수구 아카데미로 119', '10:30 ~ 17:30', [] ,'콘센트 많음', LatLng(37.300200, 126.430000), []),
  ].obs;
}