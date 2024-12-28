import 'dart:developer';

import 'package:armoyu_services/core/models/ARMOYU/API/story/story_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/Story/story.dart';
import 'package:armoyu_widgets/data/models/Story/storylist.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/translations/app_translation.dart';
import 'package:get/get.dart';
import 'package:widgets/app/services/app_service.dart';

class StoryController extends GetxController {
  Rxn<List<StoryList>> content = Rxn<List<StoryList>>(null);

  var proccess = false.obs;
  @override
  void onInit() {
    super.onInit();

    fetchstory();
  }

  fetchstory() async {
    if (proccess.value) {
      return;
    }

    proccess.value = true;
    StoryFetchListResponse response =
        await AppService.service.storyServices.stories(page: 1);
    if (!response.result.status) {
      proccess.value = false;
      return;
    }

    content.value ??= [];

    if (response.response!.isEmpty) {
      content.value!.add(
        StoryList(
          owner: User(
            userID: AppService.widgets.accountController.currentUserAccounts
                .value.user.value.userID,
            userName: (SocialKeys.socialStory.tr).obs,
            avatar: AppService.widgets.accountController.currentUserAccounts
                .value.user.value.avatar,
          ),
          story: null,
          isView: true,
        ),
      );
    }
    for (APIStoryList element in response.response!) {
      content.value!.add(
        StoryList(
          owner: User(
              userID: element.oyuncuId,
              userName: Rx(element.oyuncuKadi),
              displayName: Rx(element.oyuncuAdSoyad),
              avatar: Media(
                mediaID: 0,
                mediaURL: MediaURL(
                  bigURL: Rx(element.oyuncuAvatar.bigURL),
                  normalURL: Rx(element.oyuncuAvatar.normalURL),
                  minURL: Rx(
                    element.oyuncuAvatar.minURL,
                  ),
                ),
              )),
          story: element.hikayeIcerik
              .map(
                (e) => Story(
                  storyID: e.hikayeId,
                  ownerID: e.hikayeSahip,
                  ownerusername: element.oyuncuKadi,
                  owneravatar: element.oyuncuAvatar.minURL,
                  time: e.hikayeZaman,
                  media: e.hikayeMedya,
                  isLike: e.hikayeBenBegeni,
                  isView: e.hikayeBenGoruntulenme,
                ),
              )
              .toList(),
          isView: false,
        ),
      );
    }

    content.refresh();
    proccess.value = false;

    log(content.value!.length.toString());
  }
}
