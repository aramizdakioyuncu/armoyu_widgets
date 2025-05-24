import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostcreateWidgetBundle {
  Rxn<Widget> widget;
  final Future<void> Function() refresh;

  PostcreateWidgetBundle({
    required this.widget,
    required this.refresh,
  });
}
