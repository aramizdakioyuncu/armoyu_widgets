import 'package:get/get.dart';
import 'package:widgets/app/modules/main/views/main_view.dart';

class MainModule {
  static const route = '/main';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const MainView(),
    ),
  ];
}
