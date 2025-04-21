import 'dart:developer';

import 'package:armoyu_widgets/sources/chat/bundle/chat_bundle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/routes/app_route.dart';
import 'package:widgets/app/services/app_service.dart';

class ChatController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late var tabController = Rx<TabController?>(null);
  var scrollControllerchatList = ScrollController().obs;
  var scrollControllernewChatList = ScrollController().obs;
  late ChatWidgetBundle widgetChatList;
  late ChatWidgetBundle widgetNewChatList;
  @override
  void onInit() {
    super.onInit();
    tabController.value = TabController(length: 2, vsync: this);

    widgetChatList = AppService.widgets.chat.chatListWidget(
      Get.context!,
      onChatUpdated: (updatedChat) {},
      onPressed: (chat) {
        log(chat.chatID.toString());
        Get.toNamed(
          Routes.CHATDETAIL,
          arguments: {'chat': chat},
        );
      },
    );

    widgetNewChatList = AppService.widgets.chat.newchatListWidget(
      Get.context!,
      onPressed: (chat) {
        log(chat.chatID.toString());
        Get.toNamed(Routes.CHATDETAIL, arguments: {'chat': chat});
      },
    );

    scrollControllerchatList.value.addListener(() {
      if (scrollControllerchatList.value.position.pixels >=
          scrollControllerchatList.value.position.maxScrollExtent - 300) {
        // 300 px kalınca çalışır
        widgetChatList.loadMore().then((value) {
          log("load more posts done");
        });
      }
    });

    scrollControllernewChatList.value.addListener(() {
      if (scrollControllernewChatList.value.position.pixels >=
          scrollControllernewChatList.value.position.maxScrollExtent - 300) {
        // 300 px kalınca çalışır
        widgetNewChatList.loadMore().then((value) {
          log("load more new chat List done");
        });
      }
    });
  }
}
