import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewsWidgetBundle {
  Rxn<Widget> widget;
  final Future<void> Function() refresh;
  final Future<void> Function() loadMore;

  NewsWidgetBundle({
    required this.widget,
    required this.refresh,
    required this.loadMore,
  });
}
