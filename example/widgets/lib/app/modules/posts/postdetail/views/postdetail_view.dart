import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/modules/posts/postdetail/controller/postdetail_controller.dart';

class PostdetailView extends StatelessWidget {
  const PostdetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PostdetailController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Detail'),
        forceMaterialTransparency: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: controller.posts.widget.value ?? const SizedBox(),
          ),
        ],
      ),
    );
  }
}
