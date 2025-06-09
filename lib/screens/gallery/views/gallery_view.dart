import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/screens/gallery/controllers/gallery_controller.dart';
import 'package:armoyu_widgets/sources/gallery/widgets/gallery_widget.dart';
import 'package:armoyu_widgets/widgets/buttons.dart';
import 'package:armoyu_widgets/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GalleryView extends StatelessWidget {
  final ARMOYUServices service;
  const GalleryView({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//

    findCurrentAccountController.currentUserAccounts.value.user.value;

    final controller = Get.put(GalleryController(service: service));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hikaye Gönder'),
        actions: [
          IconButton(
            onPressed: () async => await controller.galleryWidget.refresh(),
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(
        () => Column(
          children: [
            TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.white,
              controller: controller.tabController.value,
              isScrollable: false,
              indicatorColor: Colors.blue,
              tabs: [
                Padding(
                  padding: const EdgeInsets.all(17.0),
                  child: CustomText.costum1('ARMOYU Cloud', size: 15.0),
                ),
                Padding(
                  padding: const EdgeInsets.all(17.0),
                  child: CustomText.costum1('Telefon', size: 15.0),
                )
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: controller.tabController.value,
                children: [
                  RefreshIndicator(
                    onRefresh: () async => controller.galleryWidget.refresh(),
                    child: SingleChildScrollView(
                      controller: controller.galleryscrollcontroller.value,
                      child: Column(
                        children: [
                          GalleryWidget(service).mediaList(
                            context,
                            onMediaUpdated: (onMediaUpdated) {
                              controller.mediaList.value = onMediaUpdated;
                              controller.mediaList.refresh();
                            },
                            big: false,
                          ),
                          SizedBox(
                            height: 150,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                  child: CustomButtons.costum1(
                                    text: "Yükle",
                                    enabled: controller.mediaList.isNotEmpty,
                                    onPressed: () async =>
                                        await controller.uploadmediafunction(),
                                    loadingStatus:
                                        controller.mediaUploadProcess,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          controller.galleryWidget.widget.value ??
                              const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Bu Sayfa Henüz Geliştirilmedi",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
