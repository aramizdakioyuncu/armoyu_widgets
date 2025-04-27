import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsBundle {
  Rxn<Widget> widget;
  final Future<void> Function() refresh;
  final Future<void> Function() loadMore;

  NotificationsBundle({
    required this.widget,
    required this.refresh,
    required this.loadMore,
  });
}
