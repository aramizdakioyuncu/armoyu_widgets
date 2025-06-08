import 'package:flutter/material.dart';

abstract class VideoplayerWidgetBundle {
  Widget getVideoWidget();
  Future<void> play();
  Future<void> pause();
  Future<void> pauseOrPlay();
  Future<void> dispose();
  Future<void> setVolume(double volume);
}
