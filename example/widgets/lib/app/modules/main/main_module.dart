import 'package:get/get.dart';
import 'package:widgets/app/modules/main/views/main_view.dart';
import 'package:widgets/app/routes/app_route.dart';

class MainModule {
  static const route = Routes.MAIN;

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const MainView(),
    ),
  ];
}
