import 'dart:async';

import 'package:cafe_hub_flutter/controller/home_controller.dart';
import 'package:cafe_hub_flutter/model/presentation/cafe_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:permission_handler/permission_handler.dart';

import '../common/ChColors.dart';
import 'detail.dart';

class Home extends StatefulWidget {
  final HomeController homeController;

  const Home({Key? key, required this.homeController}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<NaverMapController> _controller = Completer();
  MapType _mapType = MapType.Basic;

  //똑같은 Marker클릭시 다시 부르지 않기
  void _onMarkerTap(Marker? marker, Map<String, int?> iconSize) async {
    _showLocationInfo(
        mContext ?? context,
        await widget.homeController
            .getCafeDetailData(int.parse(marker!.markerId)));
  }

  //bottomSheet내려가게 하기
  void _onMapTap(LatLng latLng) {}

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
              child: Obx(
            () => Stack(alignment: Alignment.bottomCenter, children: [
              NaverMap(
                // initLocationTrackingMode: LocationTrackingMode.Follow,
                locationButtonEnable: true,
                onMapCreated: onMapCreated,
                mapType: _mapType,
                onCameraIdle: _refreshCafe,
                markers: widget.homeController.getMarkers(_onMarkerTap),
                onMapTap: _onMapTap,
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
          ));
        },
      ),
    );
  }

  void _showList(BuildContext context) {
    showBottomSheet(
      context: context,
      // isScrollControlled: true, // set this to true
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (_, controller) {
            return Container(
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: 24),
                itemCount: widget.homeController.cafes.length,
                controller: controller, // set this too
                itemBuilder: (_, i) => InkWell(
                  child: _listItem(widget.homeController.cafes[i]),
                  onTap: () => Get.to(() => Detail(
                      detailController: Get.find(),
                      cafeId: int.parse(widget.homeController.cafes[i].id))),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _listItem(CafeInfo cafeInfo) {
    double imageSize = MediaQuery.of(context).size.width / 2 - 21;

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
                    child: cafeInfo.photoUrls.isNotEmpty
                        ? Image.network(
                            cafeInfo.photoUrls[0],
                            width: imageSize,
                            height: imageSize,
                            fit: BoxFit.cover,
                          )
                        : Image(
                            image: AssetImage('assets/default_image.jpg'),
                            width: imageSize,
                            height: imageSize,
                          )),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: cafeInfo.photoUrls.length > 1
                      ? Image.network(
                          cafeInfo.photoUrls[1],
                          width: imageSize,
                          height: imageSize,
                          fit: BoxFit.cover,
                        )
                      : Image(
                          image: AssetImage('assets/default_image.jpg'),
                          width: imageSize,
                          height: imageSize,
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

  //코드 보고 리뷰한 다음 문제 없으면 아래 기존 함수 삭제 부탁
  void _showLocationInfo(BuildContext context, CafeInfo cafeInfo) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
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
            cafeInfo.name ?? "null",
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
          Text(cafeInfo.location ?? "null")
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
                Text(cafeInfo.plugStatus ?? "null")
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
        var camUpdate = CameraUpdate.toCameraPosition(
            //좌표 선정릉역
            CameraPosition(target: LatLng(37.510181246, 127.043505829)));
        value.moveCamera(camUpdate);
      });
    });
  }

  //지도에 보이는 영역만 카페를 다건조회하는 함수
  Future<List<int?>> _refreshCafe() async {
    var controller = await _controller.future;

    // //현재 카메라 중심 좌표를 반환
    // var cameraPositon = await controller.getCameraPosition();
    // double longitude = cameraPositon.target.longitude;
    // double latitude = cameraPositon.target.latitude;

    var visibleRegion = await controller.getVisibleRegion();

    var bottomRightLatitude = visibleRegion.southwest.latitude;
    var topLeftLatitude = visibleRegion.northeast.latitude;
    var topLeftLongitude = visibleRegion.southwest.longitude;
    var bottomRightLongitude = visibleRegion.northeast.longitude;

    widget.homeController.getCafes(topLeftLongitude, topLeftLatitude,
        bottomRightLongitude, bottomRightLatitude);

    return [1, 2, 3];
  }
}
