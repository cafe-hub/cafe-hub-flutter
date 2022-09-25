import 'dart:math';
import 'dart:typed_data';

import 'package:cafe_hub_flutter/model/presentation/cafe_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

import '../service/cafe_service.dart';

class HomeControllerGoogle extends GetxController {
  var bottomSheetVisibility = false.obs;
  var cafes = <CafeInfo>[].obs;
  CafeInfo? previousSelectedCafe;
  Uint8List? markerImageBytes;
  Uint8List? selectedMarkerImageBytes;
  RxBool isLoadedMarkerImage = false.obs;
  RxDouble pixelRatio = 2.625.obs;

  HomeControllerGoogle() {
    setCustomMarker();
  }

  void setCustomMarker() async {
    markerImageBytes = await getBytesFromAsset("assets/marker.png", (24 * pixelRatio.value).toInt());
    selectedMarkerImageBytes = await getBytesFromAsset("assets/marker_filled.png", (48 * pixelRatio.value).toInt());
    isLoadedMarkerImage.value = true;
  }

  Set<Marker> getMarkers(void Function(String) action) {
    setCustomMarker();

    if(isLoadedMarkerImage.isFalse) return <Marker>[].toSet();

    return cafes
        .map((cafeInfo) => Marker(
              markerId: MarkerId(cafeInfo.id),
              position: LatLng(cafeInfo.lat, cafeInfo.lng),
              icon: isMarkerSelected(cafeInfo) ? BitmapDescriptor.fromBytes(selectedMarkerImageBytes!) : BitmapDescriptor.fromBytes(markerImageBytes!),
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

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }
}
