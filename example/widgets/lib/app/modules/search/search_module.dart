import 'package:get/get.dart';
import 'package:widgets/app/modules/search/views/search_view.dart';
import 'package:widgets/app/routes/app_route.dart';

class SearchModule {
  static const route = Routes.SEARCH;

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const SearchView(),
    ),
  ];
}
