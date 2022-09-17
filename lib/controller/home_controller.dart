import 'package:cafe_hub_flutter/model/presentation/cafe_info.dart';
import 'package:get/get.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:cafe_hub_flutter/service/cafe_service.dart';
//다건조회
class HomeController extends GetxController {
  var bottomSheetVisibility = false.obs;
  var cafes = <CafeInfo>[].obs;
  CafeInfo? previousSelectedCafe;
  OverlayImage? markerImage;
  OverlayImage? selectedMarkerImage;

  HomeController() {
    _setOverlayImage();
  }

  _setOverlayImage() async {
    markerImage = await OverlayImage.fromAssetImage(assetName: "assets/marker.png");
    selectedMarkerImage = await OverlayImage.fromAssetImage(assetName: "assets/marker_filled.png");
  }

  List<Marker> getMarkers(void Function(Marker? marker, Map<String, int?> iconSize) action) {
    return cafes.map(
            (cafeInfo) => Marker(
            markerId: cafeInfo.id,
            position: cafeInfo.latLng,
            onMarkerTab: action,
            icon: cafeInfo.isSelected.value ? selectedMarkerImage : markerImage,
            width: cafeInfo.isSelected.value ? 48 : 24,
            height: cafeInfo.isSelected.value ? 48 : 24)
    ).toList();
  }

  void getCafes(double topLeftLongitude, double topLeftLatitude, double bottomRightLongitude, double bottomRightLatitude) async {

    cafes.value = await CafeService().fetchCafes(topLeftLongitude, topLeftLatitude, bottomRightLongitude, bottomRightLatitude) as List<CafeInfo>;
  }

  Future<CafeInfo> getCafeDetailData(int id) async {
    var res = await CafeService().fetchCafe(id);

    return res!;
  }
}