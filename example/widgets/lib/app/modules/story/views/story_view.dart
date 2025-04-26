import 'package:flutter/material.dart';
import 'package:widgets/app/services/app_service.dart';

class StoryView extends StatelessWidget {
  const StoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story'),
      ),
      body: Center(
        child: AppService.widgets.social.widgetStorycircle().widget.value!,
      ),
    );
  }
}
