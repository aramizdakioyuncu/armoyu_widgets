import 'package:get/get.dart';
import 'package:widgets/app/modules/posts/postcreate/views/postcreate_view.dart';
import 'package:widgets/app/modules/posts/postdetail/views/postdetail_view.dart';
import 'package:widgets/app/modules/posts/_main/views/posts_view.dart';
import 'package:widgets/app/modules/posts/postprofile/views/postprofile_view.dart';
import 'package:widgets/app/routes/app_route.dart';

class PostsModule {
  static const route = Routes.POSTS;

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const PostsView(),
    ),
    GetPage(
      name: "$route/create",
      page: () => const PostcreateView(),
    ),
    GetPage(
      name: "$route/detail",
      page: () => const PostdetailView(),
    ),
    GetPage(
      name: "$route/profile",
      page: () => const PostprofileView(),
    ),
  ];
}
