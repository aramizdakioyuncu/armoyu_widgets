import 'package:get/get.dart';
import 'package:widgets/app/modules/posts/views/posts_view.dart';

class PostsModule {
  static const route = '/posts';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const PostsView(),
    ),
  ];
}
