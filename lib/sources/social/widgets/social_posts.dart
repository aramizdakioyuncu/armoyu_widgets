import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/Social/post.dart';
import 'package:armoyu_widgets/sources/social/bundle/posts_bundle.dart';
import 'package:armoyu_widgets/sources/social/controllers/post_controller.dart';
import 'package:armoyu_widgets/widgetsv2/post/post_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

PostsWidgetBundle widgetSocialPosts(
  service, {
  Key? key,
  required BuildContext context,
  required Function({
    required int userID,
    required String username,
    required String? displayname,
    required Media? avatar,
    required Media? banner,
  }) profileFunction,
  ScrollController? scrollController,
  List<Post>? cachedpostsList,
  Function(List<Post> updatedPosts)? onPostsUpdated,
  Function? refreshPosts,
  bool isPostdetail = false,
  String? category,
  int? userID,
  String? username,
  bool shrinkWrap = false,
  EdgeInsetsGeometry padding = EdgeInsets.zero,
  ScrollPhysics physics = const ClampingScrollPhysics(),
  bool sliverWidget = false,
  bool autofetchposts = true,
}) {
  final controller = Get.put(
    PostController(
      service: service,
      scrollController: scrollController,
      category: category,
      userID: userID,
      username: username,
      cachedpostsList: cachedpostsList,
      onPostsUpdated: onPostsUpdated,
      autofetchposts: autofetchposts,
    ),
    tag:
        "postWidget-$category$userID-Uniq-${DateTime.now().millisecondsSinceEpoch}",
  );

  Widget widget = Obx(
    () => controller.postsList.value == null
        ? const Center(
            child: CupertinoActivityIndicator(),
          )
        : !sliverWidget
            ? ListView.builder(
                controller:
                    shrinkWrap ? null : controller.xscrollController.value,
                key: key,
                shrinkWrap: shrinkWrap,
                padding: padding,
                physics:
                    shrinkWrap ? const NeverScrollableScrollPhysics() : physics,
                itemCount: controller.postsList.value!.length,
                itemBuilder: (context, postIndex) {
                  var postdetail =
                      Rx<Post>(controller.postsList.value![postIndex]);

                  return PostWidget.postWidget(
                    service: service,
                    postdetail: postdetail,
                    controller: controller,
                    profileFunction: profileFunction,
                    showPOPcard: postIndex % 5 == 0 && postIndex != 0,
                    showTPcard: postIndex % 5 == 3 && postIndex != 0,
                  );
                },
              )
            : CustomScrollView(
                physics: refreshPosts != null
                    ? const BouncingScrollPhysics()
                    : const ClampingScrollPhysics(),
                slivers: [
                  refreshPosts != null
                      ? CupertinoSliverRefreshControl(
                          onRefresh: () async {
                            await refreshPosts();
                          },
                        )
                      : const SliverToBoxAdapter(child: SizedBox.shrink()),
                  SliverToBoxAdapter(
                    child: ListView.builder(
                      controller: shrinkWrap
                          ? null
                          : controller.xscrollController.value,
                      key: key,
                      shrinkWrap: shrinkWrap,
                      padding: padding,
                      physics: shrinkWrap
                          ? const NeverScrollableScrollPhysics()
                          : physics,
                      itemCount: controller.postsList.value!.length,
                      itemBuilder: (context, postIndex) {
                        var postdetail =
                            Rx<Post>(controller.postsList.value![postIndex]);
                        return PostWidget.postWidget(
                          service: service,
                          postdetail: postdetail,
                          controller: controller,
                          profileFunction: profileFunction,
                          showPOPcard: postIndex % 5 == 0 && postIndex != 0,
                          showTPcard: postIndex % 5 == 3 && postIndex != 0,
                        );
                      },
                    ),
                  ),
                ],
              ),
  );

  return PostsWidgetBundle(
    widget: Rxn(widget),
    refresh: () async => await controller.refreshAllPosts(),
    loadMore: () async => await controller.loadMorePosts(),
  );
}
