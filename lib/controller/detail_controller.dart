import 'dart:ffi';

import 'package:cafe_hub_flutter/service/service.dart';
import 'package:get/get.dart';
//상세조회
class DetailController extends GetxController {
  List<String> openAndCloseInfo = [
    "월요일 10:00 - 17:30",
    "화요일 10:00 - 17:30",
    "수요일 10:00 - 17:30",
    "목요일 10:00 - 17:30",
    "금요일 10:00 - 17:30",
    "토요일 휴무",
    "일요일 휴무"
  ].obs;

  List<String> imageUrls = ['https://picsum.photos/360', 'https://picsum.photos/400'];

  var currentCarouselPage = 1.obs;
  //현재 사진 몇 페이지 보고 있는지 업데이트
  void updatePage(int page) {
    currentCarouselPage.value = page;
  }

  void getCafeData(Long id) async {
    var cafeInfo = await Service().fetchCafe(id);
    if(cafeInfo != null){
      //cafeInfo 데이터를 넣어야 함. 일단 땅땅
    }
  }
  
}