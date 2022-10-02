import 'dart:async';

import 'package:cafe_hub_flutter/common/google_map_controller.dart';
import 'package:cafe_hub_flutter/controller/home_controller_google.dart';
import 'package:cafe_hub_flutter/model/presentation/cafe_info.dart';
import 'package:cafe_hub_flutter/service/member_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../common/ch_colors.dart';
import 'detail.dart';

class Home extends StatefulWidget {
  final HomeControllerGoogle homeController;

  const Home({Key? key, required this.homeController}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ChGoogleMapController _mapController = ChGoogleMapController();
  BuildContext? mContext;

  void _onMarkerTap(String markerId) async {
    widget.homeController.previousSelectedCafe?.isSelected.value = false;
    var target = widget.homeController.cafes
        .firstWhere((cafeInfo) => cafeInfo.id == markerId);
    target.isSelected.value = true;

    widget.homeController.previousSelectedCafe = target;

    _showLocationInfo(mContext ?? context, target);
  }

  @override
  void initState() {
    tryToRequestLocationPermission();
    MemberService().hit();
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
              title: Text("설정 화면으로 이동합니다."),
              content: Wrap(
                children: [
                  Column(
                      children: [
                        Text("GPS 를 이용하려면 위치 정보를 허용해야 합니다. 허용하지 않아도 앱 이용이 가능합니다."),
                        Padding(padding: EdgeInsets.only(bottom: 24)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              child: Text(
                                "취소",
                                style: TextStyle(color: ChColors.gray600),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                            TextButton(
                              child: Text(
                                "이동",
                                style: TextStyle(color: ChColors.primary),
                              ),
                              onPressed: () {
                                openAppSettings();
                              },
                            )
                          ],
                        )
                      ])
                ],
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          Scaffold.of(mContext ?? context).showBodyScrim(false, 0.0);

          return Future(() => true);
        },
        child: Builder(
          builder: (context) {
            mContext = context;
            MediaQueryData queryData = MediaQuery.of(context);
            widget.homeController.pixelRatio.value = queryData.devicePixelRatio;

            return SafeArea(
              child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [_mapWidget(), _bottomButtons()]),
            );
          },
        ),
      ),
    );
  }

  Widget _mapWidget() {
    return Obx(() => GoogleMap(
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          markers: widget.homeController.getMarkers(_onMarkerTap),
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(37.510181246, 127.043505829),
            zoom: 14.4746,
          ),
          onMapCreated: _mapController.onMapCreated,
          onCameraIdle: _mapController.onCameraPosition,
        ));
  }

  Widget _bottomButtons() {
    return Padding(
        padding: EdgeInsets.only(bottom: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                height: 48,
                width: 48,
                padding: EdgeInsets.only(left: 2),
                margin: EdgeInsets.only(bottom: 20, left: 16),
                child: ElevatedButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(ChColors.gray100),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
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
                )),
            Container(
              width: 100,
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
                  _showList(mContext ?? context);
                },
              ),
            ),
            Container(
              width: 48,
              height: 48,
              margin: EdgeInsets.only(right: 16),
            ),
          ],
        ));
  }

  void _showList(BuildContext context) {
    showBottomSheet(
      context: context,
      // isScrollControlled: true, // set this to true
      builder: (_) {
        return Stack(alignment: Alignment.bottomCenter, children: [
          DraggableScrollableSheet(
            expand: false,
            builder: (_, controller) {
              return Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: widget.homeController.cafes.isNotEmpty
                    ? ListView.builder(
                        padding: EdgeInsets.only(bottom: 24),
                        itemCount: widget.homeController.cafes.length,
                        controller: controller, // set this too
                        itemBuilder: (_, i) => InkWell(
                          child: _listItem(widget.homeController.cafes[i]),
                          onTap: () => Get.to(() => Detail(
                              detailController: Get.find(),
                              cafeId: int.parse(
                                  widget.homeController.cafes[i].id))),
                        ),
                      )
                    : Text("해당 지역에 등록된 카페가 없어요..."),
              );
            },
          ),
          Container(
            margin: EdgeInsets.only(bottom: 24),
            width: 100,
            height: 32,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ChColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                widget.homeController.cafes.isNotEmpty ? "지도 보기" : "지도 이동",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Scaffold.of(mContext ?? context).showBodyScrim(false, 0.0);
                Get.back();
                if (widget.homeController.cafes.isEmpty) _moveToCafeArea();
              },
            ),
          )
        ]);
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
                        ? _cafeImage(cafeInfo.photoUrls[0], imageSize)
                        : _defaultImage(imageSize)),
                ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: cafeInfo.photoUrls.length > 1
                        ? _cafeImage(cafeInfo.photoUrls[1], imageSize)
                        : _defaultImage(imageSize)),
              ],
            ),
          ),
          ..._cafeInfo(cafeInfo)
        ],
      ),
    );
  }

  Widget _cafeImage(String imageUrl, double imageSize) {
    return Image.network(imageUrl,
        width: imageSize,
        height: imageSize,
        fit: BoxFit.cover,
        errorBuilder: (context, exception, stackTrace) =>
            _imageError(context, exception, stackTrace, imageSize),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          return Container(
            width: imageSize,
            height: imageSize,
            padding: EdgeInsets.all(48),
            child: CircularProgressIndicator(
              color: ChColors.primary,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        });
  }

  Widget _defaultImage(double imageSize) {
    return Image(
      image: AssetImage('assets/default_image.jpg'),
      width: imageSize,
      height: imageSize,
    );
  }

  Widget _imageError(BuildContext context, Object exception,
      StackTrace? stackTrace, double imageSize) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(20),
      width: imageSize,
      height: imageSize,
      child: Text("이미지를 가져오는데 실패했어요 ㅠㅠ"),
    );
  }

  //코드 보고 리뷰한 다음 문제 없으면 아래 기존 함수 삭제 부탁
  void _showLocationInfo(BuildContext context, CafeInfo cafeInfo) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        ),
        context: context,
        builder: (BuildContext context) {
          return InkWell(
            onTap: () => Get.to(() => Detail(
                detailController: Get.find(), cafeId: int.parse(cafeInfo.id))),
            child: Container(
                height: 144,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(children: _cafeInfo(cafeInfo)))),
          );
        });
  }

  List<Widget> _cafeInfo(CafeInfo cafeInfo) {
    var plugStatus = cafeInfo.plugStatus;
    var plugInfoText = "null";

    if (plugStatus == "null") plugInfoText = "콘센트 정보 없음";
    if (plugStatus == "many") plugInfoText = "콘센트 많음";

    return [
      Padding(
          padding: EdgeInsets.only(top: 24, bottom: 20),
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
                Text(cafeInfo.todayHours)
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
                Text(plugInfoText)
              ],
            ),
          )
        ],
      )
    ];
  }

  void _moveToCafeArea() {
    //좌표 선정릉역
    _mapController.toCameraPosition(37.510181246, 127.043505829);
  }
}
