import 'dart:async';

import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<NaverMapController> _controller = Completer();
  MapType _mapType = MapType.Basic;

  void _showList(BuildContext context) {
    showBottomSheet(context: context, builder: (context) {
      return Container(
        height: 200,
        width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white
          ),
          child: Text("바텀~~~ 시트~~~"));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
            children: [
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(16)
              ),
              child: Builder(
                builder: (context) {
                  return TextButton(
                    child: Text("목록 보기"),
                    onPressed: () {
                      _showList(context);
                    },
                  );
                }
              )
          )
        ]),
      ),
    );
  }

  void onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }
}
