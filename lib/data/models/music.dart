class Music {
  final String name;
  final String? path;
  final String? pathURL;
  final String? img;
  final String? owner;

  Music({
    required this.name,
    required this.path,
    this.pathURL,
    this.img,
    this.owner,
  });
}
