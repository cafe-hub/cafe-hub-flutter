import 'package:naver_map_plugin/naver_map_plugin.dart';

class CafeInfo {
  String id;
  String? name;
  String? location;
  String? todayHours;
  List<String> weekHours;
  String? plugStatus;
  LatLng latLng;
  List<String> photoUrls;

  CafeInfo(this.id, this.name, this.location, this.todayHours, this.weekHours, this.plugStatus, this.latLng, this.photoUrls);
}
