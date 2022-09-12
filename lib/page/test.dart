import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  bool _bottomSheetVisibility = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        Builder(
          builder: (context) => SafeArea(
            child: Stack(
              children: [
                TextButton(onPressed: () {
                  showBottomSheet(
                      context: context,
                      builder: (context) {
                        return SizedBox.expand(
                          child: DraggableScrollableSheet(
                              builder: (context, scrollController) {
                                return Container(
                                    color: Colors.blue[100],
                                    child: ListView.builder(
                                        controller: scrollController,
                                        itemCount: 10,
                                        itemBuilder: (BuildContext context, int index) {
                                          return ListTile(
                                            title: Text("item $index"),
                                          );
                                        }));
                              }),
                        );
                      });
                }, child: Text("요 버튼을 누르거라")),
              ],
            ),
          ),
        ),
    );
  }
}
