import 'dart:ffi';

import 'package:cafe_hub_flutter/model/presentation/cafe_info.dart';
import 'package:cafe_hub_flutter/service/cafe_service.dart';
import 'package:get/get.dart';
//상세조회
class DetailController extends GetxController {
  Rx<CafeInfo> cafeInfo;

  DetailController({required this.cafeInfo});

  var currentCarouselPage = 1.obs;
  //현재 사진 몇 페이지 보고 있는지 업데이트
  void updatePage(int page) {
    currentCarouselPage.value = page;
  }

  void getCafeData(int id) async {
    var res = await CafeService().fetchCafe(id);
    if(res != null) {
      cafeInfo.value = res;
    }
  }
}