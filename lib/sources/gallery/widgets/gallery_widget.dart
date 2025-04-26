import 'dart:io';

import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/core/appcore.dart';
import 'package:armoyu_widgets/core/armoyu.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/sources/Story/publish_story_page/views/storypublish_view.dart';
import 'package:armoyu_widgets/sources/gallery/bundle/gallery_bundle.dart';
import 'package:armoyu_widgets/sources/gallery/widgets/mediagallery_controller.dart';
import 'package:armoyu_widgets/sources/photoviewer/views/photoviewer_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class GalleryWidget {
  final ARMOYUServices service;

  const GalleryWidget(this.service);

  GalleryWidgetBundle mediaGallery({
    required context,
    int? userID,
    String? username,
    List<Media>? cachedmediaList,
    Function(List<Media> updatedMedia)? onmediaUpdated,
    bool storyShare = false,
  }) {
    final controller = Get.put(
        MediagalleryController(
          service: service,
          userID: userID,
          username: username,
          cachedmediaList: cachedmediaList,
          onMediaUpdated: onmediaUpdated,
        ),
        tag: "mediagallery-$userID");
    Widget widget = Obx(
      () => controller.filteredMediaList.value == null
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : GridView(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              padding: EdgeInsets.zero,
              physics: const ClampingScrollPhysics(),
              children: List.generate(
                controller.filteredMediaList.value!.length,
                (index) {
                  return GestureDetector(
                    onTap: () {
                      if (storyShare) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StorypublishView(
                              service: service,
                              imageID: 1,
                              imageURL: controller.filteredMediaList
                                  .value![index].mediaURL.bigURL.value,
                            ),
                          ),
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhotoviewerView(
                            service: service,
                            currentUserID: controller
                                .filteredMediaList.value![index].ownerID!,
                            media: controller.filteredMediaList.value!,
                            initialIndex: index,
                          ),
                        ),
                      );
                    },
                    onLongPress: () {
                      if (controller
                              .currentUserAccounts.value.user.value.userID !=
                          controller.filteredMediaList.value![index].ownerID!) {
                        return;
                      }
                      controller.onlongPress(
                          context, controller.filteredMediaList.value!, index);
                    },
                    child: CachedNetworkImage(
                      imageUrl: controller.filteredMediaList.value![index]
                          .mediaURL.minURL.value,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CupertinoActivityIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  );
                },
              ),
            ),
    );

    return GalleryWidgetBundle(
      widget: Rxn(widget),
      refresh: () async => await controller.refreshAllMedia(),
      loadMore: () async => await controller.loadMoreMedia(),
    );
  }

  Widget mediaList(
    RxList<Media> list, {
    bool big = false,
    bool editable = false,
  }) {
    double imgheight = 100;
    double imgwidgth = 100;
    double closeSize = 16;

    if (big) {
      imgheight = ARMOYU.screenHeight * 0.6;
      imgwidgth = ARMOYU.screenWidth - 25;
      closeSize = 30;
    }
    return SizedBox(
      height: imgheight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length + 1,
        itemBuilder: (context, index) {
          if (index + 1 == list.length + 1) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: imgwidgth,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.black,
                  ),
                ),
                child: InkWell(
                  onTap: () async {
                    List<XFile> selectedImages = await AppCore.pickImages();
                    if (selectedImages.isNotEmpty) {
                      for (XFile element in selectedImages) {
                        list.add(
                          Media(
                            mediaID: element.hashCode,
                            mediaType: MediaType.image,
                            mediaXFile: element,
                            mediaURL: MediaURL(
                              bigURL: Rx<String>(element.path),
                              normalURL: Rx<String>(element.path),
                              minURL: Rx<String>(element.path),
                            ),
                          ),
                        );
                        list.refresh();
                      }
                    }
                  },
                  child: const Icon(Icons.add_a_photo_rounded),
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () async {
                if (editable) {
                  //Kırpma İşlemi
                  XFile? selectedCroppedImage = await AppCore.cropperImage(
                    XFile(list[index].mediaURL.bigURL.value),
                  );
                  if (selectedCroppedImage == null) {
                    return;
                  }
                  // image = selectedCroppedImage;
                  list[index].mediaXFile = selectedCroppedImage;
                  //Kırpma İşlemi
                  list.refresh();
                  return;
                }
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => MediaViewer(
                //       currentUserID: currentUser.userID!,
                //       media: list,
                //       initialIndex: index,
                //       isFile: true,
                //     ),
                //   ),
                // );
              },
              child: Container(
                width: imgwidgth,
                height: imgheight,
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: Stack(
                  children: [
                    list[index].mediaXFile != null
                        ? Image.file(
                            File(
                              list[index].mediaXFile!.path,
                            ),
                            fit: BoxFit.contain,
                            height: imgheight,
                            width: imgwidgth,
                          )
                        : Image.file(
                            File(list[index].mediaURL.bigURL.value),
                            fit: BoxFit.contain,
                            height: imgheight,
                            width: imgwidgth,
                          ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: InkWell(
                        onTap: () {
                          log("media listeden silindi");
                          try {
                            list.removeAt(index);
                          } catch (e) {
                            log(e.toString());
                          }

                          list.refresh();
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5)),
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                            size: closeSize,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
