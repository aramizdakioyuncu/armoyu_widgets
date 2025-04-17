import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class PostsWidgetBundle {
  Rxn<Widget> widget;
  final Future<void> Function() refresh;
  final Future<void> Function() loadMore;

  PostsWidgetBundle({
    required this.widget,
    required this.refresh,
    required this.loadMore,
  });
}
