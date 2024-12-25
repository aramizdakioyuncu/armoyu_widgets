import 'package:armoyu_widgets/data/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ChatMessage {
  int messageID;
  String messageContext;
  User user;
  bool isMe;

  ChatMessage({
    required this.messageID,
    required this.messageContext,
    required this.user,
    required this.isMe,
  });

// ChatMessage nesnesinden JSON'a dönüşüm
  Map<String, dynamic> toJson() {
    return {
      'messageID': messageID,
      'messageContext': messageContext,
      'user': user.toJson(),
      'isMe': isMe,
    };
  }

  // JSON'dan ChatMessage nesnesine dönüşüm
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      messageID: json['messageID'],
      messageContext: json['messageContext'],
      user: User.fromJson(json['user']),
      isMe: json['isMe'],
    );
  }

  Widget messageBumble(context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            Container(
              padding: const EdgeInsets.only(right: 5),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                foregroundImage: CachedNetworkImageProvider(
                    user.avatar!.mediaURL.minURL.value),
              ),
            ),
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 70),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color:
                  isMe ? Colors.blue : const Color.fromARGB(255, 212, 78, 69),
              borderRadius: isMe
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
                        messageContext,
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.white,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isMe,
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
