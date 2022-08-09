import 'package:get/get.dart' as getx;

class SampleController extends getx.GetxController {
  var count = 10.obs;

  void increment() {
    count++;
  }
}