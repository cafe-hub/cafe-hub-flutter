import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

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
    return Obx(() => Scaffold(
          appBar: appBar(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                cafeImages(widget.detailController.cafeInfo.photoUrls),
                location(),
                plugInfo(),
                openInfo(widget.detailController.cafeInfo.weekHours)
              ],
            ),
          ),
        ));
  }

  AppBar appBar() {
    return AppBar(
        leading: const Icon(Icons.arrow_back_ios),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.detailController.cafeInfo.name,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ));
  }

  Widget cafeImages(List<String> list) {
    return Stack(alignment: Alignment.topRight, children: [
      carousel(list),
      Container(
          margin: EdgeInsets.only(right: 20, top: 16),
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
              color: Color(0x88000000),
              borderRadius: BorderRadius.circular(20)),
          child: Text(
                "${widget.detailController.currentCarouselPage}/${list.length}",
                style: TextStyle(color: Colors.white),
              ))
    ]);
  }

  Widget carousel(List<String> list) {
    return CarouselSlider.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
            SizedBox(
                width: double.infinity,
                child: Image(
                    image: NetworkImage(list[itemIndex]), fit: BoxFit.cover)),
        options: CarouselOptions(
            height: MediaQuery.of(context).size.width,
            viewportFraction: 1,
            onPageChanged: (index, reason) =>
                {widget.detailController.updatePage(index + 1)}));
  }

  Widget location() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8, left: 20, right: 20, top: 16),
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
      padding: EdgeInsets.only(bottom: 8, left: 20, right: 20),
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
          padding: EdgeInsets.fromLTRB(20, 2, 8, 0),
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
            Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(widget.detailController.cafeInfo.todayHours,
                    style: TextStyle(color: ChColors.primary))),
            ...openAndClose()
          ],
        )
      ],
    );
  }

  List<Widget> openAndClose() {
    return widget.detailController.cafeInfo.weekHours
        .map((info) =>
            Padding(padding: EdgeInsets.only(bottom: 8), child: Text(info)))
        .toList();
  }
}
