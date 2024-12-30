import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/modules/chat/controllers/chatdetail_controller.dart';
import 'package:widgets/app/routes/app_route.dart';
import 'package:widgets/app/services/app_service.dart';

class ChatdetailView extends StatelessWidget {
  const ChatdetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatdetailController());
    return Scaffold(
      body: AppService.widgets.chat.chatdetailWidget(
        context,
        chatImage:
            "https://images.pexels.com/photos/2486168/pexels-photo-2486168.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
        chat: controller.chat.value!,
        chatcall: (chat) {
          Get.toNamed(Routes.CHATCALL, arguments: {'chat': chat});
        },
      ),
    );
  }
}
