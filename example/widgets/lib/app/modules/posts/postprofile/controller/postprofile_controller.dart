import 'dart:developer';

import 'package:armoyu_widgets/sources/social/bundle/posts_bundle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/services/app_service.dart';

class PostprofileController extends GetxController {
  var scrollController = ScrollController().obs;
  late PostsWidgetBundle posts;

  @override
  // ignore: unnecessary_overrides
  void onInit() {
    super.onInit();

    posts = AppService.widgets.social.posts(
      context: Get.context!,
      scrollController: scrollController.value,
      profileFunction: ({
        required avatar,
        required banner,
        required displayname,
        required userID,
        required username,
      }) {
        log('$userID $username');
      },
      userID: 1,
    );
  }
}
