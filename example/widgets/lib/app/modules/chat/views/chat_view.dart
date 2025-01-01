import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/modules/chat/controllers/chat_controller.dart';
import 'package:widgets/app/routes/app_route.dart';
import 'package:widgets/app/services/app_service.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());

    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: Column(
        children: [
          TabBar(
            labelPadding: const EdgeInsets.all(10),
            tabs: const [
              Text("Son Sohbet"),
              Text("Yeni Sohbet"),
            ],
            controller: controller.tabController.value,
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController.value,
              children: [
                Column(
                  children: [
                    AppService.widgets.chat.chatmyfriendsNotes(context),
                    Expanded(
                      child: AppService.widgets.chat.chatListWidget(
                        context,
                        onPressed: (chat) {
                          log(chat.chatID.toString());
                          Get.toNamed(
                            Routes.CHATDETAIL,
                            arguments: {'chat': chat},
                          );
                        },
                        scrollController: controller.scrollController.value,
                      ),
                    ),
                  ],
                ),
                AppService.widgets.chat.newchatListWidget(
                  context,
                  onPressed: (chat) {
                    log(chat.chatID.toString());
                    Get.toNamed(Routes.CHATDETAIL, arguments: {'chat': chat});
                  },
                  scrollController: controller.scrollController.value,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
