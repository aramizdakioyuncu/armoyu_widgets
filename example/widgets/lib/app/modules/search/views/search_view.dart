import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/modules/search/controllers/search_controller.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchViewController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        forceMaterialTransparency: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => controller.widget3.value!,
          ),
          Obx(
            () => controller.widget.value!,
          ),
          Obx(
            () => controller.widget2.value!,
          ),
        ],
      ),
    );
  }
}
