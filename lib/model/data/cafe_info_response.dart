import 'dart:ffi';

class CafeInfoResponse {
  Long id;
  String cafeName;
  String location;
  String plugStatus;
  String? monday;
  String? tuesday;
  String? wednesday;
  String? thursday;
  String? friday;
  String? saturday;
  String? sunday;
  List<String> photoUrl = []; // 수정될 수 있음.

  CafeInfoResponse({
    required this.id,
    required this.cafeName,
    required this.location,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
    required this.plugStatus
  });

  CafeInfoResponse.fromJson(Map json) :
        id = json['id'],
        cafeName = json['cafeName'],
        location = json['cafeName'],
        monday = json['cafeName'],
        tuesday = json['tuesday'],
        wednesday = json['wednesday'],
        thursday = json['thursday'],
        friday = json['friday'],
        saturday = json['saturday'],
        sunday = json['sunday'],
        plugStatus = json['plugStatus'];
}