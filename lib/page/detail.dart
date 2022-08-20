import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../common/ChColors.dart';
import '../controller/detail_controller.dart';

class Detail extends StatefulWidget {
  final DetailController detailController;

  const Detail({Key? key, required this.detailController}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(top: 16)),
            location(),
            plugInfo(),
            openInfo(widget.detailController.openAndCloseInfo)
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
        leading: const Icon(Icons.arrow_back_ios),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "미스터디유커피",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ));
  }

  Widget location() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 8,
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: SvgPicture.asset(
              'assets/marker_outlined.svg',
              color: ChColors.black,
              width: 16,
              height: 16,
            ),
          ),
          Text("인천 연수구 아카데미로 119")
        ],
      ),
    );
  }

  Widget plugInfo() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: SvgPicture.asset(
              'assets/power.svg',
              color: ChColors.black,
              width: 16,
              height: 16,
            ),
          ),
          Text("콘센트 많음")
        ],
      ),
    );
  }

  Widget openInfo(List<String> list) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
          child: SvgPicture.asset(
            'assets/time.svg',
            color: ChColors.black,
            width: 16,
            height: 16,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text("영업중", style: TextStyle(color: ChColors.primary))),
            ...openAndClose(list)
          ],
        )
      ],
    );
  }

  List<Widget> openAndClose(List<String> list) {
    return list
        .map((info) =>
            Padding(padding: EdgeInsets.only(bottom: 8), child: Text(info)))
        .toList();
  }
}
