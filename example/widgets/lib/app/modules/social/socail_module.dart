import 'package:get/get.dart';
import 'package:widgets/app/modules/social/views/socail_view.dart';
import 'package:widgets/app/routes/app_route.dart';

class SocailModule {
  static const route = Routes.SOCIAL;

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const SocailView(),
    ),
  ];
}
