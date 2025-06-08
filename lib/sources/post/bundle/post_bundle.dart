import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostWidgetBundle {
  Rxn<Widget> widget;
  final Future<void> Function() postSound;

  final Future<void> Function() share;
  PostWidgetBundle({
    required this.widget,
    required this.postSound,
    required this.share,
  });
}
