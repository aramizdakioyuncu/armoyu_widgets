import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/post/post_detail.dart';
import 'package:armoyu_widgets/sources/card/widgets/card_widget.dart';
import 'package:armoyu_widgets/sources/postscomment/views/postcomment_view.dart';
import 'package:armoyu_widgets/sources/social/controllers/post_controller.dart';
import 'package:armoyu_widgets/translations/app_translation.dart';
import 'package:armoyu_widgets/widgets/text.dart';
import 'package:armoyu_widgets/widgets/utility.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:share_plus/share_plus.dart';

class PostWidget {
  static postWidget({
    required ARMOYUServices service,
    required Rx<APIPostList> postdetail,
    required PostController controller,
    required Function(int userID, String username) profileFunction,
    bool showTPcard = false,
    bool showPOPcard = false,
  }) {
    var likeButtonKey = GlobalKey<LikeButtonState>().obs;
    var likebutton = LikeButton(
      key: likeButtonKey.value,
      isLiked: postdetail.value.didilikeit == 1,
      likeCount: postdetail.value.likeCount,
      onTap: (isLiked) async =>
          await controller.postLike(isLiked, postdetail.value),
      likeBuilder: (bool isLiked) {
        return Icon(
          isLiked ? Icons.favorite : Icons.favorite_outline,
          color: isLiked ? Colors.red : Colors.grey,
          size: 25,
        );
      },
    ).obs;

    //Comment Button
    var postcommentIcon = const Icon(Icons.comment_outlined).obs;
    var postcommentColor = Colors.grey.obs;

    //Repost Button
    var postrepostIcon = const Icon(Icons.cyclone_outlined).obs;
    var postrepostColor = Colors.grey.obs;

    var messageController = TextEditingController().obs;

    if (postdetail.value.didicommentit == 1 ? true : false) {
      postcommentIcon.value = const Icon(Icons.comment);
      postcommentColor.value = Colors.blue;
    }

    if (postdetail.value.didicommentit == 1 ? true : false) {
      postrepostIcon.value = const Icon(Icons.cyclone);
      postrepostColor.value = Colors.green;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        double availableWidth = constraints.maxWidth;

        return Container(
          margin: const EdgeInsets.only(bottom: 1),
          decoration: BoxDecoration(
            color: Get.theme.scaffoldBackgroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: InkWell(
                  onTap: () {
                    profileFunction(
                      postdetail.value.postOwner.ownerID,
                      postdetail.value.postOwner.ownerURL.split('/')[4],
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => CircleAvatar(
                          backgroundColor: Colors.transparent,
                          foregroundImage: CachedNetworkImageProvider(
                            postdetail.value.postOwner.avatar.minURL,
                          ),
                          radius: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Obx(
                                  () => CustomText.costum1(
                                    postdetail.value.postOwner.displayName,
                                    size: 16,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Obx(
                                  () => postdetail.value.postdevice == "mobil"
                                      ? const Text("📱")
                                      : const Text("🌐"),
                                ),
                                const SizedBox(width: 5),
                                Obx(
                                  () => CustomText.costum1(
                                    postdetail.value.datecounting
                                        .replaceAll(
                                            'Saniye', CommonKeys.second.tr)
                                        .replaceAll(
                                            'Dakika', CommonKeys.minute.tr)
                                        .replaceAll('Saat', CommonKeys.hour.tr)
                                        .replaceAll('Gün', CommonKeys.day.tr)
                                        .replaceAll('Ay', CommonKeys.month.tr)
                                        .replaceAll('Yıl', CommonKeys.year.tr),
                                    weight: FontWeight.normal,
                                    color: Get.theme.primaryColor
                                        .withOpacity(0.69),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Obx(
                                  () => Visibility(
                                    visible: postdetail.value.location != null,
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          color: Colors.red,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 1),
                                        CustomText.costum1(
                                          postdetail.value.location.toString(),
                                          weight: FontWeight.normal,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              controller.postfeedback(postdetail.value);
                            },
                            icon: const Icon(Icons.more_vert),
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onDoubleTap: () {
                  if (!(postdetail.value.didilikeit == 1)) {
                    likeButtonKey.value.currentState?.onTap();
                    controller.postLike(true, postdetail.value);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          child: WidgetUtility.specialText(
                            context,
                            postdetail.value.content,
                            profileFunction: profileFunction,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onDoubleTap: () {
                  if (!(postdetail.value.didilikeit == 1)) {
                    likeButtonKey.value.currentState?.onTap();
                    controller.postLike(true, postdetail.value);
                  }
                },
                child: Obx(
                  () => Center(
                    child: controller.buildMediaContent(
                      context,
                      postdetail,
                      availableWidth,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Row(
                  children: [
                    InkWell(
                      onLongPress: () {
                        controller.showpostlikers(postdetail.value);
                      },
                      child: Obx(
                        () => likebutton.value,
                      ),
                    ),
                    const Spacer(),
                    Obx(
                      () => IconButton(
                        iconSize: 25,
                        icon: postcommentIcon.value,
                        color: postcommentColor.value,
                        onPressed: () => controller.postcomments(
                          postdetail.value,
                          messageController.value,
                          profileFunction: profileFunction,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Obx(
                      () => Text(
                        postdetail.value.commentCount.toString(),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    const Spacer(),
                    Obx(
                      () => IconButton(
                        iconSize: 25,
                        icon: postrepostIcon.value,
                        color: postrepostColor.value,
                        onPressed: () {},
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () async {
                        await Share.share(
                          'https://aramizdakioyuncu.com/?sosyal1=${postdetail.value.postID}',
                        );
                      },
                      icon: const Icon(Icons.share_outlined),
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: availableWidth,
                      child: Stack(
                        children: [
                          const SizedBox(height: 20),
                          ...List.generate(postdetail.value.firstlikers!.length,
                              (index) {
                            int left =
                                postdetail.value.firstlikers!.length * 10 -
                                    (index + 1) * 10;
                            return Obx(
                              () => Positioned(
                                left: double.parse(left.toString()),
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  foregroundImage: CachedNetworkImageProvider(
                                    postdetail
                                        .value
                                        .firstlikers![postdetail
                                                .value.firstlikers!.length -
                                            index -
                                            1]
                                        .likeravatar
                                        .minURL,
                                  ),
                                  radius: 10,
                                ),
                              ),
                            );
                          }),
                          Obx(
                            () => Positioned(
                              left: postdetail.value.firstlikers!.length * 10 +
                                  15,
                              child: postdetail.value.firstlikers!.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () => controller
                                          .showpostlikers(postdetail.value),
                                      child: Obx(
                                        () => WidgetUtility.specialText(
                                          context,
                                          "@${postdetail.value.firstlikers![0].likerusername.toString()}  ${(postdetail.value.likeCount - 1) <= 0 ? SocialKeys.socialLiked.tr : SocialKeys.socialandnumberpersonLiked.tr.replaceAll('#NUMBER#', "${postdetail.value.likeCount - 1}")}",
                                          profileFunction: profileFunction,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () => Column(
                        children: List.generate(
                            postdetail.value.firstcomments!.length, (index) {
                          return PostcommentView.commentlistv2(
                            context,
                            postdetail.value.firstcomments![index],
                            service,
                            profileFunction: profileFunction,
                          );
                        }),
                      ),
                    ),
                    Obx(
                      () => Visibility(
                        visible: postdetail.value.commentCount > 3,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () => controller.postcomments(
                              postdetail.value,
                              messageController.value,
                              profileFunction: profileFunction,
                            ),
                            child: CustomText.costum1(
                              "${postdetail.value.commentCount} ${SocialKeys.socialViewAllComments.tr}",
                              color: Get.theme.primaryColor.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              showPOPcard
                  ? CardWidget(service).cardWidget(
                      context: Get.context!,
                      title: CustomCardType.playerPOP,
                      content: [],
                      firstFetch: true,
                      profileFunction: profileFunction,
                    )
                  : const SizedBox.shrink(),
              showTPcard
                  ? CardWidget(service).cardWidget(
                      context: Get.context!,
                      title: CustomCardType.playerXP,
                      content: [],
                      firstFetch: true,
                      profileFunction: profileFunction,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }
}