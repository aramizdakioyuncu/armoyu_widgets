import 'package:widgets/app/modules/home/home_module.dart';
import 'package:widgets/app/modules/main/main_module.dart';
import 'package:widgets/app/modules/posts/posts_module.dart';
import 'package:widgets/app/modules/social/socail_module.dart';
import 'package:widgets/app/modules/story/story_module.dart';

class AppRoute {
  static const initial = HomeModule.route;

  static final routes = [
    ...HomeModule.routes,
    ...MainModule.routes,
    ...PostsModule.routes,
    ...StoryModule.routes,
    ...SocailModule.routes,
  ];
}
