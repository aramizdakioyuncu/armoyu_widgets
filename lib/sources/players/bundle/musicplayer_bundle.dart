import 'package:armoyu_widgets/data/models/music.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlayerWidgetBundle {
  Rxn<Widget> widget;
  final Future<void> Function() play;
  final Future<void> Function() stop;
  final Future<void> Function() pause;
  final Future<void> Function() resume;
  final Future<void> Function() next;
  final Future<void> Function() back;
  final Future<void> Function(List<Music>) mediaList;

  PlayerWidgetBundle({
    required this.widget,
    required this.play,
    required this.stop,
    required this.pause,
    required this.resume,
    required this.next,
    required this.back,
    required this.mediaList,
  });
}
