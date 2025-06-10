import 'dart:math';
import 'dart:developer' as log;

import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/sources/videoplayer/videoplayer_bundle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PhotoviewerController extends GetxController {
  final ARMOYUServices service;
  final List<Media> media;
  final int initialIndex; // Başlangıçtaki fotoğrafin indexi
  PhotoviewerController({
    required this.service,
    required this.media,
    required this.initialIndex,
  });
  var isRotationedit = false.obs;
  var isRotationprocces = false.obs;
  Rx<double> mediaAngle = 0.0.obs;
  Rx<double> rotateangle = 0.0.obs;
  Rxn<List<Media>> rxmedia = Rxn();

  late PageController pageController;
  late RxInt currentIndex;
  User? currentUser;

  VideoplayerWidgetBundle? videoWidget;

  bool handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent &&
        (event.logicalKey == LogicalKeyboardKey.arrowRight)) {
      if (isRotationedit.value) return true;

      if (currentIndex.value >= rxmedia.value!.length - 1) return true;
      if (videoWidget != null) {
        videoWidget!.dispose();
        videoWidget == null;
      }
      if (currentIndex.value < media.length - 1) {
        currentIndex.value++;
        pageController.animateToPage(
          currentIndex.value,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        log.log("sağa geçildi: ${currentIndex.value}");
      }
      return true;
    }
    if (event is KeyDownEvent &&
        (event.logicalKey == LogicalKeyboardKey.arrowLeft)) {
      if (isRotationedit.value) return true;

      if (0 > currentIndex.value - 1) return true;
      if (videoWidget != null) {
        videoWidget!.dispose();
        videoWidget == null;
      }
      if (currentIndex.value > 0) {
        currentIndex.value--;
        pageController.animateToPage(
          currentIndex.value,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        log.log("sola geçildi: ${currentIndex.value}");
      }

      return true;
    }

    return false;
  }

  @override
  void onInit() {
    super.onInit();

    final findCurrentAccountController = Get.find<AccountUserController>();
    currentUser =
        findCurrentAccountController.currentUserAccounts.value.user.value;

    currentIndex = initialIndex.obs;
    rxmedia = Rxn(media);
    pageController = PageController(initialPage: initialIndex);
    HardwareKeyboard.instance.addHandler(handleKeyEvent);
  }

  @override
  void onClose() {
    super.onClose();
    HardwareKeyboard.instance.removeHandler(handleKeyEvent);

    if (videoWidget != null) {
      videoWidget!.dispose();
    }
  }

  turnleft() {
    mediaAngle.value -= pi / 2;
    rotateangle.value -= 90;
  }

  turnright() {
    mediaAngle += pi / 2;
    rotateangle += 90;
  }

  rotatefunction() async {
    if (isRotationprocces.value) {
      return;
    }
    isRotationprocces.value = true;

    MediaRotationResponse response = await service.mediaServices.rotation(
      mediaID: rxmedia.value![initialIndex].mediaID,
      rotate: 360 - (rotateangle % 360),
    );

    if (!response.result.status) {
      mediaAngle.value = 0;
      isRotationedit.value = false;
      isRotationprocces.value = false;
      return;
    }

    isRotationedit.value = false;
    isRotationprocces.value = false;
    response.result.descriptiondetail['media_bigURL'];
    response.result.descriptiondetail['media_URL'];
    response.result.descriptiondetail['media_minURL'];

    rxmedia.value![currentIndex.value].mediaURL.bigURL.value =
        response.result.descriptiondetail['media_bigURL'];
    rxmedia.value![currentIndex.value].mediaURL.normalURL.value =
        response.result.descriptiondetail['media_URL'];
    rxmedia.value![currentIndex.value].mediaURL.minURL.value =
        response.result.descriptiondetail['media_minURL'];

    mediaAngle.value = 0.0;
    rotateangle.value = 0.0;
  }
}
