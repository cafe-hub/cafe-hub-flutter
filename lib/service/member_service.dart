import 'dart:convert';

import 'package:cafe_hub_flutter/common/network_util.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class MemberService {
  var client = http.Client();

  void hit() async {
    final prefs = await SharedPreferences.getInstance();

    final String? storedUuid = prefs.getString('deviceUuid');
    var uuid = storedUuid ?? Uuid().v4();

    print("deviceUuid $uuid");
    await prefs.setString('deviceUuid', uuid);

    var logger = Logger();
    var url = '${NetworkUtil.baseUrl}/member/$uuid';
    http.Response res = await client.get(Uri.parse(url));
    var body = utf8.decode(res.bodyBytes);
    logger.log(Level.debug, 'response $url ${res.headers} ${body}');
  }
}
