import 'package:armoyu_widgets/data/models/user.dart';

class Notifications {
  final User user;
  final String text;
  final String date;
  final String category;
  final String categorydetail;
  final int categorydetailID;
  final bool enableButtons;

  Notifications({
    required this.user,
    required this.text,
    required this.date,
    required this.category,
    required this.categorydetail,
    required this.categorydetailID,
    required this.enableButtons,
  });
  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      user: User.fromJson(json['user']),
      text: json['text'] ?? '',
      date: json['date'] ?? '',
      category: json['category'] ?? '',
      categorydetail: json['categorydetail'] ?? '',
      categorydetailID: json['categorydetailID'] ?? 0,
      enableButtons: json['enableButtons'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'text': text,
      'date': date,
      'category': category,
      'categorydetail': categorydetail,
      'categorydetailID': categorydetailID,
      'enableButtons': enableButtons,
    };
  }
}
