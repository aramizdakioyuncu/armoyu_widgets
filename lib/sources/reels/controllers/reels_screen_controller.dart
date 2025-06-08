import 'dart:io';

import 'package:armoyu_widgets/data/models/reels.dart';
import 'package:armoyu_widgets/sources/videoplayer/videoplayer_bundle.dart';
import 'package:armoyu_widgets/sources/videoplayer/widgets/mediakitvideo_widget.dart';
import 'package:armoyu_widgets/sources/videoplayer/widgets/mobilevideo_widget.dart';
import 'package:get/get.dart';

class ReelsScreenController extends GetxController {
  final Reels reels;

  ReelsScreenController({required this.reels});

  late final VideoplayerWidgetBundle videoController;
  @override
  void onInit() {
    if (Platform.isWindows) {
      videoController = MediaKitVideoControllerWrapper(reels.videoUrl);
    } else {
      final mobile = MobileVideoControllerWrapper(reels.videoUrl);
      videoController = mobile;
      mobile.initialize(); // sadece mobile initialize gerekiyor
    }
    super.onInit();
  }

  Reels profileFunction() {
    return reels;
  }

  stopReels() async {
    await videoController.pause();
  }

  startReels() async {
    await videoController.play();
  }

  @override
  void onClose() {
    videoController.dispose();
    super.onClose();
  }
}
