import 'dart:async';

import 'package:cafe_hub_flutter/common/map_controller_adapter.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class NaverMapControllerAdapter implements MapControllerAdapter {
  Completer<NaverMapController> mapController = Completer();

  void onMapCreated(NaverMapController controller) {
    if (mapController.isCompleted) mapController = Completer();
    mapController.complete(controller);
  }

  @override
  void toCameraPosition(double latitude, double longitude) {
    mapController.future.then((value) {
      var camUpdate = CameraUpdate.toCameraPosition(
          CameraPosition(target: LatLng(latitude, longitude)));
      value.moveCamera(camUpdate);
    });
  }
}
