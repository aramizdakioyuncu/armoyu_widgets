import 'package:armoyu_widgets/data/models/user.dart';

class Comment {
  final int commentID;
  final int postID;
  final User user;
  final String date;
  String content;
  int likeCount;
  bool didIlike;

  Comment({
    required this.commentID,
    required this.postID,
    required this.user,
    required this.content,
    required this.likeCount,
    required this.didIlike,
    required this.date,
  });

  // Comment nesnesinden JSON'a dönüşüm
  Map<String, dynamic> toJson() {
    return {
      'commentID': commentID,
      'postID': postID,
      'user': user.toJson(),
      'date': date,
      'content': content,
      'likeCount': likeCount,
      'didIlike': didIlike,
    };
  }

  // JSON'dan Comment nesnesine dönüşüm
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentID: json['commentID'],
      postID: json['postID'],
      user: User.fromJson(json['user']),
      date: json['date'],
      content: json['content'],
      likeCount: json['likeCount'],
      didIlike: json['didIlike'],
    );
  }
}
