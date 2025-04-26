import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/utils/player_pop_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/sources/card/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardsControllerV2 extends GetxController {
  final ARMOYUServices service;
  final CustomCardType title;
  List<APIPlayerPop>? cachedCardList;
  Function(List<APIPlayerPop> updatedCard)? onCardUpdated;
  final bool firstFetch;

  CardsControllerV2({
    required this.service,
    required this.title,
    required this.cachedCardList,
    this.onCardUpdated,
    required this.firstFetch,
  });

  var morefetchProcces = false.obs;
  var morefetchProccesEnd = false.obs;
  var firstFetchProcces = false.obs;

  var xtitle = Rxn<CustomCardType>(null);
  var xicon = Rxn<Icon>(null);
  var xeffectcolor = Rxn<Color>(null);
  var xscrollController = Rxn<ScrollController>(null);
  var xfirstFetch = Rxn<bool>(null);

  var cardList = Rxn<List<APIPlayerPop>>();

  Future<void> refreshAllCards() async {
    log("Refresh All Posts");
    await fetchcards(refreshcard: true);
  }

  Future<void> loadMoreCards() async {
    log("load More Posts");
    return await fetchcards();
  }

  void updateCards() {
    log("Update Cards");
    cardList.refresh();
    onCardUpdated?.call(cardList.value!);
  }

  @override
  void onInit() {
    super.onInit();

    cardinit();
    //Bellekteki paylaşımları yükle
    if (cachedCardList != null) {
      cardList.value ??= [];
      cardList.value = cachedCardList;
      firstFetchProcces.value = true;
    }

    if (!firstFetchProcces.value && xfirstFetch.value!) {
      if (cardList.value == null) {
        fetchcards();
        firstFetchProcces.value = true;
      }
    }
    xscrollController.value!.addListener(() {
      if (xscrollController.value!.position.pixels >=
          xscrollController.value!.position.maxScrollExtent * 0.9) {
        fetchcards();
      }
    });
  }

  cardinit() {
    xtitle.value = title;

    if (xtitle.value == CustomCardType.playerXP) {
      xicon.value = const Icon(
        Icons.auto_graph_outlined,
        size: 15,
        color: Colors.white,
      );
      xeffectcolor.value =
          const Color.fromARGB(255, 10, 84, 175).withValues(alpha: 0.7);
    }
    if (xtitle.value == CustomCardType.playerPOP) {
      xicon.value = const Icon(
        Icons.remove_red_eye_outlined,
        size: 15,
        color: Colors.white,
      );
      xeffectcolor.value =
          const Color.fromARGB(255, 175, 10, 10).withValues(alpha: 0.7);
    } else {
      xicon.value = const Icon(
        Icons.auto_graph_outlined,
        size: 15,
        color: Colors.white,
      );
      xeffectcolor.value =
          const Color.fromARGB(255, 10, 84, 175).withValues(alpha: 0.7);
    }

    xscrollController.value = ScrollController();
    xfirstFetch.value = firstFetch;
  }

  Future<void> fetchcards({bool refreshcard = false}) async {
    if (morefetchProcces.value || morefetchProccesEnd.value) {
      return;
    }
    morefetchProcces.value = true;

    log("${xtitle.value}");
    cardList.value ??= [];
    // Sayfa başına gösterilecek içerik sayısı
    int itemsPerPage = 10;

    // Şu anki içerik sayısını alıyoruz
    int currentContentCount = cardList.value!.length;

    // Sayfa numarasını içerik sayısına göre hesaplıyoruz
    int currentPage = (currentContentCount / itemsPerPage).ceil() + 1;

    PlayerPopResponse response;
    if (xtitle.value == CustomCardType.playerPOP) {
      response = await service.utilsServices.getplayerpop(
        page: currentPage,
      );
    } else {
      response = await service.utilsServices.getplayerxp(
        page: currentPage,
      );
    }

    if (!response.result.status) {
      log(response.result.description);
      morefetchProcces.value = false;
      return;
    }

    if (refreshcard) {
      cardList.value = [];
    }
    for (APIPlayerPop element in response.response!) {
      cardList.value!.add(element);
    }
    updateCards();
    morefetchProcces.value = false;

    if (response.response!.length < 10) {
      //Eğer veri 10 dan azsa daha fazla veri yok demektir.
      morefetchProccesEnd.value = true;
      return;
    }
  }
}
