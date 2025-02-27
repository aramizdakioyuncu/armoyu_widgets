import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  var apikeyController = TextEditingController().obs;
  var usernameController = TextEditingController().obs;
  var passcordController = TextEditingController().obs;

  var statusController = Rx<bool?>(null);
  var savestaus = false.obs;

  @override
  void onInit() {
    super.onInit();
    log("Wellcome ARMOYU WİDGETS MAIN");
  }
}
