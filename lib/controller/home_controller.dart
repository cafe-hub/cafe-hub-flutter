import 'package:cafe_hub_flutter/model/presentation/cafe_info.dart';
import 'package:get/get.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:cafe_hub_flutter/service/cafe_service.dart';
//다건조회
class HomeController extends GetxController {
  var bottomSheetVisibility = false.obs;
  var cafes = <CafeInfo>[].obs;

  List<Marker> getMarkers(void Function(Marker? marker, Map<String, int?> iconSize) action) {
    return cafes.map(
            (cafeInfo) => Marker(
            markerId: cafeInfo.id,
            position: cafeInfo.latLng,
            onMarkerTab: action,)
    ).toList();
  }

  void getCafes(double topLeftLongitude, double topLeftLatitude, double bottomRightLongitude, double bottomRightLatitude) async {

    cafes.value = await CafeService().fetchCafes(topLeftLongitude, topLeftLatitude, bottomRightLongitude, bottomRightLatitude) as List<CafeInfo>;
  }

}