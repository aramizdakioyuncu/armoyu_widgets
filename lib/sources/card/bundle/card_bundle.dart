import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class CardWidgetBundle {
  Rxn<Widget> widget;
  final Future<void> Function() refresh;
  final Future<void> Function() loadMore;

  CardWidgetBundle({
    required this.widget,
    required this.refresh,
    required this.loadMore,
  });
}
