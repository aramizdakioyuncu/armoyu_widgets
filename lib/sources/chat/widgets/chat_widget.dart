import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/Chat/chat.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/sources/chat/controllers/chatcall_controller.dart';
import 'package:armoyu_widgets/sources/chat/controllers/chatdetail_controller.dart';
import 'package:armoyu_widgets/sources/chat/controllers/chatfriendnote_controller.dart';
import 'package:armoyu_widgets/sources/chat/controllers/chatlist_controller.dart';
import 'package:armoyu_widgets/sources/chat/controllers/newchatlist_controller.dart';
import 'package:armoyu_widgets/translations/app_translation.dart';
import 'package:armoyu_widgets/widgets/text.dart';
import 'package:armoyu_widgets/widgetsv2/chat/chat_widget.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ChatWidget {
  final ARMOYUServices service;

  const ChatWidget(this.service);

  Widget chatmyfriendsNotes(BuildContext context) {
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
                      userName:
                          Rx(controller.friendlist.value![index].username),
                      displayName:
                          Rx(controller.friendlist.value![index].displayName),
                      avatar: Media(
                        mediaID: 0,
                        mediaURL: MediaURL(
                          bigURL: Rx(
                            controller.friendlist.value![index].avatar.bigURL,
                          ),
                          normalURL: Rx(
                            controller
                                .friendlist.value![index].avatar.normalURL,
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

  Widget chatListWidget(
    BuildContext context, {
    required ScrollController scrollController,
    required Function(Chat chat) onPressed,
  }) {
    final controller = Get.put(SourceChatlistController(service));
    return Obx(
      () => controller.filteredItems.value == null
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: List.generate(
                  controller.filteredItems.value!.length,
                  (index) {
                    return Obx(
                      () => ChatWidgetv2.listtilechat(
                        context,
                        chat: controller.filteredItems.value![index],
                        onPressed: onPressed,
                        onDelete: () {
                          controller.filteredItems.value!.removeWhere(
                            (element) =>
                                element.user.userID ==
                                controller
                                    .filteredItems.value![index].user.userID,
                          );
                          controller.filteredItems.refresh();
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  Widget newchatListWidget(
    BuildContext context, {
    required ScrollController scrollController,
    required Function(Chat chat) onPressed,
  }) {
    final controller =
        Get.put(SourceNewchatlistController(service, scrollController));
    return Obx(
      () => controller.chatList.value == null
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: List.generate(
                  controller.chatList.value!.length,
                  (index) {
                    return Obx(
                      () => ChatWidgetv2.listtilechat(
                        context,
                        chat: controller.chatList.value![index],
                        onPressed: onPressed,
                        onDelete: () {
                          controller.chatList.value!.removeWhere(
                            (element) =>
                                element.user.userID ==
                                controller.chatList.value![index].user.userID,
                          );
                          controller.chatList.refresh();
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  Widget chatdetailWidget(
    BuildContext context, {
    required Chat chat,
    String chatImage =
        "https://img.freepik.com/free-photo/painting-mountain-lake-with-mountain-background_188544-9126.jpg",
    required Function(Chat chat) chatcall,
    required Function onClose,
    required Function(int userID, String username) onPressedtoProfile,
  }) {
    final controller = Get.put(
      SourceChatdetailController(service, chat),
      tag: chat.user.userID.toString(),
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
              () => controller.xchat.value == null
                  ? Container()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText.costum1(
                          controller.xchat.value!.user.displayName!.value,
                          size: 17,
                          weight: FontWeight.bold,
                        ),
                        Row(
                          children: [
                            controller.xchat.value!.user.detailInfo!.value!
                                        .lastloginDateV2.value ==
                                    null
                                ? Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(width: 20),
                                  )
                                : Text(
                                    controller.xchat.value!.user.detailInfo!
                                                .value!.lastloginDateV2.value ==
                                            null
                                        ? ""
                                        : controller
                                            .xchat
                                            .value!
                                            .user
                                            .detailInfo!
                                            .value!
                                            .lastloginDateV2
                                            .value
                                            .toString()
                                            .toString()
                                            .replaceAll(
                                                'Saniye', CommonKeys.second.tr)
                                            .replaceAll(
                                                'Dakika', CommonKeys.minute.tr)
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
                                                  .xchat
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
              () => controller.xchat.value == null
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
                                  controller.xchat.value!.user.userID!,
                                  controller.xchat.value!.user.userName!.value,
                                );
                              },
                              child: CachedNetworkImage(
                                imageUrl: controller.xchat.value!.user.avatar!
                                    .mediaURL.minURL.value,
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
                  chatcall(chat);
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
            () => controller.xchat.value == null
                ? const Center(
                    child: CupertinoActivityIndicator(),
                  )
                : Expanded(
                    child: controller.xchat.value!.messages == null
                        ? Container()
                        : ListView.builder(
                            reverse: true,
                            controller: controller.scrollController.value,
                            itemCount: controller.xchat.value!.messages!.length,
                            itemBuilder: (context, index) {
                              return ChatWidgetv2.messageBumble(
                                context,
                                message: controller.xchat.value!.messages![
                                    chat.messages!.length - 1 - index],
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

  Widget chatcallWidget(
    BuildContext context, {
    required Chat chat,
    required Function(Chat chat) onClose,
    required Function(bool value) speaker,
    required Function(bool value) videocall,
  }) {
    final controller = Get.put(
      SourceChatcallController(),
      tag: chat.user.userID.toString(),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        double availableWidth = constraints.maxWidth;
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                    Colors.black..withValues(alpha: 0.75),
                    BlendMode.darken,
                  ),
                  image: CachedNetworkImageProvider(
                    chat.user.avatar!.mediaURL.normalURL.value,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: availableWidth * 0.2 / 10),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: chat.user.avatar!.mediaURL.minURL.value,
                              width: availableWidth / 5 > 200
                                  ? 200
                                  : availableWidth / 5,
                              height: availableWidth / 5 > 200
                                  ? 200
                                  : availableWidth / 5,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Obx(
                            () => Column(
                              children: [
                                Text(
                                  chat.user.displayName!.value,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(controller.callingtext.value),
                                const SizedBox(height: 5),
                                Text(
                                  controller.formatTime(
                                    controller
                                        .stopwatch.value.elapsedMilliseconds,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: availableWidth * 0.2 / 10),
                  child: Column(
                    children: [
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 65.0,
                              height: 65.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: controller.micIcon.value != Icons.mic
                                    ? Colors.red
                                    : controller.iconsbgColor.value,
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  if (controller.micMute.value) {
                                    controller.micMute.value = false;
                                    controller.micIcon.value = Icons.mic;
                                  } else {
                                    controller.micMute.value = true;
                                    controller.micIcon.value = Icons.mic_off;
                                  }

                                  try {
                                    await controller.player.value.play(
                                      UrlSource(
                                        'https://aramizdakioyuncu.com/muzikler/tantasci-yalan.mp3',
                                      ),
                                    );
                                  } catch (e) {
                                    log(e.toString());
                                  }
                                },
                                icon: Icon(controller.micIcon.value),
                                color: controller.iconsColor.value,
                              ),
                            ),
                            Container(
                              width: 65.0,
                              height: 65.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: controller.iconsbgColor.value,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.video_call),
                                color: controller.iconsColor.value,
                                onPressed: () async {
                                  controller.videocall.value =
                                      !controller.videocall.value;
                                  videocall(controller.videocall.value);
                                  try {
                                    await controller.player.value.play(
                                      UrlSource(
                                        'https://aramizdakioyuncu.com/galeri/muzikler/11324orijinal1689174596.m4a',
                                      ),
                                    );
                                  } catch (e) {
                                    log(e.toString());
                                  }
                                },
                              ),
                            ),
                            Container(
                              width: 65.0,
                              height: 65.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: controller.speaker.value
                                    ? Colors.white
                                    : controller.iconsbgColor.value,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.volume_up_rounded,
                                  color: controller.speaker.value
                                      ? Colors.black
                                      : controller.iconsColor.value,
                                ),
                                onPressed: () async {
                                  controller.speaker.value =
                                      !controller.speaker.value;
                                  speaker(controller.speaker.value);
                                  try {
                                    await controller.player.value.play(
                                      UrlSource(
                                        'https://www.sanalsantral.com.tr/tema/default/music/karsilama.mp3',
                                      ),
                                    );
                                  } catch (e) {
                                    log(e.toString());
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 65.0,
                              height: 65.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: controller.iconsbgColor.value),
                              child: IconButton(
                                onPressed: () async {
                                  try {
                                    await controller.player.value.play(
                                      UrlSource(
                                        'https://aramizdakioyuncu.com/muzikler/kalbenhaydisoyle.mp3',
                                      ),
                                    );
                                  } catch (e) {
                                    log(e.toString());
                                  }
                                },
                                icon: const Icon(Icons.numbers_rounded),
                                color: controller.iconsColor.value,
                              ),
                            ),
                            Container(
                              width: 65.0,
                              height: 65.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  try {
                                    controller.player.value.play(
                                      AssetSource("sounds/calling_end.mp3"),
                                    );

                                    onClose(chat);
                                  } catch (e) {
                                    log(e.toString());
                                  }
                                },
                                icon: const Icon(Icons.call_end),
                                color: controller.iconsColor.value,
                              ),
                            ),
                            Container(
                              width: 65.0,
                              height: 65.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: controller.iconsbgColor.value,
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  try {
                                    await controller.player.value.play(
                                      UrlSource(
                                        'https://cdn.pixabay.com/audio/2024/12/09/audio_5c5be993bd.mp3',
                                      ),
                                    );
                                  } catch (e) {
                                    log(e.toString());
                                  }
                                },
                                icon: const Icon(Icons.person_add),
                                color: controller.iconsColor.value,
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
          ],
        );
      },
    );
  }
}
