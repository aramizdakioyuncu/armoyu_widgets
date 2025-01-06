import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:widgets/app/modules/profile/views/profile_view.dart';
import 'package:widgets/app/routes/app_route.dart';

class ProfileModule {
  static const route = Routes.PROFILE;

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const ProfileView(),
    ),
  ];
}
