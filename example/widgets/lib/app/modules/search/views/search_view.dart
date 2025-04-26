import 'dart:developer';

import 'package:armoyu_services/core/models/ARMOYU/API/search/search_list.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/modules/search/controllers/search_controller.dart';
import 'package:widgets/app/services/app_service.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchViewController());
    final filteredItemsv2 = <APISearchDetail>[].obs;
    final allItemsv2 = <APISearchDetail>[].obs;
    var search = SearchController().obs;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        forceMaterialTransparency: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
              height: 200,
              width: 400,
              child: Obx(
                () => controller.widget3.value!,
              ),
            ),
          ),
          controller.cardWidget.widget.value!,
          controller.cardWidget2.widget.value!,
          AppService.widgets.searchBar.custom1(
            allItems: allItemsv2,
            filteredItems: filteredItemsv2,
            searchController: search.value,
            autofocus: true,
            itemSelected: (id, val, username, type) {
              log(id.toString());
              log(val.toString());
              log(username.toString());
              log(type.toString());
            },
          ),
        ],
      ),
    );
  }
}
