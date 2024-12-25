import 'dart:developer';

import 'package:armoyu_widgets/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageFunctions {
  void pushProfilePage(BuildContext context, User userProfile,
      {bool ismyProfile = false}) {
    final findCurrentAccountController = Get.find<AccountUserController>();
    User currentUser =
        findCurrentAccountController.currentUserAccounts.value.user.value;
    if (!ismyProfile &&
        (userProfile.userID == currentUser.userID ||
            userProfile.userName == currentUser.userName)) {
      log("Kendi Profiline girmezsin!");
      return;
    }

    Get.toNamed(
      "/profile/${userProfile.userID ?? userProfile.userName}",
      arguments: {"profileUser": userProfile, "currentUser": currentUser},
    );
  }
}
