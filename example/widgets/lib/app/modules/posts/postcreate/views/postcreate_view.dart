import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/modules/posts/postcreate/controller/postcreate_controller.dart';

class PostcreateView extends StatelessWidget {
  const PostcreateView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreatePostController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Create'),
        forceMaterialTransparency: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: controller.createPostWidget.widget.value ?? const SizedBox(),
          ),
        ],
      ),
    );
  }
}
