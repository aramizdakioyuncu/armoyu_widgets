import 'dart:developer';

import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/services/app_service.dart';

class ProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  Rxn<Widget> widget1 = Rxn();
  Rxn<Widget> widget2 = Rxn();
  Rxn<Widget> widget3 = Rxn();

  var currentUserAccounts = Rx<UserAccounts>(
    UserAccounts(
      user: User().obs,
      sessionTOKEN: Rx(""),
      language: Rxn(),
    ),
  );

  @override
  void onInit() {
    super.onInit();

    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");

    /////
    currentUserAccounts.value =
        findCurrentAccountController.currentUserAccounts.value;
    /////
    ///
    tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );

    widget1.value = AppService.widgets.social.posts(
      context: Get.context!,
      shrinkWrap: true,
      userID: 1,
      // userID: currentUserAccounts.value.user.value.userID,
      sliverWidget: true,
      refreshPosts: () {},

      profileFunction: ({user, required userID, required username}) {},
    );

    widget2.value = AppService.widgets.gallery.mediaGallery(
      context: Get.context!,
    );

    widget3.value = AppService.widgets.social.posts(
      context: Get.context!,
      shrinkWrap: true,
      userID: 1,
      // userID: currentUserAccounts.value.user.value.userID,
      category: "etiketlenmis",
      profileFunction: ({user, required userID, required username}) {},
    );
  }
}
