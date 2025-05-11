import 'dart:async';

import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/data/models/music.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MusicplayerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final ARMOYUServices service;
  MusicplayerController(this.service);

  Rxn<List<Music>> musicList = Rxn();

  Timer? _timer;

  RxBool isVisible = false.obs;

  var playingmusic = false.obs;
  Rxn<int> musicIndex = Rxn();
  var musicCurrentPosition = Duration.zero.obs;
  var musicmaxPosition = Duration.zero.obs;

  var repeatplayer = false.obs;
  Rx<AudioPlayer> player = Rx(AudioPlayer());
  late AnimationController musicController;

  @override
  void onInit() {
    super.onInit();

    musicService();
    musicController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    musicController.forward();

    // Player completion event listener
    player.value.onPlayerComplete.listen((event) {
      // Müzik bittiğinde yeni müziği çal
      playingmusic.value = false; // Döngüyü kes

      if (repeatplayer.value) {
        playmusic();
        return;
      }
      playNextMusic();
    });

    updateCurrentPosition(); // Sürekli güncelle
  }

  @override
  void onClose() {
    super.onClose();
    _timer?.cancel();
    player.value.stop(); // Müzik çalmayı durdur
    player.value.dispose();

    musicController.stop();
    musicController.dispose();
  }

  void setMediaList(List<Music> list) {
    musicList.value = list;
    musicIndex.value = 0;
    updateCurrentPosition();
    musicService();
  }

  Future<void> updateCurrentPosition({bool onlyFirst = false}) async {
    if (musicIndex.value == null) {
      return;
    }
    if (onlyFirst) {
      musicCurrentPosition.value =
          (await player.value.getCurrentPosition()) ?? Duration.zero;

      musicmaxPosition.value =
          (await player.value.getDuration()) ?? Duration.zero;
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      musicCurrentPosition.value =
          (await player.value.getCurrentPosition()) ?? Duration.zero;

      musicmaxPosition.value =
          (await player.value.getDuration()) ?? Duration.zero;
    });
  }

  musicService() async {
    if (playingmusic.value || musicIndex.value == null) {
      return;
    }
    playmusic();
  }

  showmusicInfo() async {
    isVisible.value = true;
    await Future.delayed(Duration(seconds: 10));
    isVisible.value = false;
  }

  playmusic() async {
    if (playingmusic.value || musicIndex.value == null) {
      return;
    }

    playingmusic.value = true;
    musicController.forward();

    showmusicInfo();
    await player.value.play(
      musicList.value![musicIndex.value!].path != null
          ? AssetSource(musicList.value![musicIndex.value!].path!)
          : UrlSource(musicList.value![musicIndex.value!].pathURL!),
      volume: 0.3,
    );
  }

  shuffleplayer() {
    if (musicIndex.value == null) {
      return;
    }
    musicList.value!.shuffle();
    player.value.stop();
    playingmusic.value = false;
    playNextMusic();
  }

  playNextMusic({bool force = false}) async {
    if (musicIndex.value == null) {
      return;
    }
    musicIndex.value = musicIndex.value! + 1; // Bir sonraki müziğe geç
    if (musicList.value!.length <= musicIndex.value!) {
      musicIndex.value = 0; // Liste sonunda tekrar başa dön
    }
    if (force) {
      await player.value.stop();
      playingmusic.value = false;
    }
    // Yeni müziği çalmaya başla
    await playmusic();
  }

  playBackMusic({bool force = false}) async {
    if (musicIndex.value == null) {
      return;
    }
    musicIndex.value = musicIndex.value! - 1; // Bir önceki müziğe geç
    if (0 > musicIndex.value!) {
      musicIndex.value =
          musicList.value!.length - 1; // Liste sonunda tekrar başa dön
    }
    if (force) {
      await player.value.stop();
      playingmusic.value = false;
    }
    // Yeni müziği çalmaya başla
    await playmusic();
  }
}
