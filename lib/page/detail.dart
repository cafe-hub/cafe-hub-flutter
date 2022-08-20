import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  const Detail({Key? key}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Text("아무말"),
      );
  }

  AppBar appBar() {
    return AppBar(
        leading: const Icon(Icons.arrow_back_ios),
        iconTheme: const IconThemeData(
            color: Colors.black
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text("미스터디유커피",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        )
    );
  }
}
