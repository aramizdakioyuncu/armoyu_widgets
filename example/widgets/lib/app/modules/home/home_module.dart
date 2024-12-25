import 'package:get/get.dart';
import 'package:widgets/app/modules/home/views/home_view.dart';

class HomeModule {
  static const route = '/home';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const HomeView(),
    ),
  ];
}
