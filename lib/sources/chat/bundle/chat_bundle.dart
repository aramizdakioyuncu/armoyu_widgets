import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ChatWidgetBundle {
  Rxn<Widget> widget;
  final Future<void> Function() refresh;
  final Future<void> Function() loadMore;
  final Future<void> Function(String text) filterList;

  ChatWidgetBundle({
    required this.widget,
    required this.refresh,
    required this.loadMore,
    required this.filterList,
  });
}
