import 'dart:developer';

import 'package:armoyu_widgets/data/models/Chat/chat.dart';
import 'package:armoyu_widgets/data/services/socketio.dart';
import 'package:armoyu_widgets/sources/chat/controllers/chatcall_controller.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:get/get.dart';

Widget widgetChatCall(
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
                                          'https://storage.aramizdakioyuncu.com/muzikler/tantasci-yalan.mp3',
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
                                          'https://storage.aramizdakioyuncu.com/galeri/muzikler/11324orijinal1689174596.m4a',
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
                                          'https://storage.aramizdakioyuncu.com/muzikler/kalbenhaydisoyle.mp3',
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
                                        AssetSource(
                                          "packages/armoyu_widgets/assets/sounds/calling_end.mp3",
                                        ),
                                      );
                                      socketio.closecall("${chat.user.userID}");
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
                                                    'https://storage.aramizdakioyuncu.com/muzikler/tantasci-yalan.mp3',
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
                                                    "packages/armoyu_widgets/assets/sounds/calling_end.mp3",
                                                  ),
                                                );
                                                socketio.peerConnection
                                                    ?.close();
                                                await socketio.localStream
                                                    ?.dispose();

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