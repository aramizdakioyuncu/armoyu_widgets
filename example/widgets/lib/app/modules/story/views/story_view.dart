import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/modules/story/controllers/story_controller.dart';
import 'package:widgets/app/services/app_service.dart';

class StoryView extends StatelessWidget {
  const StoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StoryController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story'),
      ),
      body: Center(
        child: Obx(
          () => controller.content.value == null
              ? const CupertinoActivityIndicator()
              : AppService.widgets.social.widgetStorycircle(
                  content: controller.content.value!,
                ),
        ),
      ),
    );
  }
}
