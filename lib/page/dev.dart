import 'package:cafe_hub_flutter/page/detail.dart';
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
          children: [
            TextButton(
                onPressed: () => Get.to(() => Home()),
                child: Text("지도")
            ),
            TextButton(
                onPressed: () => Get.to(() => Detail(detailController: Get.find())),
                child: Text("상세 페이지")
            )
          ],
        ),
      ),
    );
  }
}
