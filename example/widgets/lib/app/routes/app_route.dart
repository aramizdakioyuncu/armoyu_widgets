// ignore_for_file: constant_identifier_names

import 'package:widgets/app/modules/chat/chat_module.dart';
import 'package:widgets/app/modules/home/home_module.dart';
import 'package:widgets/app/modules/main/main_module.dart';
import 'package:widgets/app/modules/posts/posts_module.dart';
import 'package:widgets/app/modules/profile/profile_module.dart';
import 'package:widgets/app/modules/social/socail_module.dart';
import 'package:widgets/app/modules/story/story_module.dart';

class Routes {
  static const HOME = "/home";
  static const MAIN = "/main";
  static const POSTS = "/posts";
  static const STORY = "/story";
  static const SOCIAL = "/social";
  static const CHAT = "/chat";
  static const CHATDETAIL = "/chat/detail";
  static const CHATCALL = "/chat/call";
  static const PROFILE = "/profile";
}

class AppRoute {
  static const initial = HomeModule.route;

  static final routes = [
    ...HomeModule.routes,
    ...MainModule.routes,
    ...PostsModule.routes,
    ...StoryModule.routes,
    ...SocailModule.routes,
    ...ChatModule.routes,
    ...ProfileModule.routes,
  ];
}
