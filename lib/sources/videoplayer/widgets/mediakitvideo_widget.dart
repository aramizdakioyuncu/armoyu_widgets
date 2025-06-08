import 'package:armoyu_widgets/sources/videoplayer/videoplayer_bundle.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class MediaKitVideoControllerWrapper extends VideoplayerWidgetBundle {
  final Player player = Player();
  late final VideoController controller;

  MediaKitVideoControllerWrapper(String videoUrl) {
    controller = VideoController(player);
    player.open(Media(videoUrl));
    player.setPlaylistMode(PlaylistMode.loop);
  }

  @override
  Widget getVideoWidget() {
    return Video(
      fit: BoxFit.cover,
      controller: controller,
      controls: (state) {
        return SizedBox.shrink();
      },
    );
  }

  @override
  Future<void> play() async => player.play();

  @override
  Future<void> pause() async => player.pause();

  @override
  Future<void> pauseOrPlay() async => player.playOrPause();

  @override
  Future<void> setVolume(volume) async => player.setVolume(volume);

  @override
  Future<void> dispose() async {
    await player.dispose();
  }
}
