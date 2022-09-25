import 'dart:async';

import 'package:cafe_hub_flutter/common/map_controller_adapter.dart';
import 'package:cafe_hub_flutter/controller/home_controller_google.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChGoogleMapController implements MapControllerAdapter {
  Completer<GoogleMapController> mapController = Completer();
  HomeControllerGoogle homeControllerGoogle = Get.find();

  void onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);
  }

  @override
  void toCameraPosition(double latitude, double longitude) async {
    final GoogleMapController controller = await mapController.future;
    CameraPosition position = CameraPosition(
        target: LatLng(37.510181246, 127.043505829), zoom: 14.4746);
    controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  void onCameraPosition(CameraPosition cameraPosition) async {
    var controller = await mapController.future;

    var visibleRegion = await controller.getVisibleRegion();

    var bottomRightLatitude = visibleRegion.southwest.latitude;
    var topLeftLatitude = visibleRegion.northeast.latitude;
    var topLeftLongitude = visibleRegion.southwest.longitude;
    var bottomRightLongitude = visibleRegion.northeast.longitude;

    homeControllerGoogle.getCafes(topLeftLongitude, topLeftLatitude,
        bottomRightLongitude, bottomRightLatitude);
  }
}
