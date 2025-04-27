import 'package:get/get.dart';
import 'package:widgets/app/modules/notifications/views/notifications_view.dart';
import 'package:widgets/app/routes/app_route.dart';

class NotificationsModule {
  static const route = Routes.NOTIFICATIONS;

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const NotificationsView(),
    ),
  ];
}
