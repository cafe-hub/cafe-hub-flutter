import 'package:cafe_hub_flutter/model/presentation/cafe_info.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../service/cafe_service.dart';

class HomeControllerGoogle extends GetxController {
  var bottomSheetVisibility = false.obs;
  var cafes = <CafeInfo>[].obs;
  CafeInfo? previousSelectedCafe;

  Set<Marker> getMarkers(void Function() action) {
    return cafes
        .map((cafeInfo) => Marker(
              markerId: MarkerId(cafeInfo.id),
              position: LatLng(cafeInfo.lat, cafeInfo.lng),
              onTap: action,
            ))
        .toSet();
  }

  void getCafes(double topLeftLongitude, double topLeftLatitude,
      double bottomRightLongitude, double bottomRightLatitude) async {
    cafes.value = await CafeService().fetchCafes(
        topLeftLongitude,
        topLeftLatitude,
        bottomRightLongitude,
        bottomRightLatitude) as List<CafeInfo>;
  }

  Future<CafeInfo> getCafeDetailData(int id) async {
    var res = await CafeService().fetchCafe(id);

    return res!;
  }
}
