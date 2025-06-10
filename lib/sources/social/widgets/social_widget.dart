import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/Social/post.dart';
import 'package:armoyu_widgets/data/models/Story/storylist.dart';
import 'package:armoyu_widgets/sources/social/bundle/postcreate_bundle.dart';
import 'package:armoyu_widgets/sources/social/bundle/posts_bundle.dart';
import 'package:armoyu_widgets/sources/social/bundle/story_bundle.dart';
import 'package:armoyu_widgets/sources/social/widgets/social_postcreate.dart';
import 'package:armoyu_widgets/sources/social/widgets/social_posts.dart';
import 'package:armoyu_widgets/sources/social/widgets/social_story.dart';
import 'package:flutter/material.dart';

class SocialWidget {
  final ARMOYUServices service;

  const SocialWidget(this.service);

  PostsWidgetBundle posts({
    Key? key,
    required BuildContext context,
    required Function({
      required int userID,
      required String username,
      required String? displayname,
      required Media? avatar,
      required Media? banner,
    }) profileFunction,
    ScrollController? scrollController,
    List<Post>? cachedpostsList,
    Function(List<Post> updatedPosts)? onPostsUpdated,
    Function? refreshPosts,
    bool isPostdetail = false,
    String? category,
    int? userID,
    String? username,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
    ScrollPhysics physics = const ClampingScrollPhysics(),
    bool sliverWidget = false,
    bool autofetchposts = true,
  }) {
    return widgetSocialPosts(
      service,
      context: context,
      key: key,
      profileFunction: profileFunction,
      autofetchposts: autofetchposts,
      cachedpostsList: cachedpostsList,
      category: category,
      isPostdetail: isPostdetail,
      onPostsUpdated: onPostsUpdated,
      padding: padding,
      physics: physics,
      refreshPosts: refreshPosts,
      scrollController: scrollController,
      shrinkWrap: shrinkWrap,
      sliverWidget: sliverWidget,
      userID: userID,
      username: username,
    );
  }

  StoryWidgetBundle widgetStorycircle({
    List<StoryList>? cachedStoryList,
    Function(List<StoryList> updatedStories)? onStoryUpdated,
  }) {
    return widgetSocialStory(
      service,
      cachedStoryList: cachedStoryList,
      onStoryUpdated: onStoryUpdated,
    );
  }

  PostcreateWidgetBundle postcreate() {
    return widgetPostcreate(service);
  }
}
