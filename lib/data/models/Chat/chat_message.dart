import 'package:armoyu_widgets/data/models/user.dart';

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
}
