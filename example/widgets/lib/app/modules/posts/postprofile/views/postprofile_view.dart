import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/modules/posts/postprofile/controller/postprofile_controller.dart';
import 'package:widgets/app/services/app_service.dart';

class PostprofileView extends StatelessWidget {
  const PostprofileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PostprofileController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Profile'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppService.widgets.social.widgetStorycircle(),
              controller.posts.widget.value ?? const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
