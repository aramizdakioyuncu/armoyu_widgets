import 'dart:developer';

import 'package:armoyu_widgets/sources/card/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/services/app_service.dart';

class SearchViewController extends GetxController {
  Rxn<Widget> widget = Rxn();
  Rxn<Widget> widget2 = Rxn();
  Rxn<Widget> widget3 = Rxn();

  @override
  void onInit() {
    super.onInit();
    initfunction();
  }

  initfunction() async {
    widget.value = AppService.widgets.cards.cardWidget(
      context: Get.context!,
      title: CustomCardType.playerPOP,
      content: [],
      firstFetch: true,
      profileFunction: ({
        required avatar,
        required banner,
        required displayname,
        required userID,
        required username,
      }) {},
    );

    widget2.value = AppService.widgets.cards.cardWidget(
      context: Get.context!,
      title: CustomCardType.playerXP,
      content: [],
      firstFetch: true,
      profileFunction: ({
        required avatar,
        required banner,
        required displayname,
        required userID,
        required username,
      }) {},
    );
    widget3.value = AppService.widgets.news.newsCarouselWidget(
      newsFunction: (news) {
        log(news.newsID.toString());
      },
    );
  }
}
