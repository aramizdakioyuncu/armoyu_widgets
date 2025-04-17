import 'package:armoyu_widgets/core/armoyu.dart';
import 'package:armoyu_widgets/translations/app_translation.dart';
import 'package:armoyu_widgets/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/modules/profile/controllers/profile_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return PageView(
      controller: PageController(initialPage: 0),
      children: [
        DefaultTabController(
          length: 3, // Tab sayısı
          child: Scaffold(
            body: NestedScrollView(
              physics: const ClampingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: ARMOYU.screenHeight * 0.25,
                    flexibleSpace: FlexibleSpaceBar(
                      background: GestureDetector(
                        child: CachedNetworkImage(
                          imageUrl: controller.currentUserAccounts.value.user
                              .value.banner!.mediaURL.minURL.value,
                        ),
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _TabBarDelegate(controller.tabController),
                  ),
                ];
              },
              body: TabBarView(
                controller: controller.tabController,
                children: [
                  Obx(
                    () => controller.posts1.widget.value ?? Container(),
                  ),
                  Obx(
                    () => controller.widget2.value ?? Container(),
                  ),
                  Obx(
                    () => controller.posts3.widget.value ?? Container(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;

  _TabBarDelegate(this.tabController);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: Get.theme.scaffoldBackgroundColor,
      child: TabBar(
        controller: tabController,
        tabs: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText.costum1(ProfileKeys.profilePosts.tr, size: 15.0),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText.costum1(ProfileKeys.profileMedia.tr, size: 15.0),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                CustomText.costum1(ProfileKeys.profileMentions.tr, size: 15.0),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 50.0;

  @override
  double get minExtent => 50.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
