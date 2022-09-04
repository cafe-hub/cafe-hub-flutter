import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

import '../common/ChColors.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<NaverMapController> _controller = Completer();
  MapType _mapType = MapType.Basic;

  void _showList(BuildContext context) {
    showBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: _listItem());
        });
  }

  Widget _listItem() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'https://picsum.photos/360',
                    width: MediaQuery.of(context).size.width / 2 - 21,
                    height: MediaQuery.of(context).size.width / 2 - 21,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'https://picsum.photos/360',
                    width: MediaQuery.of(context).size.width / 2 - 21,
                    height: MediaQuery.of(context).size.width / 2 - 21,
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 16, bottom: 8),
              child: Text(
                "미스터디유커피",
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              )),
          Row(
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
          Padding(padding: EdgeInsets.only(bottom: 8)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: SvgPicture.asset(
                        'assets/time.svg',
                        color: ChColors.black,
                        width: 16,
                        height: 16,
                      ),
                    ),
                    Text("10:00 ~ 17:30")
                  ],
                ),
              ),
              Expanded(
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
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(alignment: Alignment.bottomCenter, children: [
          NaverMap(
            initLocationTrackingMode: LocationTrackingMode.Follow,
            locationButtonEnable: true,
            onMapCreated: onMapCreated,
            mapType: _mapType,
          ),
          Container(
              alignment: Alignment.center,
              width: 100,
              height: 32,
              margin: EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Builder(builder: (context) {
                return TextButton(
                  child: Text("목록 보기"),
                  onPressed: () {
                    _showList(context);
                  },
                );
              }))
        ]),
      ),
    );
  }

  void onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }
}
