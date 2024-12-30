import 'package:get/get.dart';
import 'package:widgets/app/modules/home/views/home_view.dart';
import 'package:widgets/app/routes/app_route.dart';

class HomeModule {
  static const route = Routes.HOME;

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const HomeView(),
    ),
  ];
}
