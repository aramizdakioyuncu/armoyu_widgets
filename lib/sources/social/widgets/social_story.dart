import 'package:armoyu_widgets/data/models/Story/storylist.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/sources/Story/story_screen_page/views/story_screen_view.dart';
import 'package:armoyu_widgets/screens/gallery/views/gallery_view.dart';
import 'package:armoyu_widgets/sources/social/bundle/story_bundle.dart';
import 'package:armoyu_widgets/sources/social/controllers/story_controller.dart';
import 'package:armoyu_widgets/translations/app_translation.dart';
import 'package:armoyu_widgets/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

StoryWidgetBundle widgetSocialStory(
  service, {
  List<StoryList>? cachedStoryList,
  Function(List<StoryList> updatedStories)? onStoryUpdated,
}) {
  final findCurrentAccountController = Get.find<AccountUserController>();
  String uniqueTag = DateTime.now().millisecondsSinceEpoch.toString();

  final controller = Get.put(
      StoryController(
        service: service,
        cachedStoryList: cachedStoryList,
        onStoryUpdated: onStoryUpdated,
      ),
      tag:
          "${findCurrentAccountController.currentUserAccounts.value.user.value.userID}storyWidgetUniq-$uniqueTag");

  Widget widget = Obx(
    () => controller.filteredStoryList.value == null
        ? const CupertinoActivityIndicator()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
            child: SizedBox(
              height: 105,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: controller.filteredStoryList.value!.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final StoryList cardData =
                      controller.filteredStoryList.value![index];
                  Color storycolor = Colors.transparent;
                  Color otherstorycolor = Colors.red;

                  if (cardData.isView) {
                    otherstorycolor = Colors.grey;
                  }

                  bool ishasstory = false;
                  if (cardData.owner.userID == controller.currentUser!.userID) {
                    if (cardData.story != null) {
                      storycolor = Colors.blue;
                      ishasstory = true;
                    }
                  }
                  Color circleColor = Colors.transparent;
                  if (cardData.owner.userID == controller.currentUser!.userID) {
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
                              "storyList": controller.filteredStoryList.value,
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
                            "storyList": controller.filteredStoryList.value,
                            "storyIndex": index,
                          },
                        );

                        //Basılınca görüntülendi efekti ver
                        controller.filteredStoryList.value![index].isView =
                            true;
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
                separatorBuilder: (context, index) => const SizedBox(width: 10),
              ),
            ),
          ),
  );

  return StoryWidgetBundle(
    widget: Rxn(widget),
    refresh: () async => await controller.refreshAllStory(),
    loadMore: () async => await controller.loadMoreStory(),
  );
}
