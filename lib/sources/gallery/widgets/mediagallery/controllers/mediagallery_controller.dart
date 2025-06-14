import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/media/media_fetch.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/core/armoyu.dart';
import 'package:armoyu_widgets/core/widgets.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/functions/utils_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MediagalleryController extends GetxController {
  final ARMOYUServices service;
  int? userID;
  String? username;

  List<Media>? cachedmediaList;
  Function(List<Media> updatedPosts)? onMediaUpdated;

  MediagalleryController({
    required this.service,
    this.userID,
    this.username,
    this.cachedmediaList,
    this.onMediaUpdated,
  });

  var mediapagecount = 1.obs;
  var mediafetchProccess = false.obs;
  var mediafetchEndProccess = false.obs;
  Rxn<List<Media>> mediaList = Rxn();
  Rxn<List<Media>> filteredMediaList = Rxn();

  var currentUserAccounts = Rx<UserAccounts>(
    UserAccounts(
      user: User().obs,
      sessionTOKEN: Rx(""),
      language: Rxn(),
    ),
  );

  Future<void> refreshAllMedia() async {
    log("Refresh All Media");
    await fetchgallery(refreshmedia: true);
  }

  Future<void> loadMoreMedia() async {
    log("load More Media");
    return await fetchgallery();
  }

  void updateMediaList() {
    filteredMediaList.value = mediaList.value;
    mediaList.refresh();
    filteredMediaList.refresh();
    onMediaUpdated?.call(mediaList.value!);
  }

  @override
  void onInit() {
    super.onInit();

    final findCurrentAccountController = Get.find<AccountUserController>();
    currentUserAccounts.value =
        findCurrentAccountController.currentUserAccounts.value;

    if (userID == null && username == null) {
      userID = currentUserAccounts.value.user.value.userID;
    }

    //Bellekteki paylaşımları yükle
    if (cachedmediaList != null) {
      mediaList.value ??= [];
      filteredMediaList.value ??= [];
      mediaList.value = cachedmediaList;
      filteredMediaList.value = cachedmediaList;
    }
    fetchgallery();
  }

  fetchgallery({bool refreshmedia = false}) async {
    if ((mediafetchProccess.value || mediafetchEndProccess.value) &&
        !refreshmedia) {
      return;
    }
    mediafetchProccess.value = true;

    //Page Hesaplama Fonksionu
    mediapagecount.value = UtilsFunction.calculatePageNumber(
      cardList: mediaList,
      itemsPerPage: 30,
    );
    //Page Hesaplama Fonksionu Bitiş

    if (refreshmedia) {
      mediapagecount.value = 1;
    }
    MediaFetchResponse response = await service.mediaServices.fetch(
      userID: userID,
      username: username,
      category: APIMediaType.all,
      page: mediapagecount.value,
    );

    if (!response.result.status) {
      log(response.result.description);
      mediafetchProccess.value = false;
      return;
    }

    mediaList.value ??= [];
    if (refreshmedia) {
      mediaList.value = [];
    }

    for (APIMediaFetch element in response.response!) {
      mediaList.value!.add(
        Media(
          mediaID: element.media.mediaID,
          ownerID: element.mediaOwner.userID,
          mediaType: (element.mediatype.contains("video") ||
                  element.media.mediaURL.normalURL.contains(".mp4"))
              ? MediaType.video
              : MediaType.image,
          mediaURL: MediaURL(
            bigURL: Rx(element.media.mediaURL.bigURL),
            normalURL: Rx(element.media.mediaURL.normalURL),
            minURL: Rx(element.media.mediaURL.minURL),
          ),
        ),
      );
    }
    if (response.response!.length < 30) {
      mediafetchEndProccess.value = true;
      log("Media Fetch End Proccess");
    }

    updateMediaList();
    mediapagecount++;
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

                        medialist.removeAt(index);
                        updateMediaList();
                        if (!response.result.status) {
                          log(response.result.description.toString());
                          ARMOYUWidget.toastNotification(
                            response.result.description.toString(),
                          );
                          return;
                        }
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
