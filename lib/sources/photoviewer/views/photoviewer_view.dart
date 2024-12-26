import 'dart:io';
import 'dart:math';

import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/sources/photoviewer/controllers/photoviewer_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoviewerView extends StatelessWidget {
  final ARMOYUServices service;

  final int currentUserID;
  final List<Media> media; // Gezdirilecek fotoğrafların ID listesi
  final int initialIndex; // Başlangıçtaki fotoğrafin indexi
  final bool? isFile; // Yerel mi
  final bool? isMemory;
  const PhotoviewerView({
    super.key,
    required this.service,
    required this.media,
    required this.initialIndex,
    this.isFile = false,
    this.isMemory = false,
    required this.currentUserID,
  });

  Widget build(BuildContext context) {
    final controller = Get.put(PhotoviewerController());
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: ARMOYU.appbarColor,
        actions: <Widget>[
          Visibility(
            visible: controller.isRotationprocces,
            child: const Column(
              children: [
                CircularProgressIndicator(
                  color: Colors.red,
                ),
              ],
            ),
          ),
          Visibility(
            visible: controller.isRotationedit && !controller.isRotationprocces,
            child: Column(
              children: [
                IconButton(
                  onPressed: () {
                    controller.mediaAngle -= pi / 2;
                    controller.rotateangle -= 90;
                  },
                  icon: const Icon(Icons.rotate_left_sharp),
                ),
              ],
            ),
          ),
          Visibility(
            visible: controller.isRotationedit && !controller.isRotationprocces,
            child: Column(
              children: [
                IconButton(
                  onPressed: () {
                    controller.mediaAngle += pi / 2;
                    controller.rotateangle += 90;
                  },
                  icon: const Icon(Icons.rotate_right_sharp),
                ),
              ],
            ),
          ),
          Visibility(
            visible: controller.isRotationedit && !controller.isRotationprocces,
            child: Column(
              children: [
                IconButton(
                  onPressed: () async {
                    if (controller.isRotationprocces) {
                      return;
                    }
                    controller.isRotationprocces = true;

                    MediaRotationResponse response =
                        await service.mediaServices.rotation(
                      mediaID: media[initialIndex].mediaID,
                      rotate: 360 - (controller.rotateangle % 360),
                    );

                    if (!response.result.status) {
                      controller.mediaAngle = 0;
                      controller.isRotationedit = false;
                      controller.isRotationprocces = false;
                      return;
                    }

                    controller.isRotationedit = false;
                    controller.isRotationprocces = false;
                  },
                  icon: const Icon(Icons.check),
                ),
              ],
            ),
          ),
          Visibility(
            visible: (media[initialIndex].ownerID == currentUserID) &&
                    !controller.isRotationprocces
                ? true
                : false,
            child: IconButton(
              icon: const Icon(Icons.crop_rotate_outlined),
              onPressed: () async {
                controller.isRotationedit = !controller.isRotationedit;
                controller.mediaAngle = 0;
              },
            ),
          ),
        ],
      ),
      body: Transform.rotate(
        angle: controller.mediaAngle,
        child: PhotoViewGallery.builder(
          scrollPhysics: controller.isRotationedit
              ? const NeverScrollableScrollPhysics()
              : const BouncingScrollPhysics(),
          pageController: PageController(initialPage: initialIndex),
          itemCount: media.length,
          backgroundDecoration: BoxDecoration(
            color: Get.theme.scaffoldBackgroundColor,
          ),
          builder: (BuildContext context, int index) {
            ImageProvider imageProvider;

            if (isFile!) {
              imageProvider = FileImage(
                File(
                  media[index].mediaURL.bigURL.value,
                ),
              );
            } else if (isMemory!) {
              imageProvider = MemoryImage(
                media[index].mediaBytes!,
              );
            } else {
              imageProvider = CachedNetworkImageProvider(
                media[index].mediaURL.bigURL.value,
              );
            }

            return PhotoViewGalleryPageOptions(
              imageProvider: imageProvider,
              initialScale: PhotoViewComputedScale.contained * 1,
              heroAttributes:
                  PhotoViewHeroAttributes(tag: media[index].mediaID),
            );
          },
          loadingBuilder: (context, event) => const Center(
            child: SizedBox(
              width: 20.0,
              height: 20.0,
              child: CupertinoActivityIndicator(),
            ),
          ),
          // onPageChanged: onPageChanged,
        ),
      ),
    );
  }
}
