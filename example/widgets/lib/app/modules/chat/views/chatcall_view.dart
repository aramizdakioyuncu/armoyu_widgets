import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/modules/chat/controllers/chatcall_controller.dart';
import 'package:widgets/app/services/app_service.dart';

class ChatcallView extends StatelessWidget {
  const ChatcallView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatcallController());
    return Scaffold(
      body: AppService.widgets.chat.chatcallWidget(
        context,
        chat: controller.chat.value!,
        onClose: (chat) {
          Get.back();
        },
        speaker: (value) {},
        videocall: (value) {},
      ),
    );
  }
}
