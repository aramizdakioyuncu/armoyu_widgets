import 'dart:developer';

import 'package:armoyu_services/core/models/ARMOYU/API/post/post_detail.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/Social/comment.dart';
import 'package:armoyu_widgets/data/models/Social/like.dart';
import 'package:armoyu_widgets/data/models/Social/post.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/services/app_service.dart';

class PostsController extends GetxController {
  Rxn<List<Widget>> postsList = Rxn<List<Widget>>(null);
  var postscount = 1.obs;
  var postsProccess = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchsocailposts();
  }

  Future<void> fetchsocailposts() async {
    if (postsProccess.value) {
      return;
    }
    postsProccess.value = true;

    PostFetchListResponse response =
        await AppService.service.postsServices.getPosts(page: postscount.value);

    if (!response.result.status) {
      postsProccess.value = false;
      return;
    }

    postsList.value ??= [];
    for (APIPostList element in response.response!) {
      postsList.value!.add(
        AppService.widgets.social.postWidget(
          Get.context!,
          profileFunction: () {
            log(element.postID.toString());
          },
          post: Post(
            postID: element.postID,
            content: element.content,
            postDate: element.date,
            sharedDevice: element.postdevice,
            likesCount: element.likeCount,
            isLikeme: element.didilikeit == 1 ? true : false,
            commentsCount: element.commentCount,
            iscommentMe: element.didicommentit == 1 ? true : false,
            owner: User(
              userID: element.postOwner.ownerID,
              displayName: Rx(element.postOwner.displayName),
              userName: Rx(element.postOwner.displayName),
              avatar: Media(
                mediaID: 0,
                mediaURL: MediaURL(
                  bigURL: Rx(element.postOwner.avatar.bigURL),
                  normalURL: Rx(element.postOwner.avatar.normalURL),
                  minURL: Rx(element.postOwner.avatar.minURL),
                ),
              ),
            ),
            media: element.media!
                .map(
                  (e) => Media(
                    mediaID: 0,
                    mediaURL: MediaURL(
                      bigURL: Rx(e.mediaURL.bigURL),
                      normalURL: Rx(e.mediaURL.normalURL),
                      minURL: Rx(e.mediaURL.minURL),
                    ),
                    mediaType: e.mediaType,
                  ),
                )
                .toList(),
            firstthreecomment: element.firstcomments!
                .map(
                  (e) => Comment(
                    postID: e.postID,
                    commentID: e.commentID,
                    content: e.commentContent,
                    date: e.commentTime,
                    didIlike: e.isLikedByMe,
                    likeCount: e.likeCount,
                    user: User(
                      userID: e.postcommenter.userID,
                      userName: Rx(e.postcommenter.mention),
                      displayName: Rx(e.postcommenter.displayname),
                      avatar: Media(
                        mediaID: 0,
                        mediaURL: MediaURL(
                          bigURL: Rx(e.postcommenter.avatar.bigURL),
                          normalURL: Rx(e.postcommenter.avatar.normalURL),
                          minURL: Rx(e.postcommenter.avatar.minURL),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
            firstthreelike: element.firstlikers!
                .map(
                  (e) => Like(
                    likeID: e.postlikeID,
                    date: e.likedate,
                    user: User(
                      userID: e.likerID,
                      userName: Rx(e.likerusername),
                      displayName: Rx(e.likerdisplayname),
                      avatar: Media(
                        mediaID: 0,
                        mediaURL: MediaURL(
                          bigURL: Rx(e.likeravatar.bigURL),
                          normalURL: Rx(e.likeravatar.normalURL),
                          minURL: Rx(e.likeravatar.minURL),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
            location: element.location,
          ),
          isPostdetail: false,
        ),
      );
    }
    postsList.refresh();
    postsProccess.value = false;
  }
}
