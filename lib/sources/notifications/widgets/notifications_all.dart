import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/service_result.dart';
import 'package:armoyu_widgets/core/widgets.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/sources/notifications/bundle/notifications_bundle.dart';
import 'package:armoyu_widgets/sources/notifications/controllers/notifications_controller.dart';
import 'package:armoyu_widgets/translations/app_translation.dart';
import 'package:armoyu_widgets/widgets/buttons.dart';
import 'package:armoyu_widgets/widgets/detectabletext.dart';
import 'package:armoyu_widgets/widgets/notification_bars/notification_bars_view.dart';
import 'package:armoyu_widgets/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

NotificationsBundle widgetNotificationsAll(
  service, {
  String category = "",
  String categorydetail = "",
  List<Notifications>? cachedNotificationList,
  Function(List<Notifications> updatedNotifications)? onNotificationUpdated,
  Function(String category, String categorydetail, int categorydetailID)? onTap,
  required Function(int userID, String username) profileFunction,
}) {
  final findCurrentAccountController = Get.find<AccountUserController>();
  String uniqueTag = DateTime.now().millisecondsSinceEpoch.toString();

  final controller = Get.put(
      NotificationsController(
        service: service,
        category: category,
        categorydetail: categorydetail,
        cachedNotificationsList: cachedNotificationList,
        onNotificationsUpdated: onNotificationUpdated,
      ),
      tag:
          "${findCurrentAccountController.currentUserAccounts.value.user.value.userID}storyWidgetUniq-$uniqueTag");

  Widget widget = Column(
    children: [
      Obx(
        () => controller.filteredNotificationsList.value == null
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              )
            : Column(
                children: List.generate(
                  controller.filteredNotificationsList.value!.length,
                  (index) {
                    Notifications notificationsINFO =
                        controller.filteredNotificationsList.value![index];

                    deleteFunction() {
                      controller.notificationsList.value!.removeWhere(
                        (element) =>
                            element ==
                            controller.filteredNotificationsList.value![index],
                      );

                      controller.filteredNotificationsList.value!
                          .removeAt(index);
                    }

                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (onTap != null) {
                                    onTap(
                                      notificationsINFO.category,
                                      notificationsINFO.categorydetail,
                                      notificationsINFO.categorydetailID,
                                    );
                                  }
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        profileFunction(
                                          notificationsINFO.user.userID!,
                                          notificationsINFO
                                              .user.userName!.value,
                                        );
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        foregroundImage:
                                            CachedNetworkImageProvider(
                                          notificationsINFO.user.avatar!
                                              .mediaURL.minURL.value,
                                        ),
                                        radius: 25,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CustomText.costum1(
                                                notificationsINFO
                                                    .user.displayName!.value,
                                                weight: FontWeight.bold,
                                              ),
                                              const Spacer(),
                                              CustomText.costum1(
                                                  notificationsINFO.date
                                                      .replaceAll('Saniye',
                                                          CommonKeys.second.tr)
                                                      .replaceAll('Dakika',
                                                          CommonKeys.minute.tr)
                                                      .replaceAll('Saat',
                                                          CommonKeys.hour.tr)
                                                      .replaceAll('Gün',
                                                          CommonKeys.day.tr)
                                                      .replaceAll('Ay',
                                                          CommonKeys.month.tr)
                                                      .replaceAll('Yıl',
                                                          CommonKeys.year.tr)),
                                            ],
                                          ),
                                          CustomDedectabletext.costum1(
                                              notificationsINFO.text, 2, 15),
                                          const SizedBox(height: 10),
                                          Visibility(
                                            visible:
                                                notificationsINFO.enableButtons,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                CustomButtons.costum1(
                                                  text: CommonKeys.accept.tr,
                                                  onPressed: () async {
                                                    if (notificationsINFO
                                                            .category ==
                                                        "arkadaslik") {
                                                      // natificationisVisible = false;
                                                      deleteFunction();
                                                      findCurrentAccountController
                                                              .currentUserAccounts
                                                              .value
                                                              .friendRequestCount
                                                              .value ==
                                                          findCurrentAccountController
                                                                  .currentUserAccounts
                                                                  .value
                                                                  .friendRequestCount
                                                                  .value -
                                                              1;

                                                      if (notificationsINFO
                                                              .categorydetail ==
                                                          "istek") {
                                                        ServiceResult response =
                                                            await service
                                                                .profileServices
                                                                .friendrequestanswer(
                                                          userID:
                                                              notificationsINFO
                                                                  .user.userID!,
                                                          answer: 1,
                                                        );
                                                        if (!response.status) {
                                                          ARMOYUWidget
                                                              .toastNotification(
                                                                  response
                                                                      .description
                                                                      .toString());
                                                          // natificationisVisible = true;
                                                          deleteFunction();
                                                          // currentUserAccounts
                                                          //     .friendRequestCount++;
                                                          findCurrentAccountController
                                                              .currentUserAccounts
                                                              .value
                                                              .friendRequestCount
                                                              .value = findCurrentAccountController
                                                                  .currentUserAccounts
                                                                  .value
                                                                  .friendRequestCount
                                                                  .value +
                                                              1;
                                                          1;

                                                          return;
                                                        }
                                                      }
                                                    } else if (notificationsINFO
                                                            .category ==
                                                        "gruplar") {
                                                      if (notificationsINFO
                                                              .categorydetail ==
                                                          "davet") {
                                                        // currentUserAccounts
                                                        //     .groupInviteCount--;

                                                        findCurrentAccountController
                                                            .currentUserAccounts
                                                            .value
                                                            .groupInviteCount
                                                            .value = findCurrentAccountController
                                                                .currentUserAccounts
                                                                .value
                                                                .groupInviteCount
                                                                .value -
                                                            1;

                                                        // natificationisVisible = false;
                                                        deleteFunction();

                                                        GroupRequestAnswerResponse
                                                            response =
                                                            await service
                                                                .groupServices
                                                                .grouprequestanswer(
                                                          groupID: notificationsINFO
                                                              .categorydetailID,
                                                          answer: "1",
                                                        );
                                                        if (!response
                                                            .result.status) {
                                                          ARMOYUWidget
                                                              .toastNotification(
                                                                  response
                                                                      .result
                                                                      .description
                                                                      .toString());

                                                          findCurrentAccountController
                                                              .currentUserAccounts
                                                              .value
                                                              .groupInviteCount
                                                              .value = findCurrentAccountController
                                                                  .currentUserAccounts
                                                                  .value
                                                                  .groupInviteCount
                                                                  .value +
                                                              1;

                                                          // natificationisVisible = true;
                                                          deleteFunction();

                                                          return;
                                                        }
                                                      }
                                                    }
                                                  },
                                                  loadingStatus: false.obs,
                                                ),
                                                const SizedBox(width: 16),
                                                CustomButtons.costum1(
                                                  text: CommonKeys.decline.tr,
                                                  onPressed: () async {
                                                    if (notificationsINFO
                                                            .category ==
                                                        "arkadaslik") {
                                                      if (notificationsINFO
                                                              .categorydetail ==
                                                          "istek") {
                                                        // currentUserAccounts
                                                        //     .friendRequestCount--;
                                                        findCurrentAccountController
                                                            .currentUserAccounts
                                                            .value
                                                            .friendRequestCount
                                                            .value = findCurrentAccountController
                                                                .currentUserAccounts
                                                                .value
                                                                .friendRequestCount
                                                                .value -
                                                            1;
                                                        // natificationisVisible = false;
                                                        deleteFunction();

                                                        ServiceResult response =
                                                            await service
                                                                .profileServices
                                                                .friendrequestanswer(
                                                          userID:
                                                              notificationsINFO
                                                                  .user.userID!,
                                                          answer: 0,
                                                        );
                                                        if (!response.status) {
                                                          ARMOYUWidget
                                                              .toastNotification(
                                                                  response
                                                                      .description
                                                                      .toString());
                                                          // currentUserAccounts
                                                          //     .friendRequestCount++;

                                                          findCurrentAccountController
                                                              .currentUserAccounts
                                                              .value
                                                              .friendRequestCount
                                                              .value = findCurrentAccountController
                                                                  .currentUserAccounts
                                                                  .value
                                                                  .friendRequestCount
                                                                  .value +
                                                              1;

                                                          // natificationisVisible = true;
                                                          deleteFunction();

                                                          return;
                                                        }
                                                      }
                                                    } else if (notificationsINFO
                                                            .category ==
                                                        "gruplar") {
                                                      if (notificationsINFO
                                                              .categorydetail ==
                                                          "davet") {
                                                        // currentUserAccounts
                                                        //     .groupInviteCount--;

                                                        findCurrentAccountController
                                                            .currentUserAccounts
                                                            .value
                                                            .groupInviteCount
                                                            .value = findCurrentAccountController
                                                                .currentUserAccounts
                                                                .value
                                                                .groupInviteCount
                                                                .value -
                                                            1;
                                                        // natificationisVisible = false;
                                                        deleteFunction();

                                                        GroupRequestAnswerResponse
                                                            response =
                                                            await service
                                                                .groupServices
                                                                .grouprequestanswer(
                                                          groupID: notificationsINFO
                                                              .categorydetailID,
                                                          answer: "0",
                                                        );
                                                        if (!response
                                                            .result.status) {
                                                          ARMOYUWidget
                                                              .toastNotification(
                                                                  response
                                                                      .result
                                                                      .description
                                                                      .toString());
                                                          // currentUserAccounts
                                                          //     .groupInviteCount++;

                                                          findCurrentAccountController
                                                              .currentUserAccounts
                                                              .value
                                                              .groupInviteCount
                                                              .value = findCurrentAccountController
                                                                  .currentUserAccounts
                                                                  .value
                                                                  .groupInviteCount
                                                                  .value +
                                                              1;
                                                          // natificationisVisible = true;
                                                          deleteFunction();

                                                          return;
                                                        }
                                                      }
                                                    }
                                                  },
                                                  loadingStatus: false.obs,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 1)
                      ],
                    );
                  },
                ),
              ),
      ),
    ],
  );

  return NotificationsBundle(
    widget: Rxn(widget),
    refresh: () async => await controller.refreshAllNotifications(),
    loadMore: () async => await controller.loadMoreNotifications(),
  );
}
