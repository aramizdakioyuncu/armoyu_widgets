import 'dart:io';

import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_mentions/flutter_mentions.dart';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:video_compress/video_compress.dart';

class PostcreateController extends GetxController {
  final ARMOYUServices service;

  var postsharetext = TextEditingController().obs;
  var media = <Media>[].obs;
  var postshareProccess = false.obs;
  var key = GlobalKey<FlutterMentionsState>().obs;
  var userLocation = Rx<String?>(null);

  PostcreateController({
    required this.service,
  });
  var currentUserAccounts = Rx<UserAccounts>(
    UserAccounts(
      user: User().obs,
      sessionTOKEN: Rx(""),
      language: Rxn(),
    ),
  );

  //Video Sıkıştırma işlemi
  Future<File?> compressAndGetVideo(File file) async {
    MediaInfo? mediaInfo = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.DefaultQuality,
      deleteOrigin: false, // It's false by default
    );

    return mediaInfo?.file;
  }

  //Görsel Sıkıştırma işlemi
  Future<XFile?> compressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 88,
      rotate: 180,
    );

    print(file.lengthSync());

    return result;
  }

  Future<void> sharePost() async {
    if (postshareProccess.value) {
      return;
    }

    postshareProccess.value = true;
    log("Post Share Proccess Started");

    log("Windows için sıkıştırma desteklenmiyor ve bu nedenle sıkıştırma atlanıyor.");
    if (!Platform.isWindows) {
      log("Sıkıştırma işlemi başlatılıyor...");
      await Future.wait(
        media.map((media) async {
          if (media.mediaType == MediaType.image) {
            if (media.mediaXFile != null) {
              final compressedFile = await compressAndGetFile(
                File(media.mediaXFile!.path),
                media.mediaXFile!.path.replaceAll('.jpg', '_compressed.jpg'),
              );
              log("Sıkıştırma işlemi tamamlandı: ${compressedFile?.path}");
              // Eğer sıkıştırma başarılı olduysa, mediaXFile'ı güncelle
              if (compressedFile != null) {
                media.mediaXFile = compressedFile;
              }
            }
          }

          if (media.mediaType == MediaType.video) {
            if (media.mediaXFile != null) {
              final compressedFile = await compressAndGetVideo(
                File(media.mediaXFile!.path),
              );
              log("Sıkıştırma işlemi tamamlandı: ${compressedFile?.path}");
              // Eğer sıkıştırma başarılı olduysa, mediaXFile'ı güncelle
              if (compressedFile != null) {
                media.mediaXFile = XFile(compressedFile.path);
              }
            }
          }
        }),
      );
    }

    PostShareResponse response = await service.postsServices.share(
      text: key.value.currentState!.controller!.text,
      files: media.map((media) => media.mediaXFile!).toList(),
      location: userLocation.value,
    );
    if (!response.result.status) {
      postsharetext.value.text = response.result.description.toString();
      postshareProccess.value = false;
      log("Post Share Proccess Failed: ${response.result.description}");
      return;
    }

    if (response.result.status) {
      postsharetext.value.text = response.result.description.toString();
      postshareProccess.value = false;
      log("Post Share Proccess Success: ${response.result.description}");
      Get.back(result: true);
    }
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
