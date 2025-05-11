import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MusiclistWidgetBundle {
  Rxn<Widget> widget;
  final Future<void> Function() play;
  final Future<void> Function() stop;

  MusiclistWidgetBundle({
    required this.widget,
    required this.play,
    required this.stop,
  });
}
