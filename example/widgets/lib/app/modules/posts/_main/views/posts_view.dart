import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/modules/posts/_main/controllers/posts_controller.dart';

class PostsView extends StatelessWidget {
  const PostsView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PostsController());

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text('Posts'),
      ),
      body: Column(
        children: [
          Expanded(
            child: controller.posts.widget.value ?? const SizedBox(),
          ),
        ],
      ),
    );
  }
}
