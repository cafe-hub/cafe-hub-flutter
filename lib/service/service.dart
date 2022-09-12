import 'dart:convert';
import 'dart:ffi';
import 'package:cafe_hub_flutter/common/network_util.dart';
import 'package:cafe_hub_flutter/model/data/cafe_info_response.dart';
import 'package:cafe_hub_flutter/model/data/response_wrapper.dart';
import 'package:http/http.dart' as http;
import '../model/presentation/cafe_info.dart';

class Service{
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
}