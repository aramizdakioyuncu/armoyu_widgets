import 'package:get/get.dart';
import 'package:widgets/app/modules/reels/views/reels_view.dart';
import 'package:widgets/app/routes/app_route.dart';

class ReelsModule {
  static const route = Routes.REELS;

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const ReelsView(),
    ),
  ];
}
