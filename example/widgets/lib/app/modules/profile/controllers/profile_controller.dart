import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/services/app_service.dart';

class ProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Rxn<TabController> tabController = Rxn<TabController>();

  Rxn<Widget> widget1 = Rxn();
  Rxn<Widget> widget2 = Rxn();
  Rxn<Widget> widget3 = Rxn();

  @override
  void onInit() {
    super.onInit();
    tabController.value = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );

    widget1.value = AppService.widgets.social.posts(
      context: Get.context!,
      shrinkWrap: true,
      userID: 1,
      profileFunction: (userID, username) {},
    );

    widget2.value = AppService.widgets.gallery.mediaGallery(
      context: Get.context!,
    );

    widget3.value = AppService.widgets.social.posts(
      context: Get.context!,
      shrinkWrap: true,
      userID: 1,
      category: "etiketlenmis",
      profileFunction: (userID, username) {},
    );
  }
}
