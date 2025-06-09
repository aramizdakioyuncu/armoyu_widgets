import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/translations/app_translation.dart';
import 'package:armoyu_widgets/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget widgetNotificationDetail({
  Function(String category)? onTap,
}) {
  final findCurrentAccountController = Get.find<AccountUserController>();

  return Column(
    children: [
      ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        leading: const Icon(
          Icons.person_add_rounded,
        ),
        title: CustomText.costum1(NotificationKeys.friendRequests.tr),
        subtitle: CustomText.costum1(NotificationKeys.reviewFriendRequests.tr),
        trailing: Badge(
          isLabelVisible: findCurrentAccountController
                      .currentUserAccounts.value.friendRequestCount.value ==
                  0
              ? false
              : true,
          label: Text(findCurrentAccountController
              .currentUserAccounts.value.friendRequestCount
              .toString()),
          backgroundColor: Colors.red,
          textColor: Colors.white,
          child: Icon(
            findCurrentAccountController
                        .currentUserAccounts.value.friendRequestCount.value ==
                    0
                ? Icons.notifications
                : Icons.notifications_active,
            color: Colors.white,
          ),
        ),
        onTap: () {
          if (onTap != null) {
            onTap("friend-request");
          }
        },
      ),
      ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        leading: const Icon(
          Icons.groups_2,
        ),
        title: CustomText.costum1(NotificationKeys.groupRequests.tr),
        subtitle: CustomText.costum1(
          NotificationKeys.reviewGroupRequests.tr,
        ),
        trailing: Badge(
          isLabelVisible: findCurrentAccountController
                      .currentUserAccounts.value.groupInviteCount.value ==
                  0
              ? false
              : true,
          label: Text(
            findCurrentAccountController
                .currentUserAccounts.value.groupInviteCount
                .toString(),
          ),
          backgroundColor: Colors.red,
          textColor: Colors.white,
          child: Icon(
            findCurrentAccountController
                        .currentUserAccounts.value.groupInviteCount.value ==
                    0
                ? Icons.notifications
                : Icons.notifications_active,
            color: Colors.white,
          ),
        ),
        onTap: () {
          if (onTap != null) {
            onTap("group-request");
          }
        },
      ),
    ],
  );
}
