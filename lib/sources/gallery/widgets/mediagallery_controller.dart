import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/media/media_fetch.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/core/armoyu.dart';
import 'package:armoyu_widgets/core/widgets.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MediagalleryController extends GetxController {
  final ARMOYUServices service;
  MediagalleryController({required this.service});

  Rxn<List<Media>> mediaList = Rxn();
  var mediafetchProccess = false.obs;
  var currentUserAccounts = Rx<UserAccounts>(
    UserAccounts(
      user: User().obs,
      sessionTOKEN: Rx(""),
      language: Rx(""),
    ),
  );

  @override
  void onInit() {
    super.onInit();

    final findCurrentAccountController = Get.find<AccountUserController>();
    currentUserAccounts.value =
        findCurrentAccountController.currentUserAccounts.value;

    fetchgallery();
  }

  fetchgallery({int? userID}) async {
    if (mediafetchProccess.value) {
      return;
    }
    mediafetchProccess.value = true;
    MediaFetchResponse response = await service.mediaServices.fetch(
      uyeID: userID ?? currentUserAccounts.value.user.value.userID!,
      category: "-1",
      page: 1,
    );

    if (!response.result.status) {
      log(response.result.description);
      mediafetchProccess.value = false;
      return;
    }

    mediaList.value ??= [];
    for (APIMediaFetch element in response.response!) {
      mediaList.value!.add(
        Media(
          mediaID: element.media.mediaID,
          ownerID: element.media.mediaID,
          mediaURL: MediaURL(
            bigURL: Rx(element.media.mediaURL.bigURL),
            normalURL: Rx(element.media.mediaURL.bigURL),
            minURL: Rx(element.media.mediaURL.bigURL),
          ),
        ),
      );
    }

    mediafetchProccess.value = false;
  }

  onlongPress(context, List<Media> medialist, index) {
    showModalBottomSheet<void>(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: const BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        width: ARMOYU.screenWidth / 4,
                        height: 5,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);

                        MediaDeleteResponse response = await service
                            .mediaServices
                            .delete(mediaID: medialist[index].mediaID);

                        if (!response.result.status) {
                          log(response.result.description.toString());
                          ARMOYUWidget.toastNotification(
                            response.result.description.toString(),
                          );
                          return;
                        }
                        medialist.removeAt(index);
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        title: Text(
                          "Medyayı Sil",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
