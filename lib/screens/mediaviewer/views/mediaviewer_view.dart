import 'dart:io';

import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/screens/mediaviewer/controllers/mediaviewer_controller.dart';
import 'package:armoyu_widgets/sources/videoplayer/widgets/mediakitvideo_widget.dart';
import 'package:armoyu_widgets/sources/videoplayer/widgets/mobilevideo_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class PhotoviewerView extends StatelessWidget {
  final ARMOYUServices service;

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
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      PhotoviewerController(
        service: service,
        media: media,
        initialIndex: initialIndex,
      ),
      tag: media[initialIndex].mediaID.toString(),
    );

    return Scaffold(
      appBar: AppBar(
        actions: [
          Obx(
            () => controller.rxmedia.value![controller.currentIndex.value]
                        .ownerID !=
                    controller.currentUser!.userID
                ? SizedBox.shrink()
                : Visibility(
                    visible: controller.isRotationprocces.value,
                    child: const Column(
                      children: [
                        CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
          ),
          Obx(
            () => controller.rxmedia.value![controller.currentIndex.value]
                        .ownerID !=
                    controller.currentUser!.userID
                ? SizedBox.shrink()
                : Visibility(
                    visible: controller.isRotationedit.value &&
                        !controller.isRotationprocces.value,
                    child: IconButton(
                      onPressed: () async => await controller.rotatefunction(),
                      icon: const Icon(Icons.check),
                    ),
                  ),
          ),
          Obx(
            () => controller.rxmedia.value![controller.currentIndex.value]
                        .ownerID !=
                    controller.currentUser!.userID
                ? SizedBox.shrink()
                : Visibility(
                    visible: (controller
                                    .rxmedia
                                    .value![controller.currentIndex.value]
                                    .ownerID ==
                                controller.currentUser!.userID) &&
                            !controller.isRotationprocces.value
                        ? true
                        : false,
                    child: IconButton(
                      icon: const Icon(Icons.crop_rotate_outlined),
                      onPressed: () async {
                        controller.isRotationedit.value =
                            !controller.isRotationedit.value;
                        controller.mediaAngle.value = 0;
                      },
                    ),
                  ),
          ),
        ],
      ),
      body: Obx(
        () => Stack(
          children: [
            Transform.rotate(
              angle: controller.mediaAngle.value,
              child: PageView.builder(
                physics: controller.isRotationedit.value
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(),
                controller: controller.pageController,
                itemCount: controller.rxmedia.value!.length,
                itemBuilder: (context, index) {
                  if (controller.rxmedia.value![index].mediaType ==
                      MediaType.video) {
                    if (Platform.isWindows) {
                      controller.videoWidget = MediaKitVideoControllerWrapper(
                          controller
                              .rxmedia.value![index].mediaURL.normalURL.value);
                    } else {
                      final mobile = MobileVideoControllerWrapper(controller
                          .rxmedia.value![index].mediaURL.normalURL.value);
                      controller.videoWidget = mobile;

                      mobile.initialize(mute: true);
                    }
                    return controller.videoWidget!.getVideoWidget();
                  }

                  ImageProvider imageProvider;

                  if (isFile!) {
                    imageProvider = FileImage(
                      File(
                        controller.rxmedia.value![index].mediaURL.bigURL.value,
                      ),
                    );
                  } else if (isMemory!) {
                    imageProvider = MemoryImage(
                      controller.rxmedia.value![index].mediaBytes!,
                    );
                  } else {
                    imageProvider = CachedNetworkImageProvider(
                      controller.rxmedia.value![index].mediaURL.bigURL.value,
                    );
                  }

                  return PhotoView(
                    imageProvider: imageProvider,
                    initialScale: PhotoViewComputedScale.contained * 1,
                    heroAttributes: PhotoViewHeroAttributes(
                      tag: controller.rxmedia.value![index].mediaID,
                    ),
                    loadingBuilder: (context, event) => const Center(
                      child: SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CupertinoActivityIndicator(),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (controller.rxmedia.value![controller.currentIndex.value]
                        .ownerID ==
                    controller.currentUser!.userID &&
                controller.isRotationedit.value &&
                !controller.isRotationprocces.value)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            controller.turnleft();
                          },
                          icon: const Icon(Icons.rotate_left_sharp),
                        ),
                        IconButton(
                          onPressed: () => controller.turnright(),
                          icon: const Icon(Icons.rotate_right_sharp),
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
