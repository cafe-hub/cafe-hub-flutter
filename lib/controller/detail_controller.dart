import 'package:get/get.dart' as getx;

class DetailController extends getx.GetxController {
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
  void updatePage(int page) {
    currentCarouselPage.value = page;
  }
}