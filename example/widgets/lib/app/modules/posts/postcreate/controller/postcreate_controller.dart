import 'package:armoyu_widgets/sources/social/bundle/postcreate_bundle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/services/app_service.dart';

class CreatePostController extends GetxController {
  late PostcreateWidgetBundle createPostWidget;
  var scrollController = ScrollController().obs;

  @override
  void onInit() {
    createPostWidget = AppService.widgets.social.postcreate();

    super.onInit();
  }
}
