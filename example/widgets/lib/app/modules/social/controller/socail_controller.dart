import 'dart:developer';

import 'package:armoyu_widgets/sources/social/bundle/posts_bundle.dart';
import 'package:armoyu_widgets/sources/social/bundle/story_bundle.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/services/app_service.dart';

class SocailController extends GetxController {
  var scrollController = ScrollController();

  late PostsWidgetBundle posts;
  late StoryWidgetBundle storyies;
  @override
  void onInit() {
    super.onInit();

    posts = AppService.widgets.social.posts(
      context: Get.context!,
      scrollController: scrollController,
      onPostsUpdated: (updatedPosts) {
        log('Posts updated: ${updatedPosts.length}');
      },
      shrinkWrap: true,
      autofetchposts: false,
      cachedpostsList: AppService
          .widgets.accountController.currentUserAccounts.value.widgetPosts,
      profileFunction: ({
        required avatar,
        required banner,
        required displayname,
        required userID,
        required username,
      }) {
        log('$userID $username');
      },
    );

    storyies = AppService.widgets.social.widgetStorycircle(
      onStoryUpdated: (updatedStories) {
        log('Story updated: ${updatedStories.length}');
      },
      cachedStoryList: AppService.widgets.accountController.currentUserAccounts
          .value.widgetStoriescard,
    );
  }
}
