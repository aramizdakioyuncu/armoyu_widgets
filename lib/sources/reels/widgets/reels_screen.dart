import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/reels.dart';
import 'package:armoyu_widgets/sources/reels/controllers/reels_screen_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:media_kit_video/media_kit_video.dart';

class ReelsScreen extends StatelessWidget {
  final Reels reels;
  final int index;
  final Function({
    required int userID,
    required String username,
    required String? displayname,
    required Media? avatar,
    required Media? banner,
  }) profileFunction;

  const ReelsScreen({
    super.key,
    required this.reels,
    required this.index,
    required this.profileFunction,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      ReelsScreenController(reels: reels),
      tag: index.toString(),
    );
    Reels reelsINFO = reels;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GestureDetector(
                onTap: () {
                  controller.videoController.player.playOrPause();
                },
                child: Video(
                  controls: (state) {
                    //Controlleri sildim

                    return SizedBox.shrink();
                  },
                  fit: BoxFit.cover,
                  controller: controller.videoController,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  profileFunction(
                                    userID: reelsINFO.owner.userID!,
                                    username: reelsINFO.owner.userName!.value,
                                    displayname:
                                        reelsINFO.owner.displayName!.value,
                                    avatar: reelsINFO.owner.avatar,
                                    banner: null,
                                  );
                                },
                                child: CircleAvatar(
                                  foregroundImage: CachedNetworkImageProvider(
                                      reelsINFO
                                          .owner.avatar!.mediaURL.minURL.value),
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(reelsINFO.owner.displayName!.value),
                            ],
                          ),
                          Text(
                            reelsINFO.description,
                          )
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: [
                            LikeButton(
                              likeBuilder: (bool isLiked) {
                                return Icon(
                                  isLiked ? Icons.favorite : Icons.favorite,
                                  color: isLiked ? Colors.red : Colors.white,
                                  size: 25,
                                );
                              },
                            ),
                            Text(reelsINFO.likeCount.toString()),
                          ],
                        ),
                        SizedBox(height: 10),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.comment_rounded,
                              ),
                            ),
                            Text(reelsINFO.commentCount.toString()),
                          ],
                        ),
                        SizedBox(height: 10),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.send_sharp,
                              ),
                            ),
                            Text(reelsINFO.shareCount.toString()),
                          ],
                        ),
                        SizedBox(height: 10),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.more_horiz,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 26,
                          width: 26,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: CircleAvatar(
                            foregroundImage: CachedNetworkImageProvider(
                              "https://storage.aramizdakioyuncu.com/galeri/profilresimleri/1profilresimufaklik1734874339.jpg",
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
