import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/story/story_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/Story/story.dart';
import 'package:armoyu_widgets/data/models/Story/storylist.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/translations/app_translation.dart';
import 'package:get/get.dart';

class StoryController extends GetxController {
  final ARMOYUServices service;
  List<StoryList>? cachedStoryList;
  Function(List<StoryList> updatedStories)? onStoryUpdated;

  StoryController({
    required this.service,
    this.cachedStoryList,
    this.onStoryUpdated,
  });

  Rxn<List<StoryList>> storyList = Rxn(null);
  Rxn<List<StoryList>> filteredStoryList = Rxn(null);
  var storyproccess = false.obs;
  var storyEndproccess = false.obs;

  User? currentUser;

  Future<void> refreshAllStory() async {
    log("Refresh All Story");
    await fetchstory(refreshStroy: true);
  }

  Future<void> loadMoreStory() async {
    log("load More Stories");
    return await fetchstory();
  }

  void updateStoryList() {
    filteredStoryList.value = storyList.value;
    storyList.refresh();
    filteredStoryList.refresh();
    onStoryUpdated?.call(storyList.value!);
  }

  @override
  void onInit() {
    super.onInit();
    log("Story Widget Init");
    final findCurrentAccountController = Get.find<AccountUserController>();
    currentUser =
        findCurrentAccountController.currentUserAccounts.value.user.value;

    log(currentUser!.userID.toString());

    //Bellekteki paylaşımları yükle
    if (cachedStoryList != null) {
      storyList.value ??= [];
      storyList.value = cachedStoryList;
    }

    fetchstory();
  }

  fetchstory({bool refreshStroy = false}) async {
    if (storyproccess.value) {
      return;
    }

    storyproccess.value = true;
    StoryFetchListResponse response =
        await service.storyServices.stories(page: 1);
    if (!response.result.status) {
      Future.delayed(const Duration(seconds: 1), () {
        storyproccess.value = false;
        fetchstory();
      });
      return;
    }

    storyList.value ??= [];
    filteredStoryList.value ??= [];

    if (response.response!.isEmpty) {
      storyList.value!.add(
        StoryList(
          owner: User(
            userID: currentUser!.userID,
            userName: (SocialKeys.socialStory.tr).obs,
            avatar: currentUser!.avatar,
          ),
          story: null,
          isView: true,
        ),
      );
    }
    for (APIStoryList element in response.response!) {
      storyList.value!.add(
        StoryList(
          owner: User(
              userID: element.oyuncuId,
              userName: Rx(element.oyuncuKadi),
              displayName: Rx(element.oyuncuAdSoyad),
              avatar: Media(
                mediaID: 0,
                mediaType: MediaType.image,
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

    storyproccess.value = false;
    updateStoryList();

    if (response.response!.length < 30) {
      // 10'dan azsa daha fazla yok demektir
      storyEndproccess.value = true;
      log("Daha fazla veri yok (StoryList)");
    }
  }
}
