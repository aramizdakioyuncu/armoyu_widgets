import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/post/post_detail.dart';
import 'package:armoyu_widgets/core/widgets.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/Social/comment.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/sources/postscomment/controllers/postscomment_controller.dart';
import 'package:armoyu_widgets/sources/postscomment/controllers/postscomment_controller_v2.dart';
import 'package:armoyu_widgets/widgets/post_comments/post_comments_controller.dart';
import 'package:armoyu_widgets/widgets/post_comments/post_comments_controller_v2.dart';
import 'package:armoyu_widgets/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';

class PostcommentView {
  static Widget commentlistv2(
    BuildContext context,
    Comment comment,
    ARMOYUServices service, {
    required Function({
      required int userID,
      required String username,
      User? user,
    }) profileFunction,
  }) {
    String uniqueTag = DateTime.now().millisecondsSinceEpoch.toString();

    final controller = Get.put(
      PostscommentControllerV2(comment: comment, service: service),
      tag: "${comment.commentID}-$uniqueTag",
    );
    return GestureDetector(
      onDoubleTap: () {
        controller.likeButtonKey.value.currentState?.onTap();
      },
      child: Container(
        color: Get.theme.scaffoldBackgroundColor,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText.usercomments(
                    context,
                    text: controller.comment.content,
                    user: User(
                      userID: controller.comment.user.userID,
                      displayName: Rx(
                        controller.comment.user.displayName!.value,
                      ),
                      avatar: Media(
                        mediaID: 0,
                        mediaURL: MediaURL(
                          bigURL: Rx(
                            controller
                                .comment.user.avatar!.mediaURL.bigURL.value,
                          ),
                          normalURL: Rx(
                            controller
                                .comment.user.avatar!.mediaURL.normalURL.value,
                          ),
                          minURL: Rx(
                            controller
                                .comment.user.avatar!.mediaURL.minURL.value,
                          ),
                        ),
                      ),
                    ),
                    profileFunction: profileFunction,
                  ),
                ],
              ),
            ),
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(4.0),
                child: LikeButton(
                  key: controller.likeButtonKey.value,
                  isLiked: controller.comment.didIlike,
                  likeCount: controller.comment.likeCount,
                  onTap: (isLiked) async =>
                      await controller.postLike(isLiked, service),
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      isLiked ? Icons.favorite : Icons.favorite_outline,
                      color: isLiked ? Colors.red : Colors.grey,
                      size: 15,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget postCommentsWidgetV2(
      BuildContext context, ARMOYUServices service, APIPostComments comment,
      {required Function deleteFunction, required Function profileFunction}) {
    final controller = Get.put(
        PostCommentsControllerV2(comment: comment, service: service),
        tag: comment.commentID.toString());

    final findCurrentAccountController = Get.find<AccountUserController>();

    return Obx(
      () => ListTile(
        minLeadingWidth: 1.0,
        minVerticalPadding: 5.0,
        contentPadding: const EdgeInsets.all(0),
        leading: SizedBox(
          height: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  profileFunction(
                    controller.xcomment!.value!.postcommenter.userID,
                    controller.xcomment!.value!.postcommenter.username,
                  );
                },
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  foregroundImage: CachedNetworkImageProvider(
                    controller.xcomment!.value!.postcommenter.avatar.minURL,
                  ),
                  radius: 20,
                ),
              ),
            ],
          ),
        ),
        title: Text(controller.xcomment!.value!.postcommenter.displayname),
        subtitle: Text(controller.xcomment!.value!.commentContent),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                await controller.likeunlikefunction();
              },
              child: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    controller.favoritestatus,
                    const SizedBox(height: 3),
                    CustomText.costum1(
                      controller.xcomment!.value!.likeCount.toString(),
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => Visibility(
                visible: findCurrentAccountController
                        .currentUserAccounts.value.user.value.userID ==
                    controller.xcomment!.value!.postcommenter.userID,
                child: IconButton(
                  onPressed: () async => ARMOYUWidget.showConfirmationDialog(
                    context,
                    accept: () {
                      controller.removeComment(deleteFunction);
                    },
                  ),
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget commentlist(
    BuildContext context,
    Comment comment,
    ARMOYUServices service, {
    required Function({
      required int userID,
      required String username,
      User? user,
    }) profileFunction,
  }) {
    final controller = Get.put(
        PostscommentController(comment: comment, service: service),
        tag: comment.commentID.toString());
    return GestureDetector(
      onDoubleTap: () {
        controller.likeButtonKey.value.currentState?.onTap();
      },
      child: Container(
        color: Get.theme.scaffoldBackgroundColor,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText.usercomments(
                    context,
                    text: controller.comment.content,
                    user: controller.comment.user,
                    profileFunction: profileFunction,
                  ),
                ],
              ),
            ),
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(4.0),
                child: LikeButton(
                  key: controller.likeButtonKey.value,
                  isLiked: controller.comment.didIlike,
                  likeCount: controller.comment.likeCount,
                  onTap: (isLiked) async =>
                      await controller.postLike(isLiked, service),
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      isLiked ? Icons.favorite : Icons.favorite_outline,
                      color: isLiked ? Colors.red : Colors.grey,
                      size: 15,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget postCommentsWidget(
      BuildContext context, ARMOYUServices service, Comment comment,
      {required Function deleteFunction, required Function profileFunction}) {
    final controller = Get.put(
        PostCommentsController(comment: comment, service: service),
        tag: comment.commentID.toString());

    final findCurrentAccountController = Get.find<AccountUserController>();

    return Obx(
      () => ListTile(
        minLeadingWidth: 1.0,
        minVerticalPadding: 5.0,
        contentPadding: const EdgeInsets.all(0),
        leading: SizedBox(
          height: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  profileFunction();
                },
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  foregroundImage: CachedNetworkImageProvider(
                    controller
                        .xcomment!.value!.user.avatar!.mediaURL.minURL.value,
                  ),
                  radius: 20,
                ),
              ),
            ],
          ),
        ),
        title: Text(controller.xcomment!.value!.user.displayName!.value),
        subtitle: Text(controller.xcomment!.value!.content),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                await controller.likeunlikefunction();
              },
              child: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    controller.favoritestatus,
                    const SizedBox(height: 3),
                    CustomText.costum1(
                      controller.xcomment!.value!.likeCount.toString(),
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => Visibility(
                visible: findCurrentAccountController
                        .currentUserAccounts.value.user.value.userID ==
                    controller.xcomment!.value!.user.userID,
                child: IconButton(
                  onPressed: () async => ARMOYUWidget.showConfirmationDialog(
                    context,
                    accept: () {
                      controller.removeComment(deleteFunction);
                    },
                  ),
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
