import 'package:cafe_hub_flutter/model/presentation/cafe_info.dart';
import 'package:get/get.dart' as getx;

class HomeController extends getx.GetxController {
  var bottomSheetVisibility = false.obs;

  var cafes = [
    CafeInfo('미스터디유커피1', '인천 연수구 아카데미로 119', '10:30 ~ 17:30', '콘센트 많음'),
    CafeInfo('미스터디유커피2', '인천 연수구 아카데미로 119', '10:30 ~ 17:30', '콘센트 많음'),
    CafeInfo('미스터디유커피3', '인천 연수구 아카데미로 119', '10:30 ~ 17:30', '콘센트 많음')
  ].obs;
}