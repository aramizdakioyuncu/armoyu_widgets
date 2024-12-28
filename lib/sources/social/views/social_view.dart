import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/data/models/Story/storylist.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/data/models/Social/post.dart';
import 'package:armoyu_widgets/sources/Story/story_screen_page/views/story_screen_view.dart';
import 'package:armoyu_widgets/sources/postscomment/views/postcomment_view.dart';
import 'package:armoyu_widgets/translations/app_translation.dart';
import 'package:armoyu_widgets/sources/social/controllers/post_controller.dart';
import 'package:armoyu_widgets/widgets/utility.dart';
import 'package:armoyu_widgets/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class TwitterPostWidget {
  final ARMOYUServices service;

  const TwitterPostWidget(this.service);

  Widget postWidget(BuildContext context,
      {required Post post,
      required Function profileFunction,
      bool? isPostdetail = false}) {
    final findCurrentAccountController = Get.find<AccountUserController>();
    String uniqueTag = DateTime.now().millisecondsSinceEpoch.toString();
    final controller = Get.put(
      PostController(post: post, service: service),
      tag:
          "${findCurrentAccountController.currentUserAccounts.value.user.value.userID}postUniq${post.postID}-$uniqueTag",
    );

    return Obx(
      () => Visibility(
        visible: controller.postVisible.value,
        child: Container(
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
                    profileFunction();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => CircleAvatar(
                          backgroundColor: Colors.transparent,
                          foregroundImage: CachedNetworkImageProvider(
                            controller.postInfo.value.owner.avatar!.mediaURL
                                .minURL.value,
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
                                    controller
                                        .postInfo.value.owner.userName!.value,
                                    size: 16,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Obx(
                                  () =>
                                      controller.postInfo.value.sharedDevice ==
                                              "mobil"
                                          ? const Text("📱")
                                          : const Text("🌐"),
                                ),
                                const SizedBox(width: 5),
                                Obx(
                                  () => CustomText.costum1(
                                    controller.postInfo.value.postDate
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
                                    visible:
                                        controller.postInfo.value.location !=
                                            null,
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          color: Colors.red,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 1),
                                        CustomText.costum1(
                                          controller.postInfo.value.location
                                              .toString(),
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
                            onPressed: controller.postfeedback,
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
                  if (!controller.postInfo.value.isLikeme) {
                    controller.likeButtonKey.value.currentState?.onTap();
                    controller.postLike(controller.postInfo.value.isLikeme);
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
                            controller.postInfo.value.content,
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
                  if (!controller.postInfo.value.isLikeme) {
                    controller.likeButtonKey.value.currentState?.onTap();
                    controller.postLike(controller.postInfo.value.isLikeme);
                  }
                },
                child: Obx(
                  () => Center(
                    child: controller.buildMediaContent(context),
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
                        if (isPostdetail == false) {
                          controller.showpostlikers();
                        }
                      },
                      child: Obx(
                        () => controller.likebutton.value!,
                      ),
                    ),
                    const Spacer(),
                    Obx(
                      () => IconButton(
                        iconSize: 25,
                        icon: controller.postcommentIcon.value,
                        color: controller.postcommentColor.value,
                        onPressed: () => controller.postcomments(
                            controller.postInfo.value.postID,
                            profileFunction: profileFunction),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Obx(
                      () => Text(
                        controller.postInfo.value.commentsCount.toString(),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    const Spacer(),
                    Obx(
                      () => IconButton(
                        iconSize: 25,
                        icon: controller.postrepostIcon.value,
                        color: controller.postrepostColor.value,
                        onPressed: () {},
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () async {
                        await Share.share(
                          'https://aramizdakioyuncu.com/?sosyal1=${post.postID}',
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
                      width: double.infinity,
                      child: Stack(
                        children: [
                          const SizedBox(height: 20),
                          ...List.generate(
                              controller.postInfo.value.firstthreelike!.length,
                              (index) {
                            int left = controller
                                        .postInfo.value.firstthreelike!.length *
                                    10 -
                                (index + 1) * 10;
                            return Obx(
                              () => Positioned(
                                left: double.parse(left.toString()),
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  foregroundImage: CachedNetworkImageProvider(
                                    post
                                        .firstthreelike![controller.postInfo
                                                .value.firstthreelike!.length -
                                            index -
                                            1]
                                        .user
                                        .avatar!
                                        .mediaURL
                                        .minURL
                                        .value,
                                  ),
                                  radius: 10,
                                ),
                              ),
                            );
                          }),
                          Obx(
                            () => Positioned(
                              left: controller.postInfo.value.firstthreelike!
                                          .length *
                                      10 +
                                  15,
                              child: controller
                                      .postInfo.value.firstthreelike!.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () => controller.showpostlikers(),
                                      child: Obx(
                                        () => WidgetUtility.specialText(
                                          context,
                                          "@${controller.postInfo.value.firstthreelike![0].user.userName.toString()}  ${(controller.postInfo.value.likesCount - 1) <= 0 ? SocialKeys.socialLiked.tr : SocialKeys.socialandnumberpersonLiked.tr.replaceAll('#NUMBER#', "${controller.postInfo.value.likesCount - 1}")}",
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
                            controller.postInfo.value.firstthreecomment!.length,
                            (index) {
                          return PostcommentView.commentlist(
                            context,
                            controller.postInfo.value.firstthreecomment![index],
                            service,
                            profileFunction: profileFunction,
                          );
                        }),
                      ),
                    ),
                    Obx(
                      () => Visibility(
                        visible: controller.postInfo.value.commentsCount > 3,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () => controller.postcomments(
                                controller.postInfo.value.postID,
                                profileFunction: profileFunction),
                            child: CustomText.costum1(
                              "${controller.postInfo.value.commentsCount} ${SocialKeys.socialViewAllComments.tr}",
                              color: Get.theme.primaryColor.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget widgetStorycircle(
      {required User user, required List<StoryList> content}) {
    var currentUser = user.obs;

    final RxList<StoryList> rxContent = RxList<StoryList>(content);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
          child: SizedBox(
            height: 105,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: content.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final StoryList cardData = content[index];
                Color storycolor = Colors.transparent;
                Color otherstorycolor = Colors.red;

                if (cardData.isView) {
                  otherstorycolor = Colors.grey;
                }

                bool ishasstory = false;
                if (cardData.owner.userID == currentUser.value.userID) {
                  if (cardData.story != null) {
                    storycolor = Colors.blue;
                    ishasstory = true;
                  }
                }
                Color circleColor = Colors.transparent;
                if (cardData.owner.userID == currentUser.value.userID) {
                  circleColor = storycolor;
                } else {
                  circleColor = otherstorycolor;
                }

                return GestureDetector(
                  onTap: () {
                    if (cardData.owner.userID == currentUser.value.userID) {
                      if (ishasstory) {
                        Get.to(
                          StoryScreenView(service: service),
                          arguments: {
                            "storyList": rxContent,
                            "storyIndex": index,
                          },
                        );

                        return;
                      }

                      Get.toNamed("/gallery");
                    } else {
                      Get.to(
                        StoryScreenView(service: service),
                        arguments: {
                          "storyList": rxContent,
                          "storyIndex": index,
                        },
                      );

                      //Basılınca görüntülendi efekti ver
                      content[index].isView = true;
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 85,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: circleColor,
                            width: 3.0,
                          ),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                            image: CachedNetworkImageProvider(
                              cardData.owner.avatar!.mediaURL.minURL.value,
                            ),
                          ),
                        ),
                        child: cardData.owner.userID == currentUser.value.userID
                            ? Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  height: 24,
                                  width: 24,
                                  decoration: BoxDecoration(
                                    color: Get.theme.scaffoldBackgroundColor,
                                    borderRadius: const BorderRadius.all(
                                      Radius.elliptical(100, 100),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.blue,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: 2),
                      CustomText.costum1(
                        cardData.owner.userID == currentUser.value.userID
                            ? SocialKeys.socialStory.tr
                            : cardData.owner.userName!.value,
                        size: 11,
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 10),
            ),
          ),
        ),
      ],
    );
  }
}
