import 'package:cafe_hub_flutter/page/detail.dart';
import 'package:cafe_hub_flutter/page/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'controller/detail_controller.dart';

void main() {
  runApp(CafeHub());
}

class CafeHub extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'test',
      routes: {
        '/home': (context) => const Home(),
        '/detail': (context) => Detail(detailController: Get.find()),
      },
      initialRoute: '/detail',
      initialBinding: BindingsBuilder(() {
        Get.put(DetailController());
      }),
    );
  }
}