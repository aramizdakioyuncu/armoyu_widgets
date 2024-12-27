import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/core/widgets.dart';
import 'package:armoyu_widgets/data/models/Social/comment.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/functions/page_functions.dart';
import 'package:armoyu_widgets/sources/postscomment/controllers/postscomment_controller.dart';
import 'package:armoyu_widgets/widgets/post_comments/post_comments_controller.dart';
import 'package:armoyu_widgets/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';

class PostcommentView {
  static Widget commentlist(BuildContext context, Comment comment,
      Function setstatefunction, ARMOYUServices service) {
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
                  onTap: (isLiked) async => await controller.postLike(
                      isLiked, setstatefunction, service),
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
      {required Function deleteFunction}) {
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
                  PageFunctions functions = PageFunctions();
                  functions.pushProfilePage(
                    context,
                    User(userID: controller.xcomment!.value!.user.userID),
                  );
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
