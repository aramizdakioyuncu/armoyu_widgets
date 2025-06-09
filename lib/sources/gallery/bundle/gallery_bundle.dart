import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GalleryWidgetBundle {
  Rxn<Widget> widget;
  final Future<void> Function() refresh;
  final Future<void> Function() loadMore;
  final Future<void> Function() popupGallery;

  GalleryWidgetBundle({
    required this.widget,
    required this.refresh,
    required this.loadMore,
    required this.popupGallery,
  });
}
