import 'dart:io';

import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart' as armoyumedia;
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/sources/gallery/widgets/medialist/controllers/medialist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit_video/media_kit_video.dart';

Widget widgetMediaList({
  required ARMOYUServices service,
  required BuildContext context,
  void Function(List<armoyumedia.Media> mediaList)? onListUpdated,
  bool big = false,
  bool editable = false,
}) {
  final findCurrentAccountController = Get.find<AccountUserController>();

  User currentUser =
      findCurrentAccountController.currentUserAccounts.value.user.value;
  final controller = Get.put(
      MedialistController(service: service, onListUpdated: onListUpdated),
      tag: "medialist-${currentUser.userID}");

  if (big) {
    controller.imgheight.value = MediaQuery.of(context).size.height * 0.6;
    controller.imgwidgth.value = MediaQuery.of(context).size.width * 0.5;
    controller.closeSize.value = 30;
  }

  return LayoutBuilder(
    builder: (context, constraints) {
      if (big) {
        // Ekran genişliği
        final screenWidth = constraints.maxWidth;

        // Kaç kutu sığacak (örnek: 3)
        const itemPerRow = 3;

        // Dinamik genişlik hesapla
        final itemWidth = screenWidth / itemPerRow;

        // Bu değeri controller içine bile set edebilirsin istersen
        controller.imgwidgth.value = itemWidth;
      }

      return SizedBox(
        height: controller.imgheight.value,
        child: Scrollbar(
          controller: controller.scrollController.value,
          child: Obx(
            () => ListView.builder(
              controller: controller.scrollController.value,
              scrollDirection: Axis.horizontal,
              itemCount: controller.mediaList.length + 1,
              itemBuilder: (context, index) {
                if (index + 1 == controller.mediaList.length + 1) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: controller.imgwidgth.value,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.black,
                        ),
                      ),
                      child: InkWell(
                        onTap: () async => controller.pickfile(),
                        child: const Icon(Icons.add_a_photo_rounded),
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () async =>
                        controller.playorpauseorcrop(index, editable),
                    child: Container(
                      width: controller.imgwidgth.value,
                      height: controller.imgheight.value,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                      child: Stack(
                        children: [
                          controller.mediaList[index].media.mediaXFile != null
                              ? controller.mediaList[index].media.mediaType ==
                                      armoyumedia.MediaType.image
                                  ? Image.file(
                                      File(
                                        controller.mediaList[index].media
                                            .mediaXFile!.path,
                                      ),
                                      fit: BoxFit.contain,
                                      height: controller.imgheight.value,
                                      width: controller.imgwidgth.value,
                                    )
                                  : Video(
                                      height: controller.imgheight.value,
                                      width: controller.imgwidgth.value,
                                      controls: (state) {
                                        //Controlleri sildim

                                        return SizedBox.shrink();
                                      },
                                      fit: BoxFit.cover,
                                      controller: controller
                                          .mediaList[index].videoController!,
                                    )
                              : Image.file(
                                  File(controller.mediaList[index].media
                                      .mediaURL.bigURL.value),
                                  fit: BoxFit.contain,
                                  height: controller.imgheight.value,
                                  width: controller.imgwidgth.value,
                                ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: InkWell(
                              onTap: () => controller.removelist(index),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(5)),
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: controller.closeSize.value,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    },
  );
}
