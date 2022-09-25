import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../common/ch_colors.dart';
import '../controller/detail_controller.dart';

class Detail extends StatefulWidget {
  final DetailController detailController;
  final int cafeId;

  const Detail({Key? key, required this.detailController, required this.cafeId}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  void initState() {
    widget.detailController.getCafeData(widget.cafeId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: appBar(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                cafeImages(widget.detailController.cafeInfo.value.photoUrls),
                location(),
                plugInfo(),
                openInfo()
              ],
            ),
          ),
        ));
  }

  AppBar appBar() {
    return AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.detailController.cafeInfo.value.name!,
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
          Text(widget.detailController.cafeInfo.value.location!)
        ],
      ),
    );
  }

  Widget plugInfo() {
    var plugStatus = widget.detailController.cafeInfo.value.plugStatus;
    var plugInfoText = "null";

    if (plugStatus == "null") plugInfoText = "콘센트 정보 없음";
    if (plugStatus == "many") plugInfoText = "콘센트 많음";

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
          Text(plugInfoText)
        ],
      ),
    );
  }

  Widget openInfo() {
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
                child: Text(nowCafeStatus(),
                    style: TextStyle(color: ChColors.primary))),
            ...openAndClose()
          ],
        )
      ],
    );
  }

  List<Widget> openAndClose() {
    List<String> hours = widget.detailController.cafeInfo.value.weekHours;
    List<String> days = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"];

    return hours.asMap().entries.map((entry) {
      int index = entry.key;

      return Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text("${days[index]} ${hours[index]}"));
    }).toList();
  }

  String nowCafeStatus() {
    String nowCafeStatus = "영업 종료";

    if(_isOpen()) nowCafeStatus="영업중";

    return nowCafeStatus;
  }

  bool _isOpen() {
    DateTime now = DateTime.now();
    String currentTime = DateTime(now.year, now.month, now.day).toString().substring(0,10);

    String todayHour = widget.detailController.cafeInfo.value.todayHours.toString();
    List<String> openClose = todayHour.split(" - ");

    String openTimeString = "$currentTime ${openClose[0].length == 4 ? "0" : ""}${openClose[0]}:00"; // "2012-02-27 13:27:00"
    DateTime open = DateTime.parse(openTimeString);

    String closeTimeString = "$currentTime ${openClose[1].length == 4 ? "0" : ""}${openClose[1]}:00"; // "2012-02-27 13:27:00"
    DateTime close = DateTime.parse(closeTimeString);

    return now.isAfter(open) && now.isBefore(close);
  }
}
