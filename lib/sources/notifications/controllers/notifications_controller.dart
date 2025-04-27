import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/notifications/notification_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/widgets/notification_bars/notification_bars_view.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  final ARMOYUServices service;
  List<Notifications>? cachedNotificationsList;
  Function(List<Notifications> updatedNotifications)? onNotificationsUpdated;

  NotificationsController({
    required this.service,
    this.cachedNotificationsList,
    this.onNotificationsUpdated,
  });

  Rxn<List<Notifications>> notificationsList = Rxn();
  Rxn<List<Notifications>> filteredNotificationsList = Rxn();

  var notificationProccess = false.obs;
  var notificationEndProccess = false.obs;
  var page = 1.obs;

  Future<void> refreshAllNotifications() async {
    log("Refresh All Notifications");
    await loadnoifications(refresh: true);
  }

  Future<void> loadMoreNotifications() async {
    log("load More Notifications");
    return await loadnoifications();
  }

  void updateNotificationList() {
    filteredNotificationsList.value = notificationsList.value;
    notificationsList.refresh();
    filteredNotificationsList.refresh();
    onNotificationsUpdated?.call(notificationsList.value!);
  }

  UserAccounts? currentUserAccounts;

  @override
  void onInit() {
    super.onInit();

    final findCurrentAccountController = Get.find<AccountUserController>();
    currentUserAccounts =
        findCurrentAccountController.currentUserAccounts.value;

    //Bellekteki paylaşımları yükle
    if (cachedNotificationsList != null) {
      notificationsList.value ??= [];
      notificationsList.value = cachedNotificationsList;
      filteredNotificationsList.value = cachedNotificationsList;
    }

    loadnoifications();
  }

  Future<void> loadnoifications({bool refresh = false}) async {
    if (notificationProccess.value || notificationEndProccess.value) {
      return;
    }
    notificationProccess.value = true;

    NotificationListResponse response =
        await service.notificationServices.getnotifications(
      kategori: "",
      kategoridetay: "",
      page: page.value,
    );

    if (!response.result.status) {
      log(response.result.description);
      notificationProccess.value = false;

      return;
    }

    if (response.response!.isEmpty) {
      notificationProccess.value = false;

      return;
    }

    if (page.value == 1) {
      notificationsList.value = [];
    }

    notificationsList.value ??= [];

    for (APINotificationList element in response.response!) {
      bool notificationButtons = false;

      if (element.bildirimAmac.toString() == "arkadaslik") {
        if (element.bildirimKategori.toString() == "istek") {
          notificationButtons = true;
        }
      } else if (element.bildirimAmac.toString() == "gruplar") {
        if (element.bildirimKategori.toString() == "davet") {
          notificationButtons = true;
        }
      }

      notificationsList.value!.add(
        Notifications(
          user: User(
            userID: element.bildirimGonderenID,
            displayName: Rx<String>(element.bildirimGonderenAdSoyad),
            userName: Rx<String>(element.bildirimGonderenLink.split("/").last),
            avatar: Media(
              mediaID: element.bildirimGonderenID,
              mediaType: MediaType.image,
              mediaURL: MediaURL(
                bigURL: Rx<String>(element.bildirimGonderenAvatar),
                normalURL: Rx<String>(element.bildirimGonderenAvatar),
                minURL: Rx<String>(element.bildirimGonderenAvatar),
              ),
            ),
          ),
          category: element.bildirimAmac,
          categorydetail: element.bildirimKategori,
          categorydetailID: element.bildirimKategoriDetay,
          date: element.bildirimZaman,
          enableButtons: notificationButtons,
          text: element.bildirimIcerik,
        ),
      );
    }
    updateNotificationList();

    if (response.response!.length < 20) {
      notificationEndProccess.value = true;
    }
    notificationProccess.value = false;
    page.value++;
  }
}
