import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  var apikeyController = TextEditingController().obs;
  var usernameController = TextEditingController().obs;
  var passcordController = TextEditingController().obs;

  var statusController = false.obs;
  var savestaus = false.obs;

  var firstfetch = false.obs;

  @override
  void onInit() {
    super.onInit();
    log("Wellcome ARMOYU WİDGETS MAIN");
  }
}
