import 'package:armoyu_widgets/data/models/Chat/chat.dart';
import 'package:armoyu_widgets/data/models/Chat/chat_message.dart';
import 'package:armoyu_widgets/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatWidgetv2 {
  static Widget listtilechat(
    BuildContext context, {
    required Chat chat,
    required Function(Chat chat) onPressed,
    required VoidCallback onDelete,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        foregroundImage: CachedNetworkImageProvider(
          chat.user.avatar!.mediaURL.minURL.value,
        ),
        radius: 28,
      ),
      tileColor: chat.chatNotification.value ? Colors.red.shade900 : null,
      title: CustomText.costum1(chat.user.displayName!.value),
      subtitle: chat.lastmessage!.value.messageContext == "null"
          ? const Text("")
          : Row(
              children: [
                Expanded(
                  child: RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        if (chat.lastmessage!.value.messageContext == "null")
                          const WidgetSpan(
                            child: Icon(
                              Icons.done_all,
                              color: Color.fromRGBO(116, 243, 20, 1),
                              size: 14,
                            ),
                          ),
                        if (chat.lastmessage!.value.messageContext == "null")
                          const WidgetSpan(
                            child: SizedBox(width: 5),
                          ),
                        TextSpan(
                          text: chat.lastmessage!.value.messageContext,
                          style: TextStyle(
                            color: Get.theme.primaryColor.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      trailing: chat.chatType == "ozel"
          ? const Icon(Icons.person)
          : const Icon(Icons.people_alt),
      onTap: () {
        chat.chatNotification.value = false;
        onPressed(chat);
      },
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.delete, color: Colors.red),
                      title: const Text('Sil'),
                      onTap: () {
                        Navigator.pop(context);
                        onDelete();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Öğe silindi.'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static Widget messageBumble(BuildContext context,
      {required ChatMessage message}) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isMe)
            Container(
              padding: const EdgeInsets.only(right: 5),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                foregroundImage: CachedNetworkImageProvider(
                    message.user.avatar!.mediaURL.minURL.value),
              ),
            ),
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 70),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: message.isMe
                  ? Colors.blue
                  : const Color.fromARGB(255, 212, 78, 69),
              borderRadius: message.isMe
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    )
                  : const BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Text(
                        message.messageContext,
                        style: TextStyle(
                          color: message.isMe ? Colors.white : Colors.white,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: message.isMe,
                      child: const Positioned(
                        bottom: -3,
                        right: 0,
                        child: Icon(
                          Icons.done_all,
                          color: Color.fromRGBO(116, 243, 20, 1),
                          size: 14,
                        ), // Okundu işareti
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
