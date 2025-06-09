import 'package:armoyu_widgets/data/models/Chat/chat.dart';
import 'package:armoyu_widgets/sources/chat/controllers/chatdetail_controller.dart';
import 'package:armoyu_widgets/translations/app_translation.dart';
import 'package:armoyu_widgets/widgets/text.dart';
import 'package:armoyu_widgets/widgetsv2/chat/chat_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

Widget widgetChatDetail(
  BuildContext context,
  service, {
  required Chat? cachedChat,
  Function(Chat updatedChat)? onChatUpdated,
  String chatImage =
      "https://img.freepik.com/free-photo/painting-mountain-lake-with-mountain-background_188544-9126.jpg",
  required Function(Chat chat) chatcall,
  required Function onClose,
  required Function(int userID, String username) onPressedtoProfile,
}) {
  final controller = Get.put(
    SourceChatdetailController(service, cachedChat, onChatUpdated),
    tag: cachedChat!.user.userID.toString(),
  );

  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: CachedNetworkImageProvider(chatImage),
        fit: BoxFit.cover,
        repeat: ImageRepeat.noRepeat,
      ),
    ),
    child: Column(
      children: [
        AppBar(
          backgroundColor: Colors.black45,
          automaticallyImplyLeading: false,
          title: Obx(
            () => controller.filteredchat.value == null
                ? Container()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText.costum1(
                        controller.filteredchat.value!.user.displayName!.value,
                        size: 17,
                        weight: FontWeight.bold,
                      ),
                      Row(
                        children: [
                          controller.filteredchat.value!.user.detailInfo == null
                              ? Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(width: 20),
                                )
                              : controller.filteredchat.value!.user.detailInfo!
                                          .value!.lastloginDateV2.value ==
                                      null
                                  ? Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(width: 20),
                                    )
                                  : Text(
                                      controller
                                                  .filteredchat
                                                  .value!
                                                  .user
                                                  .detailInfo!
                                                  .value!
                                                  .lastloginDateV2
                                                  .value ==
                                              null
                                          ? ""
                                          : controller
                                              .filteredchat
                                              .value!
                                              .user
                                              .detailInfo!
                                              .value!
                                              .lastloginDateV2
                                              .value
                                              .toString()
                                              .toString()
                                              .replaceAll('Saniye',
                                                  CommonKeys.second.tr)
                                              .replaceAll('Dakika',
                                                  CommonKeys.minute.tr)
                                              .replaceAll(
                                                  'Saat', CommonKeys.hour.tr)
                                              .replaceAll(
                                                  'Gün', CommonKeys.day.tr)
                                              .replaceAll(
                                                  'Ay', CommonKeys.month.tr)
                                              .replaceAll(
                                                  'Yıl', CommonKeys.year.tr)
                                              .replaceAll('Çevrimiçi',
                                                  CommonKeys.online.tr)
                                              .replaceAll('Çevrimdışı',
                                                  CommonKeys.offline.tr),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: controller
                                                    .filteredchat
                                                    .value!
                                                    .user
                                                    .detailInfo!
                                                    .value!
                                                    .lastloginDateV2
                                                    .toString() ==
                                                "Çevrimiçi"
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                        ],
                      ),
                    ],
                  ),
          ),
          leading: Obx(
            () => controller.filteredchat.value == null
                ? Container()
                : Builder(
                    builder: (BuildContext context) {
                      return Container(
                        padding: const EdgeInsets.all(12.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: GestureDetector(
                            onTap: () {
                              onPressedtoProfile(
                                controller.filteredchat.value!.user.userID!,
                                controller
                                    .filteredchat.value!.user.userName!.value,
                              );
                            },
                            child: CachedNetworkImage(
                              imageUrl: controller.filteredchat.value!.user
                                  .avatar!.mediaURL.minURL.value,
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.call),
              onPressed: () {
                chatcall(controller.filteredchat.value!);
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                controller.getlivechat(restartFetch: true);
              },
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                onClose();
              },
            ),
          ],
        ),
        Obx(
          () => controller.filteredchat.value == null
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : Expanded(
                  child: controller.filteredchat.value!.messages.value == null
                      ? Container()
                      : ListView.builder(
                          reverse: true,
                          controller: controller.scrollController.value,
                          itemCount: controller
                              .filteredchat.value!.messages.value!.length,
                          itemBuilder: (context, index) {
                            return ChatWidgetv2.messageBumble(
                              context,
                              message: controller.filteredchat.value!.messages
                                  .value![controller.filteredchat.value!
                                      .messages.value!.length -
                                  1 -
                                  index],
                            );
                          },
                        ),
                ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          color: Get.theme.scaffoldBackgroundColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    child: IconButton(
                      icon: const Icon(Icons.attach_file_sharp),
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Get.theme.cardColor,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Get.theme.scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextField(
                          controller: controller.messageController.value,
                          minLines: 1,
                          maxLines: 5,
                          cursorColor: Colors.blue,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            hintText: ChatKeys.chatwritemessage.tr,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4)
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5.0),
                child: IconButton(
                  onPressed: () async => controller.sendMessage(),
                  icon: const Icon(
                    Icons.send,
                    size: 16,
                    color: Colors.white,
                  ),
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
