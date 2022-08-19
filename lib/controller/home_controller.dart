import 'package:get/get.dart' as getx;

class SampleController extends getx.GetxController {
  var count = 0.obs;

  void increment() {
    count++;
  }
}