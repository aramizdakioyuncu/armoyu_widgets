import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/modules/cache/controllers/cache_controller.dart';
import 'package:widgets/app/services/app_service.dart';

class CacheView extends StatelessWidget {
  const CacheView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CacheController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caching'),
        forceMaterialTransparency: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          children: [
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppService.widgets.elevatedButton.costum1(
                  background: AppService.widgets.accountController
                              .currentUserAccounts.value.widgetPosts !=
                          null
                      ? Colors.green
                      : Colors.red,
                  text: "Fill Posts",
                  onPressed: () async {
                    await controller.fillPosts();
                  },
                  loadingStatus: controller.postsProcccess.value,
                ),
              ),
            ),
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppService.widgets.elevatedButton.costum1(
                  background: AppService.widgets.accountController
                              .currentUserAccounts.value.widgetStoriescard !=
                          null
                      ? Colors.green
                      : Colors.red,
                  text: "Fill Story",
                  onPressed: () async {
                    await controller.fillStory();
                  },
                  loadingStatus: controller.storyiesProcccess.value,
                ),
              ),
            ),
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppService.widgets.elevatedButton.costum1(
                  background: AppService.widgets.accountController
                              .currentUserAccounts.value.notificationList !=
                          null
                      ? Colors.green
                      : Colors.red,
                  text: "Fill Notification",
                  onPressed: () async {
                    await controller.fillNotifications();
                  },
                  loadingStatus: controller.notificationsProcccess.value,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
