import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:widgets/app/services/app_service.dart';

class PostdetailView extends StatelessWidget {
  const PostdetailView({super.key});

  @override
  Widget build(BuildContext context) {
    var scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Detail'),
        forceMaterialTransparency: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppService.widgets.social.posts(
                context: context,
                scrollController: scrollController,
                profileFunction: (userID, username) {
                  log('$userID $username');
                },
                shrinkWrap: true,
                category: "etiketlenmis",
                username: "berkaytikenoglu",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
