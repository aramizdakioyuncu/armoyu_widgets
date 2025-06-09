import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/data/models/Chat/chat.dart';
import 'package:armoyu_widgets/sources/chat/bundle/chat_bundle.dart';
import 'package:armoyu_widgets/sources/chat/widgets/chat_call.dart';
import 'package:armoyu_widgets/sources/chat/widgets/chat_detail.dart';
import 'package:armoyu_widgets/sources/chat/widgets/chat_list.dart';
import 'package:armoyu_widgets/sources/chat/widgets/chat_newlist.dart';
import 'package:armoyu_widgets/sources/chat/widgets/chat_notes.dart';

import 'package:flutter/material.dart';

class ChatWidget {
  final ARMOYUServices service;

  const ChatWidget(this.service);

  Widget chatmyfriendsNotes(BuildContext context) {
    return widgetChatNotes(context, service);
  }

  ChatWidgetBundle chatListWidget(
    BuildContext context, {
    required Function(Chat chat) onPressed,
    List<Chat>? cachedChatList,
    Function(List<Chat> updatedChat)? onChatUpdated,
  }) {
    return widgetChatList(
      context,
      service,
      onPressed: onPressed,
      cachedChatList: cachedChatList,
      onChatUpdated: onChatUpdated,
    );
  }

  ChatWidgetBundle newchatListWidget(
    BuildContext context, {
    required Function(Chat chat) onPressed,
    List<Chat>? cachedChatList,
    Function(List<Chat> updatedChat)? onChatUpdated,
  }) {
    return widgetNewList(
      context,
      service,
      onPressed: onPressed,
      cachedChatList: cachedChatList,
      onChatUpdated: onChatUpdated,
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
    return widgetChatDetail(
      context,
      service,
      cachedChat: cachedChat,
      chatcall: chatcall,
      onClose: onClose,
      onPressedtoProfile: onPressedtoProfile,
      chatImage: chatImage,
      onChatUpdated: onChatUpdated,
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
    return widgetChatCall(
      context,
      chat: chat,
      onClose: onClose,
      speaker: speaker,
      videocall: videocall,
      createanswer: createanswer,
    );
  }
}
