import 'package:get/get.dart';
import 'package:widgets/app/modules/story/views/story_view.dart';
import 'package:widgets/app/routes/app_route.dart';

class StoryModule {
  static const route = Routes.STORY;

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const StoryView(),
    ),
  ];
}
