import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/sources/reels/bundle/reels_bundle.dart';
import 'package:armoyu_widgets/sources/reels/controllers/reels_controller.dart';
import 'package:armoyu_widgets/sources/reels/controllers/reels_screen_controller.dart';
import 'package:armoyu_widgets/sources/reels/widgets/reels_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ReelsWidget {
  final ARMOYUServices service;

  const ReelsWidget(this.service);

  ReelsWidgetBundle reels(
    BuildContext context, {
    required Function({
      required int userID,
      required String username,
      required String? displayname,
      required Media? avatar,
      required Media? banner,
    }) profileFunction,
  }) {
    final controller = Get.put(ReelsController(service: service));

    Widget widget = Obx(
      () => controller.reelsList.value == null
          ? Center(
              child: CupertinoActivityIndicator(),
            )
          : PageView(
              scrollDirection: Axis.vertical,
              controller: controller.pageController,
              onPageChanged: (newIndex) {
                if (newIndex == controller.pageIndex.value) return;

                // Eski sayfadaki videoyu durdur
                final oldTag = controller.pageIndex.value.toString();
                if (Get.isRegistered<ReelsScreenController>(tag: oldTag)) {
                  Get.find<ReelsScreenController>(tag: oldTag).stopReels();
                }

                controller.pageIndex.value = newIndex;

                // Yeni sayfadaki videoyu başlat
                final newTag = newIndex.toString();
                if (Get.isRegistered<ReelsScreenController>(tag: newTag)) {
                  Get.find<ReelsScreenController>(tag: newTag).startReels();
                }
              },
              children: List.generate(
                controller.reelsList.value!.length,
                (index) {
                  return ReelsScreen(
                    reels: controller.reelsList.value![index],
                    index: index,
                    profileFunction: profileFunction,
                  );
                },
              ),
            ),
    );

    return ReelsWidgetBundle(
      widget: Rxn(widget),
      next: () async => controller.nextReels(),
      back: () async => controller.backReels(),
    );
  }
}
