import 'dart:async';
import 'dart:developer';

import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/translations/app_translation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SourceChatcallController extends GetxController {
  late Rxn<UserAccounts> currentUserAccounts = Rxn<UserAccounts>();

  var player = AudioPlayer().obs;

  var chatsearchprocess = false.obs;
  var iconsColor = Colors.white.obs;
  var iconsbgColor = Colors.grey.shade700.obs;
  var callingtext = "".obs;
  var stopwatch = Stopwatch().obs;
  Timer? timer;
//Mic
  // Stream<Uint8List>? stream;
  Stream<List<int>>? stream;
  // late StreamSubscription listener;
//Mic

  var micMute = false.obs;
  var micIcon = Icons.mic.obs;
  @override
  void onInit() {
    super.onInit();

    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");

    /////
    currentUserAccounts.value =
        findCurrentAccountController.currentUserAccounts.value;
    /////
    callingtext.value = "${CommonKeys.calling.tr}...";
    stopwatch.value.start();

    // Timer ile süreyi düzenli olarak güncelle
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      stopwatch.refresh();
    });
  }

  @override
  void onClose() {
    stopwatch.value.stop();
    player.value.dispose(); // Timer'ı temizle
    super.onClose();
  }

  String formatTime(int milliseconds) {
    int seconds = (milliseconds / 1000).truncate() % 60;
    int minutes = (milliseconds / 60000).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr';
  }
}
