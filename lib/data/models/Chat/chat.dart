import 'package:armoyu_services/core/models/ARMOYU/API/chat/chat.dart';
import 'package:armoyu_widgets/data/models/Chat/chat_message.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu_widgets/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Chat {
  int? chatID;
  User user;
  Rx<ChatMessage>? lastmessage;
  Rxn<List<ChatMessage>> messages;
  APIChat chatType;
  Rx<bool> chatNotification;
  Rx<bool>? calling = false.obs;

  Chat({
    this.chatID,
    required this.user,
    this.lastmessage,
    Rxn<List<ChatMessage>>? messages,
    required this.chatType,
    required this.chatNotification,
    this.calling,
  }) : messages = messages ?? Rxn<List<ChatMessage>>();

  // Chat nesnesinden JSON'a dönüşüm
  Map<String, dynamic> toJson() {
    return {
      'chatID': chatID,
      'user': user.toJson(),
      'lastmessage': lastmessage?.value.toJson(),
      'messages': messages.value?.map((message) => message.toJson()).toList(),
      'chatType': chatType.name,
      'chatNotification': chatNotification.value,
      'calling': calling?.value ?? false,
    };
  }

  // JSON'dan Chat nesnesine dönüşüm
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      chatID: json['chatID'],
      user: User.fromJson(json['user']),
      lastmessage: json['lastmessage'] == null
          ? null
          : ChatMessage.fromJson(json['lastmessage']).obs,
      messages: json['messages'] == null
          ? Rxn<List<ChatMessage>>()
          : Rxn<List<ChatMessage>>(
              (json['messages'] as List<dynamic>?)
                  ?.map((member) => ChatMessage.fromJson(member))
                  .toList(),
            ),
      chatType: APIChat.values.firstWhere(
        (e) => e.name == json['chatType'],
        orElse: () => APIChat.ozel, // veya varsayılan olarak ne istiyorsan
      ),
      chatNotification: (json['chatNotification'] as bool).obs,
      calling: (json['calling'] as bool?)?.obs ?? false.obs,
    );
  }

  Widget profilesendMessage(context,
      {required UserAccounts currentUserAccounts}) {
    Future<void> sendmessage() async {
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => ChatDetailPage(
      //       chat: this,
      //       currentUserAccounts: currentUserAccounts,
      //     ),
      //   ),
      // );

      Get.toNamed("/chat/detail", arguments: {
        "chat": this,
        "CurrentUserAccounts": currentUserAccounts,
      });
    }

    return CustomButtons.friendbuttons(
        "Mesaj Gönder", sendmessage, Colors.blue);
  }
}
