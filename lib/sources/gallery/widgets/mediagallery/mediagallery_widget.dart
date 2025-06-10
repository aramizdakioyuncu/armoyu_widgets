import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/sources/Story/publish_story_page/views/storypublish_view.dart';
import 'package:armoyu_widgets/sources/gallery/bundle/gallery_bundle.dart';
import 'package:armoyu_widgets/sources/gallery/widgets/gallery_widget.dart';
import 'package:armoyu_widgets/sources/gallery/widgets/mediagallery/controllers/mediagallery_controller.dart';
import 'package:armoyu_widgets/screens/mediaviewer/views/mediaviewer_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

GalleryWidgetBundle widgetmediaGallery({
  required ARMOYUServices service,
  required context,
  int? userID,
  String? username,
  List<Media>? cachedmediaList,
  Function(List<Media> updatedMedia)? onmediaUpdated,
  bool storyShare = false,
  bool allowuploadmedia = false,
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
    () => Column(
      children: [
        allowuploadmedia == false
            ? SizedBox.shrink()
            : GalleryWidget(service)
                .mediaList(
                  context,
                  onMediaUpdated: (onMediaUpdated) {},
                )
                .widget
                .value!,
        controller.filteredMediaList.value == null
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

                        Get.dialog(
                          PhotoviewerView(
                            service: service,
                            media: controller.filteredMediaList.value!,
                            initialIndex: index,
                          ),
                          barrierDismissible: true,
                        ).whenComplete(() {
                          log('Photo viewer dialog closed.');
                        });
                      },
                      onLongPress: () {
                        if (controller
                                .currentUserAccounts.value.user.value.userID !=
                            controller
                                .filteredMediaList.value![index].ownerID!) {
                          return;
                        }
                        controller.onlongPress(context,
                            controller.filteredMediaList.value!, index);
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
      ],
    ),
  );

  return GalleryWidgetBundle(
    widget: Rxn(widget),
    refresh: () async => await controller.refreshAllMedia(),
    loadMore: () async => await controller.loadMoreMedia(),
    popupGallery: () async => await showModalBottomSheet(
        context: context,
        builder: (context) {
          return widget;
        }),
  );
}
