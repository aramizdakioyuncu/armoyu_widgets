import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/Social/post.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/services/app_service.dart';

class PostsView extends StatelessWidget {
  const PostsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AppService.widgets.social.postWidget(
              context,
              post: Post(
                postID: 1,
                content: "content",
                postDate: "10.11.2022",
                sharedDevice: "Android",
                likesCount: 10,
                isLikeme: true,
                commentsCount: 10,
                iscommentMe: true,
                owner: User(
                  userID: 1,
                  displayName: Rx("User Display Name"),
                  userName: Rx("User Display Name"),
                  avatar: Media(
                    mediaID: 0,
                    mediaURL: MediaURL(
                      bigURL: Rx(
                          "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png"),
                      normalURL: Rx(
                          "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png"),
                      minURL: Rx(
                          "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png"),
                    ),
                  ),
                ),
                media: [
                  Media(
                    mediaID: 0,
                    mediaURL: MediaURL(
                      bigURL: Rx(
                          "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png"),
                      normalURL: Rx(
                          "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png"),
                      minURL: Rx(
                          "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png"),
                    ),
                    mediaType: "image/png",
                  ),
                ],
                firstthreecomment: [],
                firstthreelike: [],
                location: "location",
              ),
              isPostdetail: false,
            ),
          ],
        ),
      ),
    );
  }
}
