import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:widgets/app/services/app_service.dart';

class PostprofileView extends StatelessWidget {
  const PostprofileView({super.key});

  @override
  Widget build(BuildContext context) {
    var scrollController = ScrollController();

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
              AppService.widgets.social.posts(
                context: context,
                scrollController: scrollController,
                profileFunction: ({user, required userID, required username}) {
                  log('$userID $username');
                },
                userID: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
