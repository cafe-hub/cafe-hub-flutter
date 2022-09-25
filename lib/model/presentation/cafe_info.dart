import 'package:get/get.dart';

class CafeInfo {
  String id;
  String? name;
  String? location;
  String todayHours;
  List<String> weekHours;
  String? plugStatus;
  double lat;
  double lng;
  List<String> photoUrls;
  RxBool isSelected = false.obs;

  CafeInfo(this.id, this.name, this.location, this.todayHours, this.weekHours, this.plugStatus, this.lat, this.lng, this.photoUrls);
}
