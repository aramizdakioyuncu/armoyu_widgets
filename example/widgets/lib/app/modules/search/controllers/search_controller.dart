import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/services/app_service.dart';

class SearchViewController extends GetxController {
  Rxn<Widget> widget = Rxn();
  Rxn<Widget> widget2 = Rxn();

  @override
  void onInit() {
    super.onInit();

    // widget.value = AppService.widgets.gallery.mediaGallery(
    //   context: Get.context!,
    // );

    widget.value = AppService.widgets.cards.cardWidget(
      context: Get.context!,
      title: "POP",
      content: [],
      icon: const Icon(Icons.abc),
      effectcolor: Colors.black,
      firstFetch: true,
    );
    // widget2.value = AppService.widgets.cards.cardWidget(
    //   context: Get.context!,
    //   title: "POP",
    //   content: [],
    //   icon: Icon(Icons.abc),
    //   effectcolor: Colors.black,
    //   firstFetch: true,
    // );
  }
}
