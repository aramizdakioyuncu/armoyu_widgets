import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/reels/reels.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart' as armoyumedia;
import 'package:armoyu_widgets/data/models/reels.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/functions/utils_function.dart';
import 'package:armoyu_widgets/sources/reels/controllers/reels_screen_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ReelsController extends GetxController {
  final ARMOYUServices service;

  ReelsController({required this.service});

  late PageController pageController;

  var reelsList = Rxn<List<Reels>>();

  var pageIndex = 0.obs;
  var reelspageIndex = 1.obs;
  @override
  void onInit() {
    pageController = PageController(initialPage: pageIndex.value);
    fetchReels();
    super.onInit();
  }

  void fetchReels() async {
    reelspageIndex.value = UtilsFunction.calculatePageNumber(
        cardList: reelsList, itemsPerPage: 30);

    ReelsListResponse response =
        await service.reelsServices.fetch(page: reelspageIndex.value);

    if (!response.result.status) {
      log(response.result.description);
      return;
    }

    reelsList.value ??= [];
    for (APIReel element in response.response!) {
      reelsList.value!.add(
        Reels(
          id: element.reelsID,
          videoUrl: element.media.mediaURL.normalURL,
          thumbnailUrl: element.media.mediaURL.minURL,
          owner: User(
            userID: element.owner.userID,
            displayName: Rx(element.owner.displayname),
            userName: Rx(element.owner.username!),
            avatar: armoyumedia.Media(
              mediaID: 0,
              mediaType: armoyumedia.MediaType.image,
              mediaURL: armoyumedia.MediaURL(
                bigURL: Rx(element.owner.avatar.bigURL),
                normalURL: Rx(element.owner.avatar.normalURL),
                minURL: Rx(element.owner.avatar.minURL),
              ),
            ),
          ),
          description: element.description,
          createdAt: element.date,
        ),
      );
    }
    reelsList.refresh();
  }

  Future<void> nextReels() async {
    final currentIndex = pageIndex.value;
    final nextIndex = currentIndex + 1;

    if (nextIndex >= reelsList.value!.length) return;

    // Şu anki reels controller'ı güvenli şekilde bul ve durdur
    final currentTag = currentIndex.toString();
    if (Get.isRegistered<ReelsScreenController>(tag: currentTag)) {
      Get.find<ReelsScreenController>(tag: currentTag).stopReels();
    }

    // Yeni reels controller'ı güvenli şekilde bul ve başlat
    final nextTag = nextIndex.toString();
    if (Get.isRegistered<ReelsScreenController>(tag: nextTag)) {
      Get.find<ReelsScreenController>(tag: nextTag).startReels();
    }

    // Sayfa değişimini yap
    pageIndex.value = nextIndex;
    await pageController.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  Future<void> backReels() async {
    final currentIndex = pageIndex.value;
    final previousIndex = currentIndex - 1;

    if (previousIndex < 0) return;

    // Şu anki reels controller'ı güvenli şekilde bul ve durdur
    final currentTag = currentIndex.toString();
    if (Get.isRegistered<ReelsScreenController>(tag: currentTag)) {
      Get.find<ReelsScreenController>(tag: currentTag).stopReels();
    }

    // Önceki reels controller'ı güvenli şekilde bul ve başlat
    final previousTag = previousIndex.toString();
    if (Get.isRegistered<ReelsScreenController>(tag: previousTag)) {
      Get.find<ReelsScreenController>(tag: previousTag).startReels();
    }

    // Sayfa değişimini yap
    pageIndex.value = previousIndex;
    await pageController.animateToPage(
      previousIndex,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }
}
