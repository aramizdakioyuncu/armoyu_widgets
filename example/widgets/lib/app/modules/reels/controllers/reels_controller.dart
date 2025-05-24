import 'dart:developer';

import 'package:armoyu_widgets/sources/reels/bundle/reels_bundle.dart';
import 'package:get/get.dart';
import 'package:widgets/app/services/app_service.dart';

class ARMOYUReelsController extends GetxController {
  late ReelsWidgetBundle reelswidget;
  @override
  void onInit() {
    super.onInit();

    reelswidget = AppService.widgets.reels.reels(
      Get.context!,
      profileFunction: (
          {required avatar,
          required banner,
          required displayname,
          required userID,
          required username}) {
        log(userID.toString());
      },
    );
  }

  back() async {
    await reelswidget.back();
  }

  next() async {
    await reelswidget.next();
  }
}
