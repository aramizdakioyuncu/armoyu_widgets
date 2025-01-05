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
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            AppService.widgets.social.posts(
              context: context,
              scrollController: scrollController,
              userID: 1,
              shrinkWrap: true,
              profileFunction: (userID, username) {
                log('$userID $username');
              },
            ),
          ],
        ),
      ),
    );
  }
}
