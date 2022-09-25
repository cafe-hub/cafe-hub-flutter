import 'dart:typed_data';

import 'package:cafe_hub_flutter/model/presentation/cafe_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../service/cafe_service.dart';

class HomeControllerGoogle extends GetxController {
  var bottomSheetVisibility = false.obs;
  var cafes = <CafeInfo>[].obs;
  CafeInfo? previousSelectedCafe;
  BitmapDescriptor? markerImage;
  BitmapDescriptor? selectedMarkerImage;
  RxBool isLoadedMarkerImage = false.obs;

  HomeControllerGoogle() {
    setCustomMarker();
  }

  void setCustomMarker() async {
    markerImage = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(24, 24)), "assets/marker.png");
    selectedMarkerImage = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(48, 48)), "assets/marker_filled.png");
    isLoadedMarkerImage.value = true;
  }

  Set<Marker> getMarkers(void Function(String) action) {
    if(isLoadedMarkerImage.isFalse) return <Marker>[].toSet();

    return cafes
        .map((cafeInfo) => Marker(
              markerId: MarkerId(cafeInfo.id),
              position: LatLng(cafeInfo.lat, cafeInfo.lng),
              icon: isMarkerSelected(cafeInfo) ? selectedMarkerImage! : markerImage!,
              onTap: () {
                action(cafeInfo.id);
              }
            ))
        .toSet();
  }

  bool isMarkerSelected(CafeInfo cafeInfo) {
    if(cafeInfo.isSelected.value) return true;

    if(previousSelectedCafe != null) {
      return cafeInfo.id == previousSelectedCafe!.id && previousSelectedCafe!.isSelected.value;
    } else {
      return false;
    }
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
