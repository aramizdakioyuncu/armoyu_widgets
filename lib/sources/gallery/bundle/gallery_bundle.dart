import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GalleryWidgetBundle {
  Rxn<Widget> widget;
  final Future<void> Function() refresh;
  final Future<void> Function() loadMore;

  GalleryWidgetBundle({
    required this.widget,
    required this.refresh,
    required this.loadMore,
  });
}
