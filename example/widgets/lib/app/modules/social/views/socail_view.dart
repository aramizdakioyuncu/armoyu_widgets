import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:widgets/app/services/app_service.dart';

class SocailView extends StatelessWidget {
  const SocailView({super.key});

  @override
  Widget build(BuildContext context) {
    var scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Socail'),
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppService.widgets.social.widgetStorycircle(),
            AppService.widgets.social.posts(
              context: context,
              scrollController: scrollController,
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
