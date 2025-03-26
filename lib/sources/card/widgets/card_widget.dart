import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/utils/player_pop_list.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/sources/card/controllers/card_controller.dart';
import 'package:armoyu_widgets/widgets/Skeletons/cards_skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum CustomCardType { playerXP, playerPOP }

class CardWidget {
  final ARMOYUServices service;
  const CardWidget(this.service);

  Widget cardWidget({
    required BuildContext context,
    required CustomCardType title,
    required List<APIPlayerPop> content,
    required bool firstFetch,
    required Function({
      required int userID,
      required String username,
      required String? displayname,
      required Media? avatar,
      required Media? banner,
    }) profileFunction,
  }) {
    final controller = Get.put(
      CardsControllerV2(
        service: service,
        content: content,
        firstFetch: firstFetch,
        title: title,
      ),
      tag: DateTime.now().microsecondsSinceEpoch.toString() + title.name,
    );

    return Obx(
      () => controller.xcontent.value == null
          ? SkeletonCustomCards(count: 5, icon: controller.xicon.value!)
          : SizedBox(
              height: 220,
              child: ListView.separated(
                controller: controller.xscrollController.value,
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                scrollDirection: Axis.horizontal,
                itemCount: controller.morefetchProcces.value
                    ? controller.xcontent.value!.length + 1
                    : controller.xcontent.value!.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  if (controller.xcontent.value!.length == index) {
                    return const SizedBox(
                      width: 150,
                      child: CupertinoActivityIndicator(),
                    );
                  }

                  APIPlayerPop cardData = controller.xcontent.value![index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      profileFunction(
                        userID: cardData.oyuncuID,
                        username: cardData.oyuncuKullaniciAdi,
                        displayname: cardData.oyuncuAdSoyad,
                        avatar: Media(
                          mediaID: 0,
                          mediaURL: MediaURL(
                            bigURL: Rx(cardData.oyuncuAvatar),
                            normalURL: Rx(cardData.oyuncuAvatar),
                            minURL: Rx(cardData.oyuncuAvatar),
                          ),
                        ),
                        banner: Media(
                          mediaID: 0,
                          mediaURL: MediaURL(
                            bigURL: Rx(cardData.oyuncuAvatar),
                            normalURL: Rx(cardData.oyuncuAvatar),
                            minURL: Rx(cardData.oyuncuAvatar),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                          image: CachedNetworkImageProvider(
                            cardData.oyuncuAvatar,
                          ),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            colors: [
                              controller.xeffectcolor.value!,
                              Colors.transparent,
                              Colors.black,
                            ],
                            stops: const [0.1, 0.8, 1],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        child: Column(
                          // alignment: Alignment.bottomCenter,
                          children: [
                            const SizedBox(
                              height: 0,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  (index + 1).toString(),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const Expanded(
                              child: SizedBox(),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(7, 0, 7, 7),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      cardData.oyuncuAdSoyad,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        controller.xicon.value!,
                                        const SizedBox(width: 5),
                                        Text(
                                          title == CustomCardType.playerXP
                                              ? cardData.oyuncuSeviyeSezonlukXP
                                                  .toString()
                                              : cardData.oyuncuPop.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 20),
              ),
            ),
    );
  }
}
