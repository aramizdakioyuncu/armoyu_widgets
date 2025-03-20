import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/core/widgets.dart';
import 'package:armoyu_widgets/data/models/Social/comment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';

class PostscommentControllerV2 extends GetxController {
  final ARMOYUServices service;
  final Comment comment;
  PostscommentControllerV2({required this.comment, required this.service});

  var likeButtonKey = GlobalKey<LikeButtonState>().obs;
  var likeunlikeProcces = false.obs;

  Rxn<Comment>? xcomment;
  @override
  void onInit() {
    super.onInit();

    xcomment = Rxn<Comment>(comment);

    var favoritestatus =
        const Icon(Icons.favorite_outline_rounded, color: Colors.grey, size: 20)
            .obs;
    if (xcomment!.value!.didIlike == true) {
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
    bool currentstatus = xcomment!.value!.didIlike;
    if (currentstatus) {
      xcomment!.value!.didIlike = false;
      xcomment!.value!.likeCount--;
    } else {
      xcomment!.value!.didIlike = true;
      xcomment!.value!.likeCount++;
    }

    if (!xcomment!.value!.didIlike) {
      PostCommentUnLikeResponse response = await service.postsServices
          .commentunlike(commentID: xcomment!.value!.commentID);

      if (!response.result.status) {
        log(response.result.description);
        if (currentstatus) {
          xcomment!.value!.likeCount--;
        } else {
          xcomment!.value!.likeCount++;
        }
        xcomment!.value!.didIlike = !xcomment!.value!.didIlike;
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
        xcomment!.value!.didIlike = !xcomment!.value!.didIlike;
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
    comment.didIlike = true;
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
    comment.didIlike = false;
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
