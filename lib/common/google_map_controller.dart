import 'dart:async';

import 'package:cafe_hub_flutter/common/map_controller_adapter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChGoogleMapController implements MapControllerAdapter {
  Completer<GoogleMapController> _controller = Completer();

  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void toCameraPosition(double latitude, double longitude) async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition position =
        CameraPosition(target: LatLng(37.510181246, 127.043505829));
    controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }
}
