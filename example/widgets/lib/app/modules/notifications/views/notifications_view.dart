import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/modules/notifications/controllers/notifications_controller.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationsController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        controller: controller.scrollController.value,
        child: Column(
          children: [
            controller.notificationsdetail,
            controller.notifications.widget.value!,
          ],
        ),
      ),
    );
  }
}
