import 'dart:async';
import 'dart:convert';

import 'package:cafe_hub_flutter/controller/home_controller.dart';
import 'package:cafe_hub_flutter/model/presentation/cafe_info.dart';
import 'package:cafe_hub_flutter/service/cafe_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:permission_handler/permission_handler.dart';

import '../common/ChColors.dart';

class Home extends StatefulWidget {
  final HomeController homeController;

  const Home({Key? key, required this.homeController}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<NaverMapController> _controller = Completer();
  MapType _mapType = MapType.Basic;


  void _onMarkerTap(Marker? marker, Map<String, int?> iconSize) {
    _showLocationInfo(
        mContext ?? context,
        CafeInfo('123', '미스터디유커피', '인천 연수구 아카데미로 119', '10:30 ~ 17:30',[],
            '콘센트 많음', LatLng(37.4964860, 127.0283615), []));
  }

  BuildContext? mContext;

  @override
  void initState() {
    tryToRequestLocationPermission();
  }

  void tryToRequestLocationPermission() async {
    bool status = await Permission.location.isGranted;
    if (status == true) return;

    var permissionStatus = await Permission.location.request();
    if (permissionStatus == PermissionStatus.permanentlyDenied) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("위치 정보가 필요합니다."),
              content: TextButton(
                child: Text("설정"),
                onPressed: () {
                  openAppSettings();
                },
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          mContext = context;

          return SafeArea(
            child: Stack(alignment: Alignment.bottomCenter, children: [
              NaverMap(
                initLocationTrackingMode: LocationTrackingMode.Follow,
                locationButtonEnable: true,
                onMapCreated: onMapCreated,
                mapType: _mapType,
                onCameraIdle : _refreshCafe ,
                markers: widget.homeController.getMarkers(_onMarkerTap),
              ),
              Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        margin: EdgeInsets.only(left: 16),
                      ),
                      ButtonTheme(
                        minWidth: 100,
                        height: 32,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              side: BorderSide(
                                  width: 1,
                                  color: ChColors.gray100,
                                  style: BorderStyle.solid)),
                          child: Text(
                            "목록 보기",
                            style: TextStyle(color: ChColors.black),
                          ),
                          onPressed: () {
                            _showList(context);
                          },
                        ),
                      ),
                      Container(
                          height: 48,
                          width: 48,
                          padding: EdgeInsets.only(left: 2),
                          margin: EdgeInsets.only(bottom: 20, right: 16),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              side: BorderSide(
                                  width: 1,
                                  color: ChColors.gray100,
                                  style: BorderStyle.solid),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                            onPressed: () {
                              _moveToCafeArea();
                            },
                            child: SvgPicture.asset(
                              'assets/coffee.svg',
                              color: ChColors.black,
                              width: 24,
                              height: 24,
                            ),
                          ))
                    ],
                  )),
            ]),
          );
        },
      ),
    );
  }

  void _showList(BuildContext context) {
    showBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: SingleChildScrollView(
                child: Column(
                    children: widget.homeController.cafes
                        .map((e) => _listItem(e))
                        .toList()),
              ));
        });
  }

  Widget _listItem(CafeInfo cafeInfo) {
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
          ..._cafeInfo(cafeInfo)
        ],
      ),
    );
  }

  void _showLocationInfo(BuildContext context, CafeInfo cafeInfo) {
    showBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(children: _cafeInfo(cafeInfo))));
        });
  }

  List<Widget> _cafeInfo(CafeInfo cafeInfo) {
    return [
      Padding(
          padding: EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            cafeInfo.name!,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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
          Text(cafeInfo.location!)
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
                Text(cafeInfo.todayHours!)
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
                Text(cafeInfo.plugStatus!)
              ],
            ),
          )
        ],
      )
    ];
  }

  void onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }

  void _moveToCafeArea() {
    _controller.future.then((value) {
      setState(() {
        var camUpdate = CameraUpdate.toCameraPosition(CameraPosition(target: LatLng(37.4964860, 127.0283615)));
        value.moveCamera(camUpdate);
      });
    });
  }


  //사용자가 지도를 움직임에 따라, 지도의 중심 좌표를 반환하고, 그 중심 좌표를 기준으로 일정 영역 안의 카페를 다건 조회하여 불러오는 함수.
  //bottomRightLongitude > topLeftLongitude , topLeftLatitude > bottomRightLatitude
  void _refreshCafe() async {
    var controller = await _controller.future;
    var cameraPositon = await controller.getCameraPosition();
    double longitude = cameraPositon.target.longitude;
    double latitude = cameraPositon.target.latitude;

    print("ddddddddddddddddddddddddddddd ${longitude}, ${latitude}");
    String abc = "127.05/37.51/127.06/37.50";
    var fetchCafes = CafeService().fetchCafes(127.05,37.51,127.06,37.50);
    print("aaaaaaaaaaaaaaaaaaaaaaa $fetchCafes");
  }
}

