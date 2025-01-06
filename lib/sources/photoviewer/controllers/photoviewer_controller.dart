import 'package:get/get.dart';

class PhotoviewerController extends GetxController {
  var isRotationedit = false.obs;
  var isRotationprocces = false.obs;
  Rx<double> mediaAngle = 0.0.obs;
  Rx<double> rotateangle = 0.0.obs;

  @override
  // ignore: unnecessary_overrides
  void onInit() {
    super.onInit();
  }
}
