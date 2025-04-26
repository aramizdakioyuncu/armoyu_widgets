import 'dart:io';

import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/sources/gallery/bundle/gallery_bundle.dart';
import 'package:armoyu_widgets/sources/gallery/widgets/gallery_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final ARMOYUServices service;
  GalleryController({required this.service});
  var mediaUploadProcess = false.obs;

  var pageisactive = false.obs;
  late var tabController = Rx<TabController?>(null);
  var mediaList = <Media>[].obs;
  var galleryscrollcontroller = ScrollController().obs;

  late GalleryWidgetBundle galleryWidget;

  var fetchFirstDeviceGalleryStatus = false.obs;
  var assets = <AssetEntity>[].obs;
  var memorymedia = <Media>[].obs;
  var thumbnailmemorymedia = <Media>[].obs;
  var currentUserAccounts = Rx<UserAccounts>(
    UserAccounts(
      user: User().obs,
      sessionTOKEN: Rx(""),
      language: Rxn(),
    ),
  );

  @override
  void onInit() {
    super.onInit();

    final findCurrentAccountController = Get.find<AccountUserController>();
    currentUserAccounts.value =
        findCurrentAccountController.currentUserAccounts.value;

    galleryWidget = GalleryWidget(service).mediaGallery(
      context: Get.context!,
      storyShare: true,
      userID: currentUserAccounts.value.user.value.userID!,
      cachedmediaList: currentUserAccounts.value.gallery,
      onmediaUpdated: (updatedMedia) {
        currentUserAccounts.value.gallery = updatedMedia;
        log(
          "Gallery Media Count : ${currentUserAccounts.value.gallery!.length}  --> updatedMedia : ${updatedMedia.length}",
        );
      },
    );

    //Cihaz Galerisini çek
    if (!fetchFirstDeviceGalleryStatus.value) {
      _fetchAssets();
    }

    if (!pageisactive.value) {
      pageisactive.value = true;
    }

    galleryscrollcontroller.value.addListener(() {
      if (galleryscrollcontroller.value.position.pixels ==
          galleryscrollcontroller.value.position.maxScrollExtent) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        galleryWidget.loadMore();
      }
    });

    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    ).obs;
    tabController.value!.addListener(() {
      if (tabController.value!.indexIsChanging ||
          tabController.value!.index != tabController.value!.previousIndex) {
        if (tabController.value!.index == 0) {}
        if (tabController.value!.index == 1) {}
      }
    });
  }

  Future<void> uploadmediafunction() async {
    if (mediaUploadProcess.value) {
      return;
    }

    mediaUploadProcess.value = true;

    MediaUploadResponse response = await service.mediaServices.upload(
      files: mediaList.map((media) => media.mediaXFile!).toList(),
      category: "-1",
    );

    if (!response.result.status) {
      log(response.result.description.toString());
      mediaUploadProcess.value = false;
      return;
    }

    mediaUploadProcess.value = false;

    mediaList.clear();

    galleryWidget.refresh();
  }

  void _fetchAssets() async {
    if ((Platform.isAndroid || Platform.isIOS) == false) {
      return;
    }
    if (fetchFirstDeviceGalleryStatus.value) {
      return;
    }
    fetchFirstDeviceGalleryStatus.value = true;
    assets.value = await PhotoManager.getAssetListRange(
      start: 0,
      end: 300,
    );

    for (AssetEntity element in assets) {
      // Original
      final bytes = await element.thumbnailDataWithOption(
        const ThumbnailOption(
          size: ThumbnailSize(600, 600),
          quality: 95,
        ),
      );

      //Thumbnail
      final thumbnailbytes = await element.thumbnailDataWithOption(
        const ThumbnailOption(
          size: ThumbnailSize(150, 150),
          quality: 80,
        ),
      );
      memorymedia.add(
        Media(
          mediaID: element.typeInt,
          mediaType: MediaType.image,
          mediaBytes: bytes,
          mediaURL: MediaURL(
            bigURL: Rx<String>("bigURL"),
            normalURL: Rx<String>("normalURL"),
            minURL: Rx<String>("minURL"),
          ),
        ),
      );

      thumbnailmemorymedia.add(
        Media(
          mediaID: element.typeInt,
          mediaType: MediaType.image,
          mediaBytes: thumbnailbytes,
          mediaURL: MediaURL(
            bigURL: Rx<String>("bigURL"),
            normalURL: Rx<String>("normalURL"),
            minURL: Rx<String>("minURL"),
          ),
        ),
      );
    }
  }
}
