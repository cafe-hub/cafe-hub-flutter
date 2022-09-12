import 'dart:convert';
import 'dart:ffi';
import 'package:cafe_hub_flutter/common/network_util.dart';
import 'package:cafe_hub_flutter/model/data/cafe_info_response.dart';
import 'package:cafe_hub_flutter/model/data/response_wrapper.dart';
import 'package:http/http.dart' as http;
import '../model/presentation/cafe_info.dart';

class CafeService{
  var client = http.Client();

  Future<CafeInfo?> fetchCafe(int id) async{
    var response = await client.get(Uri.parse("${NetworkUtil.baseUrl}/cafe/$id"));

    if(response.statusCode == 200) {
      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      var data = ResponseWrapper.fromJson(jsonData).data;
      var res = CafeInfoResponse.fromJson(data);

      return res.toEntity();
    }else{
      print('연결 실패~~');
      return null;
    }
  }

  //좌표 정보들을 넘겨 줘서 cafeInfo를 리스트 형태로 받아야 함.
  Future<List<CafeInfo>?> fetchCafes(double topLeftLongitude, double topLeftLatitude, double bottomRightLongitude, double bottomRightLatitude) async{

    var response = await client.get(Uri.parse("${NetworkUtil.baseUrl}/cafes/$topLeftLongitude/$topLeftLatitude/$bottomRightLongitude/$bottomRightLatitude"));

    if(response.statusCode == 200) {
      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      var data = ResponseWrapper.fromJson(jsonData).data as List;
      var res = data.map<CafeInfoResponse>((e) => CafeInfoResponse.fromJson(e)).toList();

      var result = res.map((e) => e.toEntity()).toList();
      return result;
    }else if(response.statusCode == 204){
      print("조회되는 카페 없음");
      return null;
    }else{
      print('연결 실패~~');
      return null;
    }
  }

}