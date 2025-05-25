import 'dart:io';

import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/core/appcore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart' as armoyumedia;

class MedialistController extends GetxController {
  final ARMOYUServices service;

  void Function(List<armoyumedia.Media> mediaList)? onListUpdated;
  MedialistController({required this.service, required this.onListUpdated});

  Rx<double> imgheight = Rx(100);
  Rx<double> imgwidgth = Rx(100);
  Rx<double> closeSize = Rx(16);

  var scrollController = ScrollController().obs;

  var mediaList = <MediaList>[].obs;

  @override
  // ignore: unnecessary_overrides
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    //KRİTİK
    for (var element in mediaList) {
      if (element.player != null) {
        element.player!.dispose(); // Her player'ı dispose et
      }
    }

    super.onClose();
  }

  pickfile() async {
    // //Multiples File Picker// //Multiples File Picker// //Multiples File Picker

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'webp'],
    );

    if (result == null) {
      return;
    }

    if (kDebugMode) {
      PlatformFile file = result.files.first;
      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
    }

    for (PlatformFile element in result.files) {
      final videoPlayerController = Player();
      final videoController = VideoController(videoPlayerController);

      videoPlayerController.open(
        Media(element.path!),
        play: false,
      );

      mediaList.add(
        MediaList(
          armoyumedia.Media(
            mediaID: element.hashCode,
            mediaType:
                (element.extension == "mp4" || element.extension == "webp")
                    ? armoyumedia.MediaType.video
                    : armoyumedia.MediaType.image,
            mediaXFile: XFile(element.path!),
            mediaURL: armoyumedia.MediaURL(
              bigURL: Rx<String>(element.path!),
              normalURL: Rx<String>(element.path!),
              minURL: Rx<String>(element.path!),
            ),
          ),
          videoPlayerController,
          videoController,
        ),
      );

      mediaList.refresh();
    }

    // list = mediaList.map((e) => e.media).toList().obs;
    onListUpdated?.call(
      mediaList.map((e) => e.media).toList(),
    );
  }

  playorpauseorcrop(index, editable) async {
    if (mediaList[index].media.mediaType == armoyumedia.MediaType.video) {
      for (var element in mediaList) {
        if (element != mediaList[index]) {
          if (element.player != null) {
            element.player!.pause();
          }
        }
      }
      //Video Oynat
      if (mediaList[index].player != null) {
        await mediaList[index].player!.playOrPause();
      }
      return;
    }

    if (Platform.isWindows) {
      //Kırpma İşlemi Windows için desteklenmiyor
      return;
    }
    if (editable) {
      //Kırpma İşlemi
      XFile? selectedCroppedImage = await AppCore.cropperImage(
        XFile(mediaList[index].media.mediaURL.bigURL.value),
      );
      if (selectedCroppedImage == null) {
        return;
      }
      mediaList[index].media.mediaXFile = selectedCroppedImage;
      //Kırpma İşlemi
      mediaList.refresh();
      return;
    }
    // list = mediaList.map((e) => e.media).toList().obs;
  }

  removelist(index) {
    try {
      mediaList.removeAt(index);
      log("media listeden silindi");
    } catch (e) {
      log(e.toString());
    }

    mediaList.refresh();
    // list = mediaList.map((e) => e.media).toList().obs;
  }
}

class MediaList {
  final armoyumedia.Media media;
  Player? player;
  VideoController? videoController;
  MediaList(this.media, this.player, this.videoController);
}
