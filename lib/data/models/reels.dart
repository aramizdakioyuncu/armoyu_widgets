import 'package:armoyu_widgets/data/models/user.dart';

class Reels {
  final int id;
  final String videoUrl;
  final String thumbnailUrl;
  final User owner;
  final String description;
  final DateTime createdAt;
  int likeCount;
  int commentCount;
  int shareCount;

  Reels({
    required this.id,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.owner,
    required this.description,
    required this.createdAt,
    this.likeCount = 0,
    this.commentCount = 0,
    this.shareCount = 0,
  });

  factory Reels.fromJson(Map<String, dynamic> json) {
    return Reels(
      id: json['id'],
      videoUrl: json['video_url'],
      thumbnailUrl: json['thumbnail_url'],
      owner: User.fromJson(json['owner']),
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      likeCount: json['like_count'] ?? 0,
      commentCount: json['comment_count'] ?? 0,
      shareCount: json['share_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'video_url': videoUrl,
      'thumbnail_url': thumbnailUrl,
      'owner': owner.toJson(),
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'like_count': likeCount,
      'comment_count': commentCount,
      'share_count': shareCount,
    };
  }
}
