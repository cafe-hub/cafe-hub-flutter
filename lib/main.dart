import 'package:cafe_hub_flutter/page/detail.dart';
import 'package:cafe_hub_flutter/page/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Naver Map',
      home: NaverMapTest(),
    );
  }
}

class NaverMapTest extends StatefulWidget {
  @override
  _NaverMapTestState createState() => _NaverMapTestState();
}

class _NaverMapTestState extends State<NaverMapTest> {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'test',
      routes: {
        '/home': (context) => const Home(),
        '/detail': (context) => const Detail()
      },
      initialRoute: '/detail',
    );
  }
}