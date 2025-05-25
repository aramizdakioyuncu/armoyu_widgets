import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/sources/gallery/bundle/gallery_bundle.dart';
import 'package:armoyu_widgets/sources/gallery/widgets/mediagallery/mediagallery_widget.dart';
import 'package:armoyu_widgets/sources/gallery/widgets/medialist/medialist_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GalleryWidget {
  final ARMOYUServices service;

  const GalleryWidget(this.service);

  GalleryWidgetBundle mediaGallery({
    required context,
    int? userID,
    String? username,
    List<Media>? cachedmediaList,
    Function(List<Media> updatedMedia)? onmediaUpdated,
    bool storyShare = false,
  }) {
    return mediaGalleryWidget(
      service: service,
      context: context,
      userID: userID,
      username: username,
      cachedmediaList: cachedmediaList,
      onmediaUpdated: onmediaUpdated,
      storyShare: storyShare,
    );
  }

  Widget mediaList(
    BuildContext context, {
    required Function(List<Media> onMediaUpdated)? onMediaUpdated,
    bool big = false,
    bool editable = false,
  }) {
    return mediaListWidget(
      service: service,
      context: context,
      onListUpdated: onMediaUpdated,
      big: big,
      editable: editable,
    );
  }
}
