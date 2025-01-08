import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/post/post_detail.dart';
import 'package:armoyu_widgets/data/models/Story/storylist.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/sources/Story/story_screen_page/views/story_screen_view.dart';
import 'package:armoyu_widgets/sources/gallery/views/gallery_view.dart';
import 'package:armoyu_widgets/sources/social/controllers/post_controller.dart';
import 'package:armoyu_widgets/sources/social/controllers/story_controller.dart';
import 'package:armoyu_widgets/translations/app_translation.dart';
import 'package:armoyu_widgets/widgets/text.dart';
import 'package:armoyu_widgets/widgetsv2/post/post_widget2.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SocialWidget {
  final ARMOYUServices service;

  const SocialWidget(this.service);

  Widget posts({
    required BuildContext context,
    ScrollController? scrollController,
    required Function(int userID, String username) profileFunction,
    Function? refreshPosts,
    bool isPostdetail = false,
    String? category,
    int? userID,
    String? username,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
    ScrollPhysics physics = const ClampingScrollPhysics(),
    bool sliverWidget = false,
    Key? key,
  }) {
    final controller = Get.put(
      PostController(service, scrollController, category, userID, username),
      tag:
          "postWidget-$category$userID-Uniq-${DateTime.now().millisecondsSinceEpoch}",
    );
    return Obx(
      () => controller.postsList.value == null
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : !sliverWidget
              ? ListView.builder(
                  controller:
                      shrinkWrap ? null : controller.xscrollController.value,
                  key: key,
                  shrinkWrap: shrinkWrap,
                  padding: padding,
                  physics: shrinkWrap
                      ? const NeverScrollableScrollPhysics()
                      : physics,
                  itemCount: controller.postsList.value!.length,
                  itemBuilder: (context, postIndex) {
                    var postdetail =
                        Rx<APIPostList>(controller.postsList.value![postIndex]);

                    return PostWidget2.postWidget(
                      service: service,
                      postdetail: postdetail,
                      controller: controller,
                      profileFunction: profileFunction,
                    );
                  },
                )
              : CustomScrollView(
                  physics: refreshPosts != null
                      ? const BouncingScrollPhysics()
                      : const ClampingScrollPhysics(),
                  slivers: [
                    refreshPosts != null
                        ? CupertinoSliverRefreshControl(
                            onRefresh: () async {
                              await refreshPosts();
                            },
                          )
                        : const SliverToBoxAdapter(child: SizedBox.shrink()),
                    SliverToBoxAdapter(
                      child: ListView.builder(
                        controller: shrinkWrap
                            ? null
                            : controller.xscrollController.value,
                        key: key,
                        shrinkWrap: shrinkWrap,
                        padding: padding,
                        physics: shrinkWrap
                            ? const NeverScrollableScrollPhysics()
                            : physics,
                        itemCount: controller.postsList.value!.length,
                        itemBuilder: (context, postIndex) {
                          var postdetail = Rx<APIPostList>(
                              controller.postsList.value![postIndex]);

                          return PostWidget2.postWidget(
                            service: service,
                            postdetail: postdetail,
                            controller: controller,
                            profileFunction: profileFunction,
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget widgetStorycircle() {
    final findCurrentAccountController = Get.find<AccountUserController>();
    String uniqueTag = DateTime.now().millisecondsSinceEpoch.toString();

    final controller = Get.put(StoryController(service),
        tag:
            "${findCurrentAccountController.currentUserAccounts.value.user.value.userID}storyWidgetUniq-$uniqueTag");

    return Obx(
      () => controller.content.value == null
          ? const CupertinoActivityIndicator()
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
              child: SizedBox(
                height: 105,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.content.value!.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final StoryList cardData = controller.content.value![index];
                    Color storycolor = Colors.transparent;
                    Color otherstorycolor = Colors.red;

                    if (cardData.isView) {
                      otherstorycolor = Colors.grey;
                    }

                    bool ishasstory = false;
                    if (cardData.owner.userID ==
                        controller.currentUser!.userID) {
                      if (cardData.story != null) {
                        storycolor = Colors.blue;
                        ishasstory = true;
                      }
                    }
                    Color circleColor = Colors.transparent;
                    if (cardData.owner.userID ==
                        controller.currentUser!.userID) {
                      circleColor = storycolor;
                    } else {
                      circleColor = otherstorycolor;
                    }

                    return GestureDetector(
                      onTap: () {
                        if (cardData.owner.userID ==
                            controller.currentUser!.userID) {
                          if (ishasstory) {
                            Get.to(
                              StoryScreenView(service: service),
                              arguments: {
                                "storyList": controller.content.value,
                                "storyIndex": index,
                              },
                            );

                            return;
                          }

                          Get.to(
                            GalleryView(
                              service: service,
                            ),
                          );
                        } else {
                          Get.to(
                            StoryScreenView(service: service),
                            arguments: {
                              "storyList": controller.content.value,
                              "storyIndex": index,
                            },
                          );

                          //Basılınca görüntülendi efekti ver
                          controller.content.value![index].isView = true;
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
                            child: cardData.owner.userID ==
                                    controller.currentUser!.userID
                                ? Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      height: 24,
                                      width: 24,
                                      decoration: BoxDecoration(
                                        color:
                                            Get.theme.scaffoldBackgroundColor,
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
                            cardData.owner.userID ==
                                    controller.currentUser!.userID
                                ? SocialKeys.socialStory.tr
                                : cardData.owner.userName!.value,
                            size: 11,
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                ),
              ),
            ),
    );
  }
}
