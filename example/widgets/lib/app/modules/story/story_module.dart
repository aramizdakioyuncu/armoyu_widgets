import 'package:get/get.dart';
import 'package:widgets/app/modules/story/views/story_view.dart';

class StoryModule {
  static const route = '/story';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const StoryView(),
    ),
  ];
}
