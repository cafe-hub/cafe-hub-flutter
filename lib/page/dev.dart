import 'package:cafe_hub_flutter/page/detail.dart';
import 'package:cafe_hub_flutter/page/test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home.dart';

class Dev extends StatefulWidget {
  const Dev({Key? key}) : super(key: key);

  @override
  State<Dev> createState() => _State();
}

class _State extends State<Dev> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
                onPressed: () => Get.to(() => Home(homeController: Get.find())),
                child: Text("지도")
            ),
            TextButton(
                onPressed: () => Get.to(() => Detail(detailController: Get.find())),
                child: Text("상세 페이지")
            ),
            TextButton(
                onPressed: () => Get.to(() => Test()),
                child: Text("테스트용 페이지")
            ),
          ],
        ),
      ),
    );
  }
}
