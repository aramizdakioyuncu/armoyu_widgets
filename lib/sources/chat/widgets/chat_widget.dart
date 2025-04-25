import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/Chat/chat.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/services/socketio.dart';
import 'package:armoyu_widgets/sources/chat/bundle/chat_bundle.dart';
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
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
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
                        mediaType: MediaType.image,
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

  ChatWidgetBundle chatListWidget(
    BuildContext context, {
    required Function(Chat chat) onPressed,
    List<Chat>? cachedChatList,
    Function(List<Chat> updatedChat)? onChatUpdated,
  }) {
    final controller = Get.put(
      SourceChatlistController(
        service: service,
        cachedChatList: cachedChatList,
        onChatUpdated: onChatUpdated,
      ),
    );
    Widget widget = Obx(
      () => controller.filteredchatList.value == null
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : Column(
              children: List.generate(
                controller.filteredchatList.value!.length,
                (index) {
                  return Obx(
                    () => ChatWidgetv2.listtilechat(
                      context,
                      chat: controller.filteredchatList.value![index],
                      onPressed: onPressed,
                      onDelete: () {
                        controller.filteredchatList.value!.removeWhere(
                          (element) =>
                              element.user.userID ==
                              controller
                                  .filteredchatList.value![index].user.userID,
                        );
                        controller.filteredchatList.refresh();
                      },
                    ),
                  );
                },
              ),
            ),
    );

    return ChatWidgetBundle(
      widget: Rxn(widget),
      refresh: () async => await controller.refreshAllChatList(),
      loadMore: () async => await controller.loadMoreChatList(),
      filterList: (String text) => controller.filterList(text),
    );
  }

  ChatWidgetBundle newchatListWidget(
    BuildContext context, {
    required Function(Chat chat) onPressed,
    List<Chat>? cachedChatList,
    Function(List<Chat> updatedChat)? onChatUpdated,
  }) {
    final controller = Get.put(
      SourceNewchatlistController(
        service,
        cachedChatList,
        onChatUpdated,
      ),
    );
    Widget widget = Obx(
      () => controller.filteredchatList.value == null
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : Column(
              children: List.generate(
                controller.filteredchatList.value!.length,
                (index) {
                  return Obx(
                    () => ChatWidgetv2.listtilechat(
                      context,
                      chat: controller.filteredchatList.value![index],
                      onPressed: onPressed,
                      onDelete: () {
                        controller.filteredchatList.value!.removeWhere(
                          (element) =>
                              element.user.userID ==
                              controller
                                  .filteredchatList.value![index].user.userID,
                        );
                        controller.filteredchatList.refresh();
                      },
                    ),
                  );
                },
              ),
            ),
    );

    return ChatWidgetBundle(
      widget: Rxn(widget),
      refresh: () async => await controller.refreshAllChatList(),
      loadMore: () async => await controller.loadMoreChatList(),
      filterList: (String text) => controller.filterList(text),
    );
  }

  Widget chatdetailWidget(
    BuildContext context, {
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
                          controller
                              .filteredchat.value!.user.displayName!.value,
                          size: 17,
                          weight: FontWeight.bold,
                        ),
                        Row(
                          children: [
                            controller.filteredchat.value!.user.detailInfo ==
                                    null
                                ? Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(width: 20),
                                  )
                                : controller
                                            .filteredchat
                                            .value!
                                            .user
                                            .detailInfo!
                                            .value!
                                            .lastloginDateV2
                                            .value ==
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

  Widget chatcallWidget(
    BuildContext context, {
    required Chat chat,
    required Function() onClose,
    required Function(bool value) speaker,
    required Function(bool value) videocall,
    bool createanswer = false,
  }) {
    final controller = Get.put(
      SourceChatcallController(),
      tag: "chatcall${chat.user.userID}",
    );
    var position = const Offset(20, 20).obs; // Başlangıç konumu

    final socketio = Get.find<SocketioController>();

    if (createanswer) {
      socketio.createOffer(
        id: controller.currentUserAccounts.value!.user.value.userID!,
        name:
            controller.currentUserAccounts.value!.user.value.displayName!.value,
        image: controller.currentUserAccounts.value!.user.value.avatar!.mediaURL
            .minURL.value,
        type: chat.chatType,
        wanteduser: chat.user.userID!,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        double availableWidth = constraints.maxWidth;
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.75),
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(
                        () => Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
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
                                          'https://api.aramizdakioyuncu.com/muzikler/tantasci-yalan.mp3',
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
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
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
                                          'https://api.aramizdakioyuncu.com/galeri/muzikler/11324orijinal1689174596.m4a',
                                        ),
                                      );
                                    } catch (e) {
                                      log(e.toString());
                                    }
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
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
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
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
                                          'https://api.aramizdakioyuncu.com/muzikler/kalbenhaydisoyle.mp3',
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
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
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

                                      onClose();
                                    } catch (e) {
                                      log(e.toString());
                                    }
                                  },
                                  icon: const Icon(Icons.call_end),
                                  color: controller.iconsColor.value,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Obx(
              () => socketio.connectionState.value !=
                      webrtc.RTCPeerConnectionState
                          .RTCPeerConnectionStateConnected
                  ? const SizedBox.shrink()
                  : Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: socketio.connectionState.value ==
                                  webrtc.RTCPeerConnectionState
                                      .RTCPeerConnectionStateConnected
                              ? null
                              : Colors.grey.shade900,
                          child: webrtc.RTCVideoView(
                            objectFit: webrtc.RTCVideoViewObjectFit
                                .RTCVideoViewObjectFitCover,
                            socketio.remoteRenderer.value,
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.change_circle)),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: availableWidth * 0.2 / 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Obx(
                                  () => Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 65.0,
                                          height: 65.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: controller.micIcon.value !=
                                                    Icons.mic
                                                ? Colors.red
                                                : controller.iconsbgColor.value,
                                          ),
                                          child: IconButton(
                                            onPressed: () async {
                                              if (controller.micMute.value) {
                                                controller.micMute.value =
                                                    false;
                                                controller.micIcon.value =
                                                    Icons.mic;
                                              } else {
                                                controller.micMute.value = true;
                                                controller.micIcon.value =
                                                    Icons.mic_off;
                                              }

                                              try {
                                                await controller.player.value
                                                    .play(
                                                  UrlSource(
                                                    'https://api.aramizdakioyuncu.com/muzikler/tantasci-yalan.mp3',
                                                  ),
                                                );
                                              } catch (e) {
                                                log(e.toString());
                                              }
                                            },
                                            icon:
                                                Icon(controller.micIcon.value),
                                            color: controller.iconsColor.value,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
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
                                                  AssetSource(
                                                      "sounds/calling_end.mp3"),
                                                );

                                                onClose();
                                              } catch (e) {
                                                log(e.toString());
                                              }
                                            },
                                            icon: const Icon(Icons.call_end),
                                            color: controller.iconsColor.value,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
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
                                                await controller.player.value
                                                    .play(
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
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            Obx(
              () => Positioned(
                left: position.value.dx,
                top: position.value.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    position.value += details.delta;
                  },
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: webrtc.RTCVideoView(
                        objectFit: webrtc
                            .RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                        socketio.localRenderer.value,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
