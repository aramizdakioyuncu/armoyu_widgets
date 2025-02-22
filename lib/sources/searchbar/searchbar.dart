import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/debouncer.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/search/search_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ARMOYUSearchType { group, user, station, food }

class ARMOYUSearchBar {
  final ARMOYUServices service;

  ARMOYUSearchBar(this.service);
  final Debouncer debouncer =
      Debouncer(delay: const Duration(milliseconds: 500));

  List<APISearchDetail> filter(List<APISearchDetail> users, String? value) {
    final o1 = users
        .where((element) =>
            element.value.toLowerCase().startsWith(value!.toLowerCase()))
        .toList();
    final o2 = users
        .where((element) =>
            element.value.toLowerCase().contains(value!.toLowerCase()))
        .toList();

    final result = o1;
    final temp = result.map((r) => r.id.toString()).toSet();

    for (APISearchDetail u in o2) {
      if (temp.add(u.id.toString())) {
        result.add(u);
      }
    }

    return result;
  }

  Widget custom1({
    required RxList<APISearchDetail> allItems,
    required RxList<APISearchDetail> filteredItems,
    required SearchController searchController,
    required Function(
            int id, String val, String username, ARMOYUSearchType type)?
        itemSelected,
    bool autofocus = false,
  }) {
    return SearchAnchor(
      searchController: searchController,
      viewHintText: 'Ara...',
      viewShape: const LinearBorder(),
      isFullScreen: false,
      viewConstraints: const BoxConstraints(maxHeight: 400),
      viewOnChanged: (value) {
        // Yerel filtreleme
        filteredItems.value = filter(allItems, value);
        filteredItems.refresh();

        if (value.length < 3) {
          // filteredItems.clear();
          return;
        }

        debouncer(() async {
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
          filteredItems.value = filter(allItems, value);
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

  // Widget buildStatefulWidget({
  //   required List<User> allItems,
  //   required List<User> filteredItems,
  //   required SearchController searchController,
  //   required Function(int id, String val)? itemSelected,
  //   bool autofocus = false,
  // }) {
  //   return MyStatefulWidget(
  //     allItems: allItems,
  //     searchController: searchController,
  //     service: service,
  //     itemSelected: itemSelected,
  //     autofocus: autofocus,
  //   );
  // }
}

// class MyStatefulWidget extends StatefulWidget {
//   final ARMOYUServices service;
//   final List<User> allItems;
//   final SearchController searchController;

//   final Function(int id, String val)? itemSelected;
//   final bool autofocus;
//   const MyStatefulWidget({
//     super.key,
//     required this.service,
//     required this.allItems,
//     required this.searchController,
//     required this.itemSelected,
//     required this.autofocus,
//   });

//   @override
//   MyStatefulWidgetState createState() => MyStatefulWidgetState();
// }

// class MyStatefulWidgetState extends State<MyStatefulWidget> {
//   late List<User> filteredItems;
//   late Debouncer debouncer;

//   @override
//   void initState() {
//     super.initState();
//     filteredItems = [];
//     debouncer = Debouncer(delay: const Duration(milliseconds: 500));
//     log("asd");

//     widget.searchController.addListener(() async {
//       final value = widget.searchController.text;
//       debugPrint("Value: $value");

//       if (value.length < 4) {
//         return;
//       }

//       filteredItems = widget.allItems
//           .where((element) =>
//               element.displayname!.toLowerCase().contains(value.toLowerCase()))
//           .toList();

//       // API'den veri çekme
//       SearchListResponse response = await widget.service.searchServices
//           .searchengine(searchword: value, page: 1);

//       if (response.result.status == false) {
//         log(response.result.description);
//         return;
//       }

//       List<User> items = [];

//       // Yeni kullanıcıları ekleme
//       for (APISearchDetail element in response.response!.search) {
//         if (!widget.allItems
//             .any((filterelement) => filterelement.userID == element.id)) {
//           items.add(
//             User(
//               userID: element.id,
//               displayname: element.value,
//               avatar: element.avatar,
//             ),
//           );
//         }
//       }

//       if (mounted) {
//         // Güncellenmiş filtreleme
//         filteredItems.assignAll(items.where((element) =>
//             element.displayname!.toLowerCase().contains(value.toLowerCase())));
//         setState(() {});
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SearchAnchor(
//       searchController: widget.searchController,
//       viewHintText: 'Ara...',
//       viewShape: const LinearBorder(),
//       isFullScreen: false,
//       viewConstraints: const BoxConstraints(maxHeight: 400),
//       builder: (context, controllerv2) {
//         return SearchBar(
//           controller: widget.searchController,
//           hintText: "Arama...",
//           autoFocus: widget.autofocus,
//           onChanged: (value) {
//             controllerv2.openView();
//             setState(() {});
//           },
//           onTap: () {
//             controllerv2.openView();
//           },
//         );
//       },
//       suggestionsBuilder: (context, controllerv2) {
//         final items = filteredItems.take(10).toList();

//         return [
//           SizedBox(
//             child: Wrap(
//               children: List.generate(
//                 items.length,
//                 (index) {
//                   return ListTile(
//                     leading: CircleAvatar(
//                       backgroundColor: Colors.transparent,
//                       foregroundImage: CachedNetworkImageProvider(
//                         items[index].avatar!,
//                       ),
//                     ),
//                     title: Text(
//                       items[index].displayname!,
//                     ),
//                     onTap: () {
//                       if (widget.itemSelected != null) {
//                         widget.itemSelected!(
//                           items[index].userID!,
//                           items[index].displayname!,
//                         );
//                       }
//                       widget.searchController.text = items[index].displayname!;
//                     },
//                   );
//                 },
//               ),
//             ),
//           ),
//         ];
//       },
//     );
//   }
// }
