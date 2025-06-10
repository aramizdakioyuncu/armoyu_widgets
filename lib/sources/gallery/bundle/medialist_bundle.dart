import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedialistWidgetBundle {
  Rxn<Widget> widget;
  final void Function() refresh;
  final void Function() clear;

  MedialistWidgetBundle({
    required this.widget,
    required this.refresh,
    required this.clear,
  });
}
