import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/modules/chat/controllers/chat_controller.dart';
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
                ListView(
                  controller: controller.scrollControllerchatList.value,
                  children: [
                    AppService.widgets.chat.chatmyfriendsNotes(context),
                    SizedBox(
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          onChanged: (value) {
                            controller.widgetChatList.filterList(value);
                            log("Chat List Filtered: $value");
                            controller.widgetChatList.widget.refresh();
                          },
                          controller: TextEditingController(),
                          decoration: const InputDecoration(
                            hintText: "Sohbet Ara",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    controller.widgetChatList.widget.value!,
                  ],
                ),
                ListView(
                  controller: controller.scrollControllernewChatList.value,
                  children: [
                    SizedBox(
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          onChanged: (value) {
                            controller.widgetNewChatList.filterList(value);
                          },
                          controller: TextEditingController(),
                          decoration: const InputDecoration(
                            hintText: "Sohbet Ara",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    controller.widgetNewChatList.widget.value!,
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
