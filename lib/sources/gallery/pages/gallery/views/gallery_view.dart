import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/sources/gallery/pages/gallery/controllers/gallery_controller.dart';
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
                  // GridView.builder(
                  //   gridDelegate:
                  //       const SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: 3, // Her satırda 3 görsel
                  //     crossAxisSpacing: 5.0, // Yatayda boşluk
                  //     mainAxisSpacing: 5.0, // Dikeyde boşluk
                  //   ),
                  //   itemCount: controller.thumbnailmemorymedia.length,
                  //   itemBuilder: (context, index) {
                  //     return GestureDetector(
                  //       onTap: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => PhotoviewerView(
                  //               service: service,
                  //               currentUserID: currentUser.userID!,
                  //               isMemory: true,
                  //               media: controller.memorymedia,
                  //               initialIndex: index,
                  //             ),
                  //           ),
                  //         );
                  //       },
                  //       child: Image.memory(
                  //         controller.thumbnailmemorymedia[index].mediaBytes!,
                  //         fit: BoxFit.cover,
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
