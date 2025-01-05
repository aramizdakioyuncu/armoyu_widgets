import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/services/app_service.dart';

class PostdetailView extends StatelessWidget {
  const PostdetailView({super.key});

  @override
  Widget build(BuildContext context) {
    var scrollController = ScrollController().obs;

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
            child: AppService.widgets.social.posts(
              context: context,
              scrollController: scrollController.value,
              profileFunction: (userID, username) {
                log('$userID $username');
              },
              // category: "etiketlenmis",
              username: "berkaytikenoglu",
            ),
          ),
        ],
      ),
    );
  }
}
