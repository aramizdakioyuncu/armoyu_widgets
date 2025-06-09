import 'package:armoyu_widgets/sources/players/bundle/musicplayer_bundle.dart';
import 'package:armoyu_widgets/sources/players/controllers/musicplayer_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

PlayerWidgetBundle widgetPlayerMusic(service) {
  final controller = Get.put(MusicplayerController(service));

  Widget widget = Obx(
    () => MouseRegion(
      onEnter: (event) {
        controller.isVisible.value = true;
      },
      onExit: (event) async {
        controller.isVisible.value = false;
      },
      child: Container(
        height: 80,
        width: 440,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black,
              Colors.purple,
              Colors.red,
              Colors.orange,
            ],
          ),
          border: Border.all(color: Colors.black, width: 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 20),
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.black45,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: controller.musicIndex.value == null
                        ? AssetImage(
                            "packages/armoyu_widgets/assets/images/notfound.jpg",
                          )
                        : controller.filteredmusicList
                                    .value![controller.musicIndex.value!].img ==
                                null
                            ? AssetImage(
                                "packages/armoyu_widgets/assets/images/notfound.jpg",
                              )
                            : CachedNetworkImageProvider(
                                controller.filteredmusicList
                                    .value![controller.musicIndex.value!].img!,
                              ),
                  ),
                ),
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    progress: controller.musicController,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (controller.playingmusic.value) {
                      controller.player.value.pause();
                      controller.musicController.reverse();
                      controller.playingmusic.value = false;
                    } else {
                      controller.player.value.resume();
                      controller.musicController.forward();
                      controller.playingmusic.value = true;
                    }
                  },
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text(
                        controller.musicIndex.value == null
                            ? ""
                            : controller.filteredmusicList
                                .value![controller.musicIndex.value!].name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Obx(
                      () => Text(
                        controller.musicIndex.value == null
                            ? ""
                            : controller
                                    .filteredmusicList
                                    .value![controller.musicIndex.value!]
                                    .owner ??
                                "",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Obx(
                      () => Row(
                        children: [
                          Text(
                            "${controller.musicCurrentPosition.value.toString().split('.').first.split(':')[1]}:${controller.musicCurrentPosition.value.toString().split('.').first.split(':')[2]}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 150,
                              height: 5,
                              child: Obx(
                                () => Slider(
                                  min: 0,
                                  max: controller
                                      .musicmaxPosition.value.inMilliseconds
                                      .toDouble(), // Maksimum süre
                                  value: controller
                                      .musicCurrentPosition.value.inMilliseconds
                                      .toDouble()
                                      .clamp(
                                          0.0,
                                          controller.musicmaxPosition.value
                                              .inMilliseconds
                                              .toDouble()), // Geçerli süre
                                  activeColor: Colors.orange,
                                  inactiveColor:
                                      Colors.red.withValues(alpha: 0.5),

                                  onChanged: (double value) {
                                    controller.musicCurrentPosition.value =
                                        Duration(milliseconds: value.toInt());
                                    controller.player.value.seek(controller
                                        .musicCurrentPosition
                                        .value); // Müziği ilgili süreye atla
                                  },
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "${controller.musicmaxPosition.value.toString().split('.').first.split(':')[1]}:${controller.musicmaxPosition.value.toString().split('.').first.split(':')[2]}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      controller.playBackMusic(force: true);
                    },
                    icon: Icon(
                      Icons.navigate_before_rounded,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      controller.playNextMusic(force: true);
                    },
                    icon: Icon(
                      Icons.navigate_next_rounded,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );

  return PlayerWidgetBundle(
    widget: Rxn(widget),
    play: () async => await controller.playmusic(),
    stop: () async => await controller.player.value.stop(),
    pause: () async => await controller.player.value.pause(),
    resume: () async => await controller.player.value.resume(),
    next: () async => await controller.playNextMusic(force: true),
    back: () async => await controller.playBackMusic(force: true),
    mediaList: (list) async => controller.setMediaList(list),
  );
}
