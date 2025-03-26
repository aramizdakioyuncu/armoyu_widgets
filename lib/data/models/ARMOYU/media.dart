import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

enum MediaType { image, video }

class Media {
  int mediaID;
  XFile? mediaXFile;
  Uint8List? mediaBytes;
  int? ownerID;
  String? ownerusername;
  String? owneravatar;
  String? mediaTime;
  MediaType mediaType;
  MediaURL mediaURL;
  String? mediaDirection;

  Media({
    required this.mediaID,
    this.mediaXFile,
    this.mediaBytes,
    this.ownerID,
    this.ownerusername,
    this.owneravatar,
    this.mediaTime,
    required this.mediaType,
    required this.mediaURL,
    this.mediaDirection,
  });

  // Media nesnesinden JSON'a dönüşüm
  Map<String, dynamic> toJson() {
    return {
      'mediaID': mediaID,
      'mediaXFile': mediaXFile?.path,
      'mediaBytes': mediaBytes?.toList(),
      'ownerID': ownerID,
      'ownerusername': ownerusername,
      'owneravatar': owneravatar,
      'mediaTime': mediaTime,
      'mediaType': mediaType.toString().split('.').last,
      'mediaURL': mediaURL.toJson(),
      'mediaDirection': mediaDirection,
    };
  }

  // JSON'dan Post nesnesine dönüşüm
  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      mediaID: json['mediaID'],
      mediaXFile: json['mediaXFile'] != null ? XFile(json['mediaXFile']) : null,
      mediaBytes: json['mediaBytes'] != null
          ? Uint8List.fromList(List<int>.from(json['mediaBytes']))
          : null,
      ownerID: json['ownerID'],
      ownerusername: json['ownerusername'],
      owneravatar: json['owneravatar'],
      mediaTime: json['mediaTime'],
      mediaType: MediaType.values
          .firstWhere((e) => e.toString() == 'MediaType.${json['mediaType']}'),
      mediaURL: MediaURL.fromJson(json['mediaURL']),
      mediaDirection: json['mediaDirection'],
    );
  }
}

class MediaURL {
  Rx<String> bigURL;
  Rx<String> normalURL;
  Rx<String> minURL;

  MediaURL({
    required this.bigURL,
    required this.normalURL,
    required this.minURL,
  });

  Map<String, dynamic> toJson() {
    return {
      'bigURL': bigURL.value,
      'normalURL': normalURL.value,
      'minURL': minURL.value,
    };
  }

  factory MediaURL.fromJson(Map<String, dynamic> json) {
    return MediaURL(
      bigURL: Rx<String>(json['bigURL']),
      normalURL: Rx<String>(json['normalURL']),
      minURL: Rx<String>(json['minURL']),
    );
  }
}
