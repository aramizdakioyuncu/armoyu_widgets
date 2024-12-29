import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/post/post_detail.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/core/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostCommentsControllerV2 extends GetxController {
  final ARMOYUServices service;

  final APIPostComments comment;
  PostCommentsControllerV2({required this.comment, required this.service});

  Rxn<APIPostComments>? xcomment;
  @override
  void onInit() {
    super.onInit();

    xcomment = Rxn<APIPostComments>(comment);

    if (xcomment!.value!.isLikedByMe == true) {
      favoritestatus = const Icon(
        Icons.favorite_rounded,
        color: Colors.red,
        size: 20,
      );
    } else {
      favoritestatus = const Icon(
        Icons.favorite_outline_rounded,
        color: Colors.grey,
        size: 20,
      );
    }
  }

  Icon favoritestatus =
      const Icon(Icons.favorite_outline_rounded, color: Colors.grey, size: 20);

  Future<void> removeComment(Function deleteFunction) async {
    PostRemoveCommentResponse response = await service.postsServices
        .removecomment(commentID: xcomment!.value!.commentID);
    ARMOYUWidget.toastNotification(response.result.description.toString());

    if (!response.result.status) {
      return;
    }

    deleteFunction();
  }

  Future<void> likeunlikefunction() async {
    bool currentstatus = xcomment!.value!.isLikedByMe;
    if (currentstatus) {
      xcomment!.value!.isLikedByMe = false;
      xcomment!.value!.likeCount--;
    } else {
      xcomment!.value!.isLikedByMe = true;
      xcomment!.value!.likeCount++;
    }

    if (!xcomment!.value!.isLikedByMe) {
      PostCommentUnLikeResponse response = await service.postsServices
          .commentunlike(commentID: xcomment!.value!.commentID);

      if (!response.result.status) {
        log(response.result.description);
        if (currentstatus) {
          xcomment!.value!.likeCount--;
        } else {
          xcomment!.value!.likeCount++;
        }
        xcomment!.value!.isLikedByMe = !xcomment!.value!.isLikedByMe;
        return;
      }
    } else {
      PostCommentLikeResponse response = await service.postsServices
          .commentlike(commentID: xcomment!.value!.commentID);

      if (!response.result.status) {
        log(response.result.description);
        if (currentstatus) {
          xcomment!.value!.likeCount--;
        } else {
          xcomment!.value!.likeCount++;
        }
        xcomment!.value!.isLikedByMe = !xcomment!.value!.isLikedByMe;
        return;
      }
    }
  }
}
