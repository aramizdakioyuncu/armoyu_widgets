import 'dart:developer';

import 'package:armoyu_widgets/sources/card/bundle/card_bundle.dart';
import 'package:armoyu_widgets/sources/card/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/services/app_service.dart';

class SearchViewController extends GetxController {
  late CardWidgetBundle cardWidget;
  late CardWidgetBundle cardWidget2;
  Rxn<Widget> widget3 = Rxn();

  @override
  void onInit() {
    super.onInit();
    initfunction();
  }

  initfunction() async {
    cardWidget = AppService.widgets.cards.cardWidget(
      context: Get.context!,
      title: CustomCardType.playerPOP,
      firstFetch: true,
      profileFunction: ({
        required avatar,
        required banner,
        required displayname,
        required userID,
        required username,
      }) {},
    );

    cardWidget2 = AppService.widgets.cards.cardWidget(
      context: Get.context!,
      title: CustomCardType.playerXP,
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
