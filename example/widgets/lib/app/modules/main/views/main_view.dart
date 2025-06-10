import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/armoyuwidgets.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu_widgets/sources/gallery/bundle/gallery_bundle.dart';
import 'package:armoyu_widgets/sources/players/bundle/musicplayer_bundle.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/constants/constants.dart';
import 'package:widgets/app/modules/main/controllers/main_controller.dart';
import 'package:widgets/app/routes/app_route.dart';
import 'package:widgets/app/services/app_service.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainController(), permanent: true);

    return Scaffold(
      appBar: AppBar(title: const Text("ARMOYU Widgets")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Obx(
                  () =>
                      !controller.firstfetch.value || controller.savestaus.value
                          ? Container()
                          : controller.statusController.value
                              ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  ),
                                )
                              : const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                ),
                ),
                Expanded(
                  child: Obx(
                    () => AppService.widgets.textField.costum3(
                      controller: controller.apikeyController.value,
                      minLength: 25,
                      maxLength: 35,
                      title: "API KEY ",
                      placeholder: AppService.service.apiKey,
                      onChanged: (val) {
                        //Important for state
                        controller.apikeyController.refresh();
                        controller.statusController.value = false;
                      },
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppService.widgets.elevatedButton.costum1(
                        text: "KAYDET",
                        onPressed: () async {
                          controller.savestaus.value = true;
                          controller.firstfetch.value = true;
                          AppService.service = ARMOYUServices(
                            apiKey: controller.apikeyController.value.text,
                          );

                          AppService.widgets =
                              ARMOYUWidgets(service: AppService.service);

                          LoginResponse response =
                              await AppService.service.authServices.login(
                            username: Constants.username,
                            password: Constants.password,
                          );

                          if (!response.result.status) {
                            controller.savestaus.value = false;
                            controller.statusController.value = false;

                            return;
                          }
                          if (response.result.description ==
                              "Oyuncu bilgileri yanlış!") {
                            controller.savestaus.value = false;
                            controller.statusController.value = false;
                            return;
                          }
                          AppService.widgets.accountController.changeUser(
                            UserAccounts(
                              user: User.apilogintoUser(response.response!).obs,
                              sessionTOKEN: Rx(response.result.description),
                              language: Rxn(),
                            ),
                          );
                          bool status = await AppService.service.setup();
                          controller.statusController.value = status;
                          controller.savestaus.value = false;
                        },
                        loadingStatus: controller.savestaus.value,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Wrap(
              children: [
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppService.widgets.elevatedButton.costum1(
                      enabled: controller.statusController.value,
                      text: "Posts (Profile Tagged)",
                      onPressed: () {
                        Get.toNamed("/posts/detail");
                      },
                      loadingStatus: false,
                    ),
                  ),
                ),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppService.widgets.elevatedButton.costum1(
                      enabled: controller.statusController.value,
                      text: "Gallery(Pop Up)",
                      onPressed: () {
                        GalleryWidgetBundle aa =
                            AppService.widgets.gallery.mediaGallery(
                          context: context,
                          // userID: 1,
                        );

                        aa.popupGallery();
                      },
                      loadingStatus: false,
                    ),
                  ),
                ),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppService.widgets.elevatedButton.costum1(
                      enabled: controller.statusController.value,
                      text: "Posts",
                      onPressed: () {
                        Get.toNamed("/posts");
                      },
                      loadingStatus: false,
                    ),
                  ),
                ),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppService.widgets.elevatedButton.costum1(
                      enabled: controller.statusController.value,
                      text: "Post Create",
                      onPressed: () {
                        Get.toNamed("/posts/create");
                      },
                      loadingStatus: false,
                    ),
                  ),
                ),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppService.widgets.elevatedButton.costum1(
                      enabled: controller.statusController.value,
                      text: "Story",
                      onPressed: () {
                        Get.toNamed("/story");
                      },
                      loadingStatus: false,
                    ),
                  ),
                ),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppService.widgets.elevatedButton.costum1(
                      enabled: controller.statusController.value,
                      text: "Social",
                      onPressed: () {
                        Get.toNamed("/social");
                      },
                      loadingStatus: false,
                    ),
                  ),
                ),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppService.widgets.elevatedButton.costum1(
                      enabled: controller.statusController.value,
                      text: "Chat",
                      onPressed: () {
                        Get.toNamed(Routes.CHAT);
                      },
                      loadingStatus: false,
                    ),
                  ),
                ),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppService.widgets.elevatedButton.costum1(
                      enabled: controller.statusController.value,
                      text: "Notifications",
                      onPressed: () {
                        Get.toNamed(Routes.NOTIFICATIONS);
                      },
                      loadingStatus: false,
                    ),
                  ),
                ),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppService.widgets.elevatedButton.costum1(
                      enabled: controller.statusController.value,
                      text: "Profile",
                      onPressed: () {
                        Get.toNamed(Routes.PROFILE);
                      },
                      loadingStatus: false,
                    ),
                  ),
                ),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppService.widgets.elevatedButton.costum1(
                      enabled: controller.statusController.value,
                      text: "Search",
                      onPressed: () {
                        Get.toNamed(Routes.SEARCH);
                      },
                      loadingStatus: false,
                    ),
                  ),
                ),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppService.widgets.elevatedButton.costum1(
                      enabled: controller.statusController.value,
                      text: "Reels",
                      onPressed: () {
                        Get.toNamed(Routes.REELS);
                      },
                      loadingStatus: false,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppService.widgets.elevatedButton.costum1(
                      enabled: controller.statusController.value,
                      text: "Fill Cache",
                      onPressed: () {
                        Get.toNamed(Routes.CACHE);
                      },
                      loadingStatus: false,
                    ),
                  ),
                ),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppService.widgets.elevatedButton.costum1(
                      enabled: controller.statusController.value,
                      text: "Music Player",
                      onPressed: () async {
                        PlayerWidgetBundle player =
                            AppService.widgets.players.musicplayer();

                        PlayerWidgetBundle player2 =
                            AppService.widgets.players.advencedPlayer(
                          context,
                        );

                        showDialog(
                          context: Get.context!,
                          builder: (_) => AlertDialog(
                            title: Text("Music Player"),
                            content: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: player.widget.value!,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: player2.widget.value!,
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: Text("Kapat"),
                              )
                            ],
                          ),
                        );
                      },
                      loadingStatus: false,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
