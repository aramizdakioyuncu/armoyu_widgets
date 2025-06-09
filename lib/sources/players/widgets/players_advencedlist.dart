import 'package:armoyu_widgets/sources/players/bundle/musiclist_bundle.dart';
import 'package:armoyu_widgets/sources/players/controllers/musicplayer_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

MusiclistWidgetBundle widgetPlayerAdvencedlist(
  BuildContext context,
  service, {
  Color buttonColor = Colors.white,
  Color? bgColors = Colors.black12,
}) {
  final controller = Get.put(MusicplayerController(service));

  Widget widget = Obx(
    () => controller.filteredmusicList.value == null
        ? Center(
            child: CupertinoActivityIndicator(),
          )
        : ListView(
            children: List.generate(
              controller.filteredmusicList.value!.length,
              (index) {
                return Obx(
                  () => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    child: ListTile(
                      textColor: Colors.white60,
                      iconColor: Colors.white60,
                      tileColor: Colors.grey.shade900,
                      selectedColor: Colors.red,
                      selectedTileColor: Colors.black38,
                      selected: index == controller.musicIndex.value,
                      contentPadding: EdgeInsets.symmetric(horizontal: 4),
                      onTap: () async {
                        if (index == controller.musicIndex.value) {
                          if (controller.playingmusic.value) {
                            controller.player.value.pause();
                            controller.musicController.reverse();
                            controller.playingmusic.value = false;
                          } else {
                            controller.player.value.resume();
                            controller.musicController.forward();
                            controller.playingmusic.value = true;
                          }

                          return;
                        }

                        controller.musicController.forward();
                        controller.musicIndex.value = index;
                        controller.playingmusic.value = false;

                        controller.playmusic();
                        controller.playingmusic.value = true;
                      },
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: controller
                                        .filteredmusicList.value![index].img ==
                                    null
                                ? AssetImage(
                                    "packages/armoyu_widgets/assets/images/notfound.jpg",
                                  )
                                : CachedNetworkImageProvider(
                                    controller
                                        .filteredmusicList.value![index].img!,
                                  ),
                          ),
                        ),
                      ),
                      title: Text(
                        controller.filteredmusicList.value![index].name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        controller.filteredmusicList.value![index].owner ?? "",
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Obx(
                          () => index != controller.musicIndex.value
                              ? Icon(
                                  Icons.play_arrow_rounded,
                                )
                              : AnimatedIcon(
                                  icon: AnimatedIcons.play_pause,
                                  progress: controller.musicController,
                                  color: buttonColor,
                                ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
  );

  return MusiclistWidgetBundle(
    widget: Rxn(widget),
    play: () async => await controller.playmusic(),
    stop: () async => await controller.player.value.stop(),
  );
}
