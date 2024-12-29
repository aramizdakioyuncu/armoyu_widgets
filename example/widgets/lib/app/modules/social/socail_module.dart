import 'package:get/get.dart';
import 'package:widgets/app/modules/social/views/socail_view.dart';

class SocailModule {
  static const route = '/social';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const SocailView(),
    ),
  ];
}
