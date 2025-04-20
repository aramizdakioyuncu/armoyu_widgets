import 'dart:developer';

import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/sources/gallery/bundle/gallery_bundle.dart';
import 'package:armoyu_widgets/sources/social/bundle/posts_bundle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/services/app_service.dart';

class ProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  // Rxn<Widget> widget1 = Rxn();
  late PostsWidgetBundle posts1;

  Rxn<GalleryWidgetBundle> widget2 = Rxn();
  // Rxn<Widget> widget3 = Rxn();
  late PostsWidgetBundle posts3;

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

    posts1 = AppService.widgets.social.posts(
      context: Get.context!,
      shrinkWrap: true,
      userID: 1,
      // userID: currentUserAccounts.value.user.value.userID,
      // sliverWidget: true,
      refreshPosts: () {},

      profileFunction: ({
        required avatar,
        required banner,
        required displayname,
        required userID,
        required username,
      }) {},
    );

    widget2.value = AppService.widgets.gallery.mediaGallery(
      context: Get.context!,
    );

    posts3 = AppService.widgets.social.posts(
      context: Get.context!,
      shrinkWrap: true,
      userID: 1,
      // userID: currentUserAccounts.value.user.value.userID,
      category: "etiketlenmis",
      profileFunction: ({
        required avatar,
        required banner,
        required displayname,
        required userID,
        required username,
      }) {},
    );
  }
}
