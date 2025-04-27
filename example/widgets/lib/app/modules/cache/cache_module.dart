import 'package:get/get.dart';
import 'package:widgets/app/modules/cache/views/cache_view.dart';
import 'package:widgets/app/routes/app_route.dart';

class CacheModule {
  static const route = Routes.CACHE;

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const CacheView(),
    ),
  ];
}
