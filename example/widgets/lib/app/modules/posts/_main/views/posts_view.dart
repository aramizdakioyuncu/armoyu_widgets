import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:widgets/app/services/app_service.dart';

class PostsView extends StatelessWidget {
  const PostsView({super.key});

  @override
  Widget build(BuildContext context) {
    var scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text('Posts'),
      ),
      body: Column(
        children: [
          Expanded(
            child: AppService.widgets.social.posts(
              context: context,
              scrollController: scrollController,
              userID: 1,
              // shrinkWrap: true,
              profileFunction: ({user, required userID, required username}) {
                log('$userID $username');
              },
            ),
          ),
        ],
      ),
    );
  }
}
