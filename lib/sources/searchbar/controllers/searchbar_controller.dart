import 'package:armoyu_services/core/debouncer.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/search/search_list.dart';
import 'package:get/get.dart';

class SearchbarController extends GetxController {
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
}
