import 'package:cafe_hub_flutter/controller/home_controller.dart';
import 'package:cafe_hub_flutter/model/presentation/cafe_info.dart';
import 'package:cafe_hub_flutter/page/detail.dart';
import 'package:cafe_hub_flutter/page/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:firebase_core/firebase_core.dart';

import 'controller/detail_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //세션 시간 일주알로 늘리는 거..오바지..?ㅎㅎㅎㅎ
  //FirebaseAnalytics.instance.setSessionTimeoutDuration(timeout);
  runApp(CafeHub());
}

class CafeHub extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(

      title: 'test',
      routes: {
        '/home': (context) => Home(homeController: Get.find()),
        '/detail': (context) => Detail(detailController: Get.find(), cafeId: 11)
      },
      initialRoute: '/home',
      initialBinding: BindingsBuilder(() {
        Get.put(HomeController());
        Get.put(DetailController(
          cafeInfo: CafeInfo("null", "null", "null", "00:00 - 00:00",
              [
                "00:00 - 00:00",
                "00:00 - 00:00",
                "00:00 - 00:00",
                "00:00 - 00:00",
                "00:00 - 00:00",
                "00:00 - 00:00",
                "00:00 - 00:00"
              ], "null", LatLng(37, 127), ['https://picsum.photos/360', 'https://picsum.photos/400']).obs
        ));
      }),
    );
  }
}
