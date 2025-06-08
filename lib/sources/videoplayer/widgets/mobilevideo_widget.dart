import 'dart:async';

import 'package:armoyu_widgets/sources/videoplayer/videoplayer_bundle.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class MobileVideoControllerWrapper extends VideoplayerWidgetBundle {
  final String videoUrl; // URL'yi ayrıca tutuyoruz

  late final VideoPlayerController player;

  MobileVideoControllerWrapper(this.videoUrl) {
    player = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
  }

  var isInitialized = false.obs;
  var isValidVideo = true.obs;
  var isMuted = false.obs;
  var currentPosition = 0.0.obs;
  late Timer positionTimer;
  Future<void> initialize({bool mute = false}) async {
    try {
      await player.initialize();
      listenToPlayer();
      isInitialized.value = true;
      player.setLooping(true);
      if (mute) await setVolume(0);
      player.play();
    } catch (e) {
      // Bu bir video değilmiş
      isValidVideo.value = false;
    }
  }

  void listenToPlayer() {
    player.addListener(() {
      if (player.value.isInitialized) {
        currentPosition.value = player.value.position.inMilliseconds.toDouble();
      }
    });
  }

  @override
  Widget getVideoWidget() {
    return Obx(() {
      if (!isValidVideo.value) {
        return CachedNetworkImage(
          imageUrl: videoUrl,
          fit: BoxFit.cover,
        );
      }
      if (!isInitialized.value) {
        return Center(
          child: CupertinoActivityIndicator(),
        );
      }

      return Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: player.value.size.width,
              height: player.value.size.height,
              child: VideoPlayer(player),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Obx(() {
              if (isMuted.value) {
                return IconButton(
                  icon: Icon(Icons.volume_off, color: Colors.white),
                  onPressed: () async {
                    await setVolume(1.0);
                  },
                );
              }
              return SizedBox.shrink();
            }),
          ),
          if (1 == 1)
            Align(
              alignment: Alignment.bottomCenter,
              child: VideoProgressIndicator(
                player,
                allowScrubbing: true,
                colors: VideoProgressColors(
                  playedColor: Colors.white,
                  bufferedColor: Colors.grey,
                  backgroundColor: Colors.black54,
                ),
              ),
            ),
          if (1 == 1)
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 5,
                child: SliderTheme(
                  data: SliderTheme.of(Get.context!).copyWith(
                    thumbShape: SliderComponentShape.noThumb,
                    padding: EdgeInsets.all(0),
                  ),
                  child: Slider(
                    padding: EdgeInsets.all(0),

                    divisions: null, // Bu şekilde smooth olur
                    min: 0,
                    max: player.value.duration.inMilliseconds.toDouble(),
                    value: currentPosition.value.clamp(
                        0, player.value.duration.inMilliseconds.toDouble()),
                    onChanged: (value) {
                      player.seekTo(Duration(milliseconds: value.toInt()));
                      currentPosition.value =
                          value; // Kullanıcı kaydırınca da güncelle
                    },
                    activeColor: Colors.red,
                    inactiveColor: Colors.grey,
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }

  @override
  Future<void> play() async => player.play();

  @override
  Future<void> pause() async => player.pause();

  @override
  Future<void> pauseOrPlay() async {
    if (player.value.isPlaying) {
      await player.pause();
    } else {
      await player.play();
    }
  }

  @override
  Future<void> setVolume(volume) async {
    if (volume < 0 || volume > 100) {
      throw ArgumentError('Volume must be between 0 and 1');
    }
    if (volume < 0.01) {
      isMuted.value = true;
    } else {
      isMuted.value = false;
    }
    await player.setVolume(volume);
  }

  @override
  Future<void> dispose() async => player.dispose();
}
