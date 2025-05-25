import 'package:armoyu_widgets/data/models/reels.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class ReelsScreenController extends GetxController {
  final Reels reels;

  ReelsScreenController({required this.reels});
  late final videoPlayerController = Player();
  late final videoController = VideoController(videoPlayerController);
  @override
  void onInit() {
    videoPlayerController.open(
      Media(reels.videoUrl),
    );

    videoPlayerController.setPlaylistMode(PlaylistMode.loop);
    reels.commentCount = reels.commentCount + 1;
    super.onInit();
  }

  Reels profileFunction() {
    return reels;
  }

  stopReels() async {
    await videoPlayerController.pause();
  }

  startReels() async {
    await videoPlayerController.play();
  }

  @override
  void onClose() {
    videoPlayerController.dispose();

    super.onClose();
  }
}
