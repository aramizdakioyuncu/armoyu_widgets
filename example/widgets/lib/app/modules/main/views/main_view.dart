import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/login&register&password/login.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/armoyuwidgets.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                  () => controller.statusController.value == null
                      ? Container()
                      : controller.statusController.value!
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
                        controller.statusController.value = null;
                      },
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.statusController.value == null,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppService.widgets.elevatedButton.costum1(
                        text: "KAYDET",
                        onPressed: () async {
                          controller.savestaus.value = true;
                          AppService.service = ARMOYUServices(
                            apiKey: controller.apikeyController.value.text,
                            usePreviousAPI: true,
                          );

                          AppService.widgets =
                              ARMOYUWidgets(service: AppService.service);

                          // LoginResponse response = await AppService
                          //     .service.authServices
                          //     .loginwithbarriertoken(
                          //   barriertoken:
                          //       "5221d07eb0049191ed17b3d1ea773941aa3ab1960c9696c64de2281766d13df2",
                          // );
                          LoginResponse response = await AppService
                              .service.authServices
                              .login(username: "deneme", password: "deneme");

                          if (!response.result.status) {
                            return;
                          }
                          APILogin userinfo = response.response!;

                          AppService.widgets.accountController.changeUser(
                            UserAccounts(
                              user: User(
                                userID: userinfo.playerID,
                                displayName: Rx(userinfo.displayName!),
                                userName: Rx(userinfo.username!),
                                avatar: Media(
                                  mediaID: 0,
                                  mediaURL: MediaURL(
                                    bigURL:
                                        Rx(userinfo.avatar!.mediaURL.bigURL),
                                    normalURL:
                                        Rx(userinfo.avatar!.mediaURL.normalURL),
                                    minURL:
                                        Rx(userinfo.avatar!.mediaURL.minURL),
                                  ),
                                ),
                                banner: Media(
                                  mediaID: 0,
                                  mediaURL: MediaURL(
                                    bigURL:
                                        Rx(userinfo.banner!.mediaURL.bigURL),
                                    normalURL:
                                        Rx(userinfo.banner!.mediaURL.normalURL),
                                    minURL:
                                        Rx(userinfo.banner!.mediaURL.minURL),
                                  ),
                                ),
                              ).obs,
                              sessionTOKEN: Rx(
                                response.result.description,
                              ),
                              language: Rx("TR"),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppService.widgets.elevatedButton.costum1(
                    text: "PostDetail",
                    onPressed: () {
                      Get.toNamed("/posts/detail");
                    },
                    loadingStatus: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppService.widgets.elevatedButton.costum1(
                    text: "Posts",
                    onPressed: () {
                      Get.toNamed("/posts");
                    },
                    loadingStatus: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppService.widgets.elevatedButton.costum1(
                    text: "Story",
                    onPressed: () {
                      Get.toNamed("/story");
                    },
                    loadingStatus: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppService.widgets.elevatedButton.costum1(
                    text: "Social",
                    onPressed: () {
                      Get.toNamed("/social");
                    },
                    loadingStatus: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppService.widgets.elevatedButton.costum1(
                    text: "Chat",
                    onPressed: () {
                      Get.toNamed(Routes.CHAT);
                    },
                    loadingStatus: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppService.widgets.elevatedButton.costum1(
                    text: "Profile",
                    onPressed: () {
                      Get.toNamed(Routes.PROFILE);
                    },
                    loadingStatus: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
