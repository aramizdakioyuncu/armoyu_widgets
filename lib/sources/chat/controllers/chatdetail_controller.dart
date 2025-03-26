import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/chat/chat_detail_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/service_result.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/Chat/chat.dart';
import 'package:armoyu_widgets/data/models/Chat/chat_message.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/data/services/socketio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SourceChatdetailController extends GetxController {
  final ARMOYUServices service;
  final Chat chat;
  SourceChatdetailController(this.service, this.chat);

  var messageController = TextEditingController().obs;
  var scrollController = ScrollController().obs;

  var socketio = Get.find<SocketioController>();

  late Rxn<Chat> xchat = Rxn<Chat>();
  late Rxn<UserAccounts> currentUserAccounts = Rxn<UserAccounts>();
  @override
  void onInit() {
    super.onInit();

    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");

    /////
    currentUserAccounts.value =
        findCurrentAccountController.currentUserAccounts.value;
    /////
    xchat.value = chat;
    getlivechat();
  }

  Future<void> getlivechat({bool restartFetch = false}) async {
    ChatFetchDetailResponse response = await service.chatServices
        .fetchdetailChat(
            chatID: chat.user.userID!, chatCategory: chat.chatType);
    if (!response.result.status) {
      log(response.result.description);
      return;
    }

    if (response.response!.isEmpty) {
      return;
    }

    var ismee = true.obs;

    xchat.value!.messages ??= <ChatMessage>[].obs;

    if (restartFetch) {
      xchat.value!.messages = <ChatMessage>[].obs;
    }
    for (APIChatDetailList element in response.response!) {
      if (element.sohbetKim == "ben") {
        ismee.value = true;
      } else {
        ismee.value = false;
      }

      xchat.value!.messages!.add(
        ChatMessage(
          messageID: 0,
          isMe: ismee.value,
          messageContext: element.mesajIcerik,
          user: User(
            avatar: Media(
              mediaID: 0,
              mediaType: MediaType.image,
              mediaURL: MediaURL(
                bigURL: Rx(element.avatar),
                normalURL: Rx(element.avatar),
                minURL: Rx(element.avatar),
              ),
            ),
            displayName: Rx(element.adSoyad),
          ),
        ),
      );
      xchat.refresh();
      //SonMesajı güncelle
      xchat.value!.lastmessage!.value = ChatMessage(
        messageID: 0,
        isMe: ismee.value,
        messageContext: element.mesajIcerik,
        user: User(
          userID: xchat.value!.user.userID,
          avatar: xchat.value!.user.avatar,
          displayName: xchat.value!.user.displayName,
        ),
      );
    }
  }

  sendMessage() async {
    String message = messageController.value.text;

    if (messageController.value.text == "") {
      return;
    }

    messageController.value.text = "";
    chat.messages ??= <ChatMessage>[].obs;
    chat.messages!.add(
      ChatMessage(
        messageID: 0,
        isMe: true,
        messageContext: message,
        user: User(
          userID: currentUserAccounts.value!.user.value.userID,
          avatar: currentUserAccounts.value!.user.value.avatar,
          displayName: currentUserAccounts.value!.user.value.displayName,
        ),
      ),
    );

    // // //Son Mesajı güncelle
    chat.lastmessage = ChatMessage(
      messageID: 0,
      isMe: true,
      messageContext: message,
      user: User(
        userID: currentUserAccounts.value!.user.value.userID,
        avatar: currentUserAccounts.value!.user.value.avatar,
        displayName: currentUserAccounts.value!.user.value.displayName,
      ),
    ).obs;
    socketio.sendMessage(
      ChatMessage(
        messageID: 0,
        isMe: true,
        messageContext: message,
        user: User(
          userID: currentUserAccounts.value!.user.value.userID,
          avatar: currentUserAccounts.value!.user.value.avatar,
          displayName: currentUserAccounts.value!.user.value.displayName,
        ),
      ),
      chat.user.userID,
    );

    ServiceResult response = await service.chatServices.sendchatmessage(
      userID: chat.user.userID!,
      message: message,
      type: "ozel",
    );
    if (!response.status) {
      log(response.description);
      return;
    }
  }
}
