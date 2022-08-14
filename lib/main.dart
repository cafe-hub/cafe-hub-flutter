import 'package:cafe_hub_flutter/controller/SampleController.dart';
import 'package:cafe_hub_flutter/page/google_map.dart';
import 'package:cafe_hub_flutter/page/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'tteesstt',
      initialBinding: BindingsBuilder(() {
        Get.put(SampleController());
      }),
      routes: {
        '/home': (context) => const Home(),
        '/map': (context) => const MyGoogleMap()
      },
      initialRoute: '/map',
    );
  }
}
