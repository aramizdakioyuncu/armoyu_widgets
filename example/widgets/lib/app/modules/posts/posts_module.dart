import 'package:get/get.dart';
import 'package:widgets/app/modules/posts/views/posts_view.dart';
import 'package:widgets/app/routes/app_route.dart';

class PostsModule {
  static const route = Routes.POSTS;

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const PostsView(),
    ),
  ];
}
