import 'dart:developer';

import 'package:armoyu_widgets/sources/card/bundle/card_bundle.dart';
import 'package:armoyu_widgets/sources/card/widgets/card_widget.dart';
import 'package:armoyu_widgets/sources/news/bundle/news_bundle.dart';
import 'package:get/get.dart';
import 'package:widgets/app/services/app_service.dart';

class SearchViewController extends GetxController {
  late CardWidgetBundle cardWidget;
  late CardWidgetBundle cardWidget2;
  late NewsWidgetBundle newsWidget;

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
    newsWidget = AppService.widgets.news.newsCarouselWidget(
      onNewsUpdated: (updatedNews) {
        log('News updated: ${updatedNews.length}');
      },
      cachedNewsList: AppService
          .widgets.accountController.currentUserAccounts.value.newsList,
      newsFunction: (news) {
        log(news.newsID.toString());
      },
    );
  }
}
