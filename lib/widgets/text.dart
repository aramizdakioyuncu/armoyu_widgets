import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomText {
  static Text costum1(
    String text, {
    double? size,
    FontWeight? weight,
    TextAlign align = TextAlign.left,
    Color? color,
  }) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: weight,
      ),
      textAlign: align,
    );
  }

  static Widget usercomments(
    BuildContext context, {
    required String text,
    required User user,
    required Function({
      required int userID,
      required String username,
      required String displayname,
      required Media avatar,
      required Media? banner,
    }) profileFunction,
  }) {
    final textSpans = <InlineSpan>[];
    textSpans.add(
      TextSpan(
        children: [
          TextSpan(
            text: user.displayName!.value,
            style: TextStyle(
              color: Get.theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                profileFunction(
                  userID: user.userID!,
                  username: user.userName!.value,
                  displayname: user.displayName!.value,
                  avatar: Media(
                    mediaID: 0,
                    mediaType: MediaType.image,
                    mediaURL: MediaURL(
                      bigURL: user.avatar!.mediaURL.bigURL,
                      normalURL: user.avatar!.mediaURL.normalURL,
                      minURL: user.avatar!.mediaURL.minURL,
                    ),
                  ),
                  banner: null,
                );
              },
          )
        ],
      ),
    );

    textSpans.add(
      TextSpan(
        text: " $text",
        style: TextStyle(
          color: Get.theme.primaryColor,
        ),
      ),
    );

    textSpans.insert(0, const WidgetSpan(child: SizedBox(width: 5)));
    textSpans.insert(
      0,
      WidgetSpan(
        child: InkWell(
          onTap: () {
            profileFunction(
              userID: user.userID!,
              username: user.displayName!.value,
              displayname: user.displayName!.value,
              avatar: Media(
                mediaID: 0,
                mediaType: MediaType.image,
                mediaURL: MediaURL(
                  bigURL: user.avatar!.mediaURL.bigURL,
                  normalURL: user.avatar!.mediaURL.normalURL,
                  minURL: user.avatar!.mediaURL.minURL,
                ),
              ),
              banner: null,
            );
          },
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            foregroundImage: CachedNetworkImageProvider(
              user.avatar!.mediaURL.minURL.value,
            ),
            radius: 8,
          ),
        ),
      ),
    );
    return RichText(
      text: TextSpan(children: textSpans),
    );
  }
}
