import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/search/search_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/sources/searchbar/controllers/searchbar_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ARMOYUSearchType { group, user, station, food }

class ARMOYUSearchBar {
  final ARMOYUServices service;

  ARMOYUSearchBar(this.service);

  Widget custom1({
    required RxList<APISearchDetail> allItems,
    required RxList<APISearchDetail> filteredItems,
    required SearchController searchController,
    required Function(
            int id, String val, String username, ARMOYUSearchType type)?
        itemSelected,
    bool autofocus = false,
  }) {
    final controller = Get.put(SearchbarController());
    return SearchAnchor(
      searchController: searchController,
      viewHintText: 'Ara...',
      viewShape: const LinearBorder(),
      isFullScreen: false,
      viewConstraints: const BoxConstraints(maxHeight: 400),
      viewOnChanged: (value) {
        // Yerel filtreleme
        filteredItems.value = controller.filter(allItems, value);
        filteredItems.refresh();

        if (value.length < 3) {
          // filteredItems.clear();
          return;
        }

        controller.debouncer(() async {
          // API'den veri çekme
          SearchListResponse response = await service.searchServices
              .searchengine(searchword: value, page: 1);

          if (response.result.status == false) {
            log(response.result.description);
            return;
          }

          // Yeni kullanıcıları ekleme
          for (APISearchDetail element in response.response!.search) {
            if (!allItems
                .any((filterelement) => filterelement.id == element.id)) {
              allItems.add(
                APISearchDetail(
                  id: element.id,
                  value: element.value,
                  avatar: element.avatar,
                  username: element.username,
                  turu: element.turu,
                ),
              );
            }
          }

          // Güncellenmiş filtreleme
          filteredItems.value = controller.filter(allItems, value);
          filteredItems.refresh();
        });
      },
      builder: (context, controllerv2) {
        return SearchBar(
          controller: searchController,
          hintText: "Arama...",
          autoFocus: autofocus,
          onChanged: (value) {
            controllerv2.openView();
          },
          onTap: () {
            controllerv2.openView();
          },
        );
      },
      suggestionsBuilder: (context, controllerv2) {
        return [
          Obx(
            () => SizedBox(
              child: Wrap(
                children: List.generate(
                  filteredItems.length.clamp(0, 10),
                  (index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        foregroundImage: CachedNetworkImageProvider(
                          filteredItems[index].avatar!,
                        ),
                      ),
                      title: Text(
                        filteredItems[index].value,
                      ),
                      onTap: () {
                        if (itemSelected != null) {
                          itemSelected(
                            filteredItems[index].id,
                            filteredItems[index].value,
                            filteredItems[index].username!,
                            filteredItems[index].turu == "oyuncu"
                                ? ARMOYUSearchType.user
                                : ARMOYUSearchType.group,
                          );
                        }
                        searchController.text = filteredItems[index].value;
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ];
      },
    );
  }
}
