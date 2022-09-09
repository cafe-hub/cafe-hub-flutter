import 'package:http/http.dart' as http;
import 'model/presentation/cafe_info.dart';

class Services{
  static var client = http.Client();

  static Future<List<CafeInfo>?> fetchCafes() async{
    var response = await client.get(Uri.parse('_'));

    if(response.statusCode == 200){
      var jsonData = response.body;
      print('api연결 성공');
      //return으로 api에서 가져온 카페 데이터 처리 해주시~~
    }else{
      print('연결 실패~~');
      return null;
    }
  }
}