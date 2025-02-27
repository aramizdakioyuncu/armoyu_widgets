import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/core/armoyu.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/news.dart';
import 'package:armoyu_widgets/sources/news/controllers/news_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewsWidget {
  final ARMOYUServices service;
  const NewsWidget(this.service);

  Widget newsCarouselWidget({required Function(News news) newsFunction}) {
    final controller = Get.put(
      NewsController(service),
      tag: DateTime.now().microsecondsSinceEpoch.toString(),
    );
    return Obx(
      () => CarouselSlider.builder(
        options: CarouselOptions(
          aspectRatio: 16 / 9,
          autoPlay: true,
          enableInfiniteScroll: true,
          pauseAutoPlayOnTouch: true,
          viewportFraction: 0.8,
          autoPlayInterval: const Duration(seconds: 5),
          scrollDirection: Axis.horizontal,
          enlargeFactor: 0.2,
          enlargeCenterPage: true,
        ),
        itemCount: controller.newsList.length,
        itemBuilder: (context, index, realIndex) {
          return controller.newsList.isNotEmpty
              ? InkWell(
                  onTap: () {
                    newsFunction(controller.newsList[index]);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        image: CachedNetworkImageProvider(
                          controller.newsList[index].newsImage,
                        ),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.7),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.8],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(7, 0, 7, 7),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                      controller.newsList[index].authoravatar,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    controller.newsList[index].author,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.visibility),
                                      const SizedBox(width: 3),
                                      Text(
                                        controller.newsList[index].newsViews
                                            .toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                controller.newsList[index].newssummary,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(
                  width: ARMOYU.screenWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    // color: ARMOYU.appbarColor,
                  ),
                  child: const Center(
                    child: CupertinoActivityIndicator(),
                  ),
                );
        },
      ),
    );
  }
}
