import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoryWidgetBundle {
  Rxn<Widget> widget;
  final Future<void> Function() refresh;
  final Future<void> Function() loadMore;

  StoryWidgetBundle({
    required this.widget,
    required this.refresh,
    required this.loadMore,
  });
}
