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
  Chat? cachedChatList;
  Function(Chat updatedChat)? onChatUpdated;

  SourceChatdetailController(
    this.service,
    this.cachedChatList,
    this.onChatUpdated,
  );

  var messageController = TextEditingController().obs;
  var scrollController = ScrollController().obs;

  var socketio = Get.find<SocketioController>();

  late Rxn<UserAccounts> currentUserAccounts = Rxn<UserAccounts>();

  var chat = Rxn<Chat>();
  var filteredchat = Rxn<Chat>();

  void updateChat() {
    chat.refresh();
    filteredchat.refresh();
    onChatUpdated?.call(chat.value!);
  }

  @override
  void onInit() {
    super.onInit();

    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");

    /////
    currentUserAccounts.value =
        findCurrentAccountController.currentUserAccounts.value;
    /////

    if (cachedChatList != null) {
      chat.value = cachedChatList;
      filteredchat.value = cachedChatList;
    }

    getlivechat();
  }

  Future<void> getlivechat({bool restartFetch = false}) async {
    ChatFetchDetailResponse response =
        await service.chatServices.fetchdetailChat(
      chatID: chat.value!.user.userID!,
      chatCategory: chat.value!.chatType,
    );
    if (!response.result.status) {
      log(response.result.description);
      return;
    }

    if (response.response!.isEmpty) {
      return;
    }

    filteredchat.value!.messages.value ??= [];
    chat.value!.messages.value ??= [];

    if (restartFetch) {
      chat.value!.messages.value = [];
    }

    for (APIChatDetailList element in response.response!) {
      bool? ismee;
      if (element.sohbetKim == "ben") {
        ismee = true;
      } else {
        ismee = false;
      }

      chat.value!.messages.value!.add(
        ChatMessage(
          messageID: 0,
          isMe: ismee,
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

      //SonMesajı güncelle
      chat.value!.lastmessage!.value = ChatMessage(
        messageID: 0,
        isMe: ismee,
        messageContext: element.mesajIcerik,
        user: User(
          userID: chat.value!.user.userID,
          avatar: chat.value!.user.avatar,
          displayName: chat.value!.user.displayName,
        ),
      );

      updateChat();
    }
  }

  sendMessage() async {
    String message = messageController.value.text;

    if (messageController.value.text == "") {
      return;
    }

    messageController.value.text = "";
    chat.value!.messages.value ??= [];
    chat.value!.messages.value!.add(
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
    chat.value!.lastmessage = ChatMessage(
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
      chat.value!.user.userID,
    );
    updateChat();

    ServiceResult response = await service.chatServices.sendchatmessage(
      userID: chat.value!.user.userID!,
      message: message,
      type: "ozel",
    );
    if (!response.status) {
      log(response.description);
      return;
    }
  }
}
