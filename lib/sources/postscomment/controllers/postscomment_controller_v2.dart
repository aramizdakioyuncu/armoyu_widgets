import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/post/post_detail.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/core/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';

class PostscommentControllerV2 extends GetxController {
  final ARMOYUServices service;
  final APIPostComments comment;
  PostscommentControllerV2({required this.comment, required this.service});

  var likeButtonKey = GlobalKey<LikeButtonState>().obs;
  var likeunlikeProcces = false.obs;

  Rxn<APIPostComments>? xcomment;
  @override
  void onInit() {
    super.onInit();

    xcomment = Rxn<APIPostComments>(comment);

    var favoritestatus =
        const Icon(Icons.favorite_outline_rounded, color: Colors.grey, size: 20)
            .obs;
    if (xcomment!.value!.isLikedByMe == true) {
      favoritestatus.value = const Icon(
        Icons.favorite_rounded,
        color: Colors.red,
        size: 20,
      );
    } else {
      favoritestatus.value = const Icon(
        Icons.favorite_outline_rounded,
        color: Colors.grey,
        size: 20,
      );
    }
  }

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

  Future<void> likefunction(ARMOYUServices service) async {
    if (likeunlikeProcces.value) {
      return;
    }
    likeunlikeProcces.value = true;

    PostCommentLikeResponse response =
        await service.postsServices.commentlike(commentID: comment.commentID);
    if (!response.result.status) {
      log(response.result.description);
      likeunlikeProcces.value = false;

      return;
    }
    comment.likeCount++;
    comment.isLikedByMe = true;
    likeunlikeProcces.value = false;
  }

  Future<void> dislikefunction(ARMOYUServices service) async {
    if (likeunlikeProcces.value) {
      return;
    }
    likeunlikeProcces.value = true;

    PostCommentUnLikeResponse response =
        await service.postsServices.commentunlike(commentID: comment.commentID);
    if (!response.result.status) {
      log(response.result.description);
      likeunlikeProcces.value = false;

      return;
    }
    comment.likeCount--;
    comment.isLikedByMe = false;
    likeunlikeProcces.value = false;
  }

  Future<bool> postLike(bool isLiked, ARMOYUServices service) async {
    if (likeunlikeProcces.value) {
      return isLiked;
    }

    if (isLiked) {
      dislikefunction(service);
    } else {
      likefunction(service);
    }
    return !isLiked;
  }
}
