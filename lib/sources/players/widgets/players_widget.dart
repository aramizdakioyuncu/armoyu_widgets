import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/sources/players/bundle/musiclist_bundle.dart';
import 'package:armoyu_widgets/sources/players/bundle/musicplayer_bundle.dart';
import 'package:armoyu_widgets/sources/players/controllers/musicplayer_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlayersWidget {
  final ARMOYUServices service;

  const PlayersWidget(this.service);

  PlayerWidgetBundle advencedPlayer(
    BuildContext context, {
    Color sliderColor = Colors.white,
    Color buttonColor = Colors.white,
    List<Color> bgColors = const [
      Color.fromARGB(255, 0, 119, 255),
      Color.fromARGB(255, 3, 152, 238),
      Color.fromARGB(255, 0, 132, 255),
      Color.fromARGB(255, 7, 62, 158),
    ],
  }) {
    final controller = Get.put(MusicplayerController(service));

    Widget widget = Obx(
      () => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ...bgColors,
              Colors.black,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(child: Text("Müzik Çalar")),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.more_horiz_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.black,
                    ),
                    child: controller.musicIndex.value == null
                        ? Image.asset(
                            "assets/images/medinotfound.jpg",
                            package: 'armoyu_widgets',
                          )
                        : controller.filteredmusicList
                                    .value![controller.musicIndex.value!].img ==
                                null
                            ? Image.asset(
                                "assets/images/medinotfound.jpg",
                                package: 'armoyu_widgets',
                              )
                            : CachedNetworkImage(
                                fit: BoxFit.contain,
                                imageUrl: controller.filteredmusicList
                                    .value![controller.musicIndex.value!].img!,
                              ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => Text(
                                controller.musicIndex.value == null
                                    ? ""
                                    : controller
                                        .filteredmusicList
                                        .value![controller.musicIndex.value!]
                                        .name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Obx(
                              () => Text(
                                controller.musicIndex.value == null
                                    ? ""
                                    : controller
                                            .filteredmusicList
                                            .value![
                                                controller.musicIndex.value!]
                                            .owner ??
                                        "",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (controller.filteredmusicList
                              .value![controller.musicIndex.value!].ismyfav) {
                            service.musicServices.removefavorite(
                              musicID: controller.filteredmusicList
                                  .value![controller.musicIndex.value!].musicID,
                            );

                            controller
                                .filteredmusicList
                                .value![controller.musicIndex.value!]
                                .ismyfav = false;
                          } else {
                            service.musicServices.addfavorite(
                              musicID: controller.filteredmusicList
                                  .value![controller.musicIndex.value!].musicID,
                            );

                            controller
                                .filteredmusicList
                                .value![controller.musicIndex.value!]
                                .ismyfav = true;
                          }

                          controller.filteredmusicList.refresh();
                        },
                        icon: Icon(
                          controller.musicIndex.value == null
                              ? Icons.favorite_border
                              : controller
                                      .filteredmusicList
                                      .value![controller.musicIndex.value!]
                                      .ismyfav
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                          color: controller.musicIndex.value == null
                              ? Colors.grey
                              : controller
                                      .filteredmusicList
                                      .value![controller.musicIndex.value!]
                                      .ismyfav
                                  ? Colors.red
                                  : Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Obx(
                () => SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    trackHeight: 2.0, // Kalınlığı azalt
                    thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 6.0), // Nokta küçült
                    overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 12.0), // Tıklama efekti
                  ),
                  child: Slider(
                    min: 0,
                    max: controller.musicmaxPosition.value.inMilliseconds
                        .toDouble(), // Maksimum süre
                    value: controller.musicCurrentPosition.value.inMilliseconds
                        .toDouble()
                        .clamp(
                          0.0,
                          controller.musicmaxPosition.value.inMilliseconds
                              .toDouble(),
                        ), // Geçerli süre
                    activeColor: sliderColor,
                    inactiveColor: sliderColor.withValues(alpha: 0.5),

                    onChanged: (double value) {
                      controller.musicCurrentPosition.value =
                          Duration(milliseconds: value.toInt());
                      controller.player.value.seek(
                        controller.musicCurrentPosition.value,
                      ); // Müziği ilgili süreye atla
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Text(
                      "${controller.musicCurrentPosition.value.toString().split('.').first.split(':')[1]}:${controller.musicCurrentPosition.value.toString().split('.').first.split(':')[2]}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "${controller.musicmaxPosition.value.toString().split('.').first.split(':')[1]}:${controller.musicmaxPosition.value.toString().split('.').first.split(':')[2]}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () {
                        controller.shuffleplayer();
                      },
                      icon: Icon(
                        Icons.shuffle_rounded,
                        color: sliderColor.withValues(),
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () {
                        controller.playBackMusic(force: true);
                      },
                      icon: Icon(
                        Icons.navigate_before_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      padding: EdgeInsets.all(0),
                      icon: AnimatedIcon(
                        icon: AnimatedIcons.play_pause,
                        progress: controller.musicController,
                        color: Colors.black,
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () {
                        controller.playNextMusic(force: true);
                      },
                      icon: Icon(
                        Icons.navigate_next_rounded,
                        color: buttonColor,
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () {
                        controller.repeatplayer.value =
                            !controller.repeatplayer.value;
                      },
                      icon: Obx(
                        () => Icon(
                          Icons.repeat,
                          color: controller.repeatplayer.value
                              ? buttonColor
                              : buttonColor.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: UnderlineInputBorder(),
                        builder: (context) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: DefaultTabController(
                              length: 2,
                              child: Column(
                                children: [
                                  const TabBar(
                                    tabs: [
                                      Tab(text: "Tüm Müzikler"),
                                      Tab(text: "Favori Müzikler"),
                                    ],
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      children: [
                                        advencedPlayerlist(
                                          context,
                                        ).widget.value!,
                                        advencedPlayerlist(
                                          context,
                                        ).widget.value!,
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.list),
                  ),
                ],
              ),
            ],
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

  MusiclistWidgetBundle advencedPlayerlist(
    BuildContext context, {
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
                              image: controller.filteredmusicList.value![index]
                                          .img ==
                                      null
                                  ? AssetImage(
                                      "assets/images/medinotfound.jpg",
                                      package: 'armoyu_widgets',
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
                          controller.filteredmusicList.value![index].owner ??
                              "",
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

  PlayerWidgetBundle musicplayer() {
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
                              "assets/images/medinotfound.jpg",
                              package: 'armoyu_widgets',
                            )
                          : controller
                                      .filteredmusicList
                                      .value![controller.musicIndex.value!]
                                      .img ==
                                  null
                              ? AssetImage(
                                  "assets/images/medinotfound.jpg",
                                  package: 'armoyu_widgets',
                                )
                              : CachedNetworkImageProvider(
                                  controller
                                      .filteredmusicList
                                      .value![controller.musicIndex.value!]
                                      .img!,
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
                                    value: controller.musicCurrentPosition.value
                                        .inMilliseconds
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
}
