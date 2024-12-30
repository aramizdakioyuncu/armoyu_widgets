import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late var tabController = Rx<TabController?>(null);
  var scrollController = ScrollController().obs;

  @override
  void onInit() {
    super.onInit();
    tabController.value = TabController(length: 2, vsync: this);
  }
}
