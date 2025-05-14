class Music {
  final int musicID;
  final String name;
  final String? path;
  final String? pathURL;
  final String? img;
  final String? owner;
  bool ismyfav;

  Music({
    required this.musicID,
    required this.name,
    required this.path,
    this.pathURL,
    this.img,
    this.owner,
    this.ismyfav = false,
  });

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      musicID: json['musicID'],
      name: json['name'] ?? '',
      path: json['path'],
      pathURL: json['pathURL'],
      img: json['img'],
      owner: json['owner'],
      ismyfav: json['ismyfav'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'musicID': musicID,
      'name': name,
      'path': path,
      'pathURL': pathURL,
      'img': img,
      'owner': owner,
      'ismyfav': ismyfav,
    };
  }
}
