import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/utils/player_pop_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/sources/card/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardsControllerV2 extends GetxController {
  final ARMOYUServices service;
  final CustomCardType title;
  Rxn<List<APIPlayerPop>>? content;

  final bool firstFetch;

  CardsControllerV2({
    required this.service,
    required this.title,
    required this.content,
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

  @override
  void onInit() {
    super.onInit();

    xtitle.value = title;
    content ??= Rxn<List<APIPlayerPop>>(null);

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

    if (!firstFetchProcces.value && xfirstFetch.value!) {
      if (content!.value == null) {
        morefetchinfo();
        firstFetchProcces.value = true;
      }
    }
    xscrollController.value!.addListener(() {
      if (xscrollController.value!.position.pixels >=
          xscrollController.value!.position.maxScrollExtent * 0.9) {
        morefetchinfo();
      }
    });
  }

  Future<void> morefetchinfo() async {
    if (morefetchProcces.value || morefetchProccesEnd.value) {
      return;
    }
    morefetchProcces.value = true;

    log("${xtitle.value}");
    content!.value ??= [];
    // Sayfa başına gösterilecek içerik sayısı
    int itemsPerPage = 10;

    // Şu anki içerik sayısını alıyoruz
    int currentContentCount = content!.value!.length;

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

    for (APIPlayerPop element in response.response!) {
      content!.value!.add(element);
    }
    content!.refresh();

    morefetchProcces.value = false;

    if (response.response!.length < 10) {
      //Eğer veri 10 dan azsa daha fazla veri yok demektir.
      morefetchProccesEnd.value = true;
      return;
    }
  }
}
