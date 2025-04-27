import 'dart:developer';

import 'package:armoyu_widgets/sources/notifications/bundle/notifications_bundle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/services/app_service.dart';

class NotificationsController extends GetxController {
  late NotificationsBundle notifications;
  late Widget notificationsdetail;
  var scrollController = ScrollController().obs;
  @override
  void onInit() {
    super.onInit();

    scrollController.value.addListener(() {
      if (scrollController.value.position.pixels ==
          scrollController.value.position.maxScrollExtent) {
        notifications.loadMore();
      }
    });
    notificationsdetail = AppService.widgets.notifications.notificationdetail(
      onTap: (category) {
        log("category: $category");
      },
    );

    notifications = AppService.widgets.notifications.notifications(
      cachedNotificationList: AppService
          .widgets.accountController.currentUserAccounts.value.notificationList,
      onNotificationUpdated: (updatedNotifications) {
        AppService.widgets.accountController.currentUserAccounts.value
            .notificationList = updatedNotifications;
        log("onNotificationsUpdated: ${updatedNotifications.length}   AccountItems: ${AppService.widgets.accountController.currentUserAccounts.value.notificationList!.length}");
      },
      profileFunction: (userID, username) {
        log("profileFunction userID: $userID, username: $username");
      },
    );
  }
}
