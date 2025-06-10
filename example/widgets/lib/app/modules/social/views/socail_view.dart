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
        actions: [
          IconButton(
            onPressed: () {
              log('YENİLE');
              controller.posts.refresh();
              controller.storyies.refresh();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: controller.scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            controller.storyies.widget.value ?? const SizedBox(),
            controller.posts.widget.value ?? const SizedBox(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: AppService.widgets.elevatedButton.costum1(
                  loadingStatus: false,
                  onPressed: () {
                    log('devam');
                    controller.posts.loadMore();
                  },
                  text: 'Daha Fazlası',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
