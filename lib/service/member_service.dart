import 'package:cafe_hub_flutter/common/network_util.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class MemberService {
  var client = http.Client();

  void hit() async {
    final prefs = await SharedPreferences.getInstance();

    final String? storedUuid = prefs.getString('deviceUuid');
    var uuid = storedUuid ?? Uuid().v4();
    print("으응 ${uuid}");

    await prefs.setString('deviceUuid', uuid);

    client.post(Uri.parse("${NetworkUtil.baseUrl}/member/$uuid"));
  }
}
