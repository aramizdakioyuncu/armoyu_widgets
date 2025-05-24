import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReelsWidgetBundle {
  Rxn<Widget> widget;
  final Future<void> Function() next;
  final Future<void> Function() back;

  ReelsWidgetBundle({
    required this.widget,
    required this.next,
    required this.back,
  });
}
