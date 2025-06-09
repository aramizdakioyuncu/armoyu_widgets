import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/sources/chat/controllers/chatfriendnote_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget widgetChatNotes(BuildContext context, service) {
  final controller = Get.put(SourceChatfriendnoteController(service));
  return Obx(
    () => Scrollbar(
      controller: controller.scrollController.value,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: controller.scrollController.value,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            controller.chatmyfriendsNotes(
              controller.currentUserAccounts.value.user.value,
            ),
            ...List.generate(
              controller.friendlist.value == null
                  ? 0
                  : controller.friendlist.value!.length,
              (index) {
                return controller.chatmyfriendsNotes(
                  User(
                    userID: controller.friendlist.value![index].playerID,
                    userName: Rx(controller.friendlist.value![index].username),
                    displayName:
                        Rx(controller.friendlist.value![index].displayName),
                    avatar: Media(
                      mediaID: 0,
                      mediaType: MediaType.image,
                      mediaURL: MediaURL(
                        bigURL: Rx(
                          controller.friendlist.value![index].avatar.bigURL,
                        ),
                        normalURL: Rx(
                          controller.friendlist.value![index].avatar.normalURL,
                        ),
                        minURL: Rx(
                          controller.friendlist.value![index].avatar.minURL,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}
