import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';

class Game {
  final int gameID;
  final String name;
  final Media logo;
  final String gameURL;
  final String gameType;

  Game({
    required this.gameID,
    required this.name,
    required this.logo,
    required this.gameURL,
    required this.gameType,
  });

  // JSON'dan Game nesnesine dönüştürme
  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      gameID: json['gameID'] as int,
      name: json['name'] as String,
      logo: Media.fromJson(json['logo'] as Map<String, dynamic>),
      gameURL: json['gameURL'] as String,
      gameType: json['gameType'] as String,
    );
  }

  // Game nesnesini JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'gameID': gameID,
      'name': name,
      'logo': logo.toJson(),
      'gameURL': gameURL,
      'gameType': gameType,
    };
  }
}
