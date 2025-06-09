import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/sources/notifications/bundle/notifications_bundle.dart';
import 'package:armoyu_widgets/sources/notifications/widgets/notifications_all.dart';
import 'package:armoyu_widgets/sources/notifications/widgets/notifications_detail.dart';
import 'package:armoyu_widgets/widgets/notification_bars/notification_bars_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationsWidget {
  final ARMOYUServices service;

  const NotificationsWidget(this.service);

  Widget notificationdetail({
    Function(String category)? onTap,
  }) {
    return widgetNotificationDetail(onTap: onTap);
  }

  NotificationsBundle notifications({
    String category = "",
    String categorydetail = "",
    List<Notifications>? cachedNotificationList,
    Function(List<Notifications> updatedNotifications)? onNotificationUpdated,
    Function(String category, String categorydetail, int categorydetailID)?
        onTap,
    required Function(int userID, String username) profileFunction,
  }) {
    return widgetNotificationsAll(
      service,
      profileFunction: profileFunction,
      cachedNotificationList: cachedNotificationList,
      category: category,
      categorydetail: categorydetail,
      onNotificationUpdated: onNotificationUpdated,
      onTap: onTap,
    );
  }
}
