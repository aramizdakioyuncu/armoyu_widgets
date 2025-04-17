import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/modules/social/controller/socail_controller.dart';
import 'package:widgets/app/services/app_service.dart';

class SocailView extends StatelessWidget {
  const SocailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SocailController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Socail'),
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        controller: controller.scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppService.widgets.social.widgetStorycircle(),
            AppService.widgets.elevatedButton.costum1(
              loadingStatus: false,
              onPressed: () {
                log('YENİLE');
                controller.posts.refresh();
              },
              text: 'YENİLE',
            ),
            controller.posts.widget.value ?? const SizedBox(),
            AppService.widgets.elevatedButton.costum1(
              loadingStatus: false,
              onPressed: () {
                log('devam');
                controller.posts.loadMore();
              },
              text: 'devam et',
            ),
          ],
        ),
      ),
    );
  }
}
