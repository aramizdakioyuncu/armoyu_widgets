import 'package:get/get.dart';

class Socialaccounts {
  Rxn<String>? facebook;
  Rxn<String>? github;
  Rxn<String>? instagram;
  Rxn<String>? linkedin;
  Rxn<String>? reddit;
  Rxn<String>? steam;
  Rxn<String>? twitch;
  Rxn<String>? youtube;
  Rxn<String>? discord;

  Socialaccounts({
    required this.facebook,
    required this.github,
    required this.instagram,
    required this.linkedin,
    required this.reddit,
    required this.steam,
    required this.twitch,
    required this.youtube,
    required this.discord,
  });

  // JSON'dan Socialaccounts nesnesine dönüştürme
  factory Socialaccounts.fromJson(Map<String, dynamic> json) {
    return Socialaccounts(
      facebook: Rxn<String>(json['facebook']),
      github: Rxn<String>(json['github']),
      instagram: Rxn<String>(json['instagram']),
      linkedin: Rxn<String>(json['linkedin']),
      reddit: Rxn<String>(json['reddit']),
      steam: Rxn<String>(json['steam']),
      twitch: Rxn<String>(json['twitch']),
      youtube: Rxn<String>(json['youtube']),
      discord: Rxn<String>(json['discord']),
    );
  }

  // Socialaccounts nesnesini JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'facebook': facebook?.value,
      'github': github?.value,
      'instagram': instagram?.value,
      'linkedin': linkedin?.value,
      'reddit': reddit?.value,
      'steam': steam?.value,
      'twitch': twitch?.value,
      'youtube': youtube?.value,
      'discord': discord?.value,
    };
  }
}
