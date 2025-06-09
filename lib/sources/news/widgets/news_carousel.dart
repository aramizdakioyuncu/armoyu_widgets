import 'package:armoyu_widgets/data/models/ARMOYU/news.dart';
import 'package:armoyu_widgets/sources/news/bundle/news_bundle.dart';
import 'package:armoyu_widgets/sources/news/controllers/news_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

NewsWidgetBundle widgetNewsCarousel(
  service, {
  required Function(News news) newsFunction,
  List<News>? cachedNewsList,
  Function(List<News> updatedNotifications)? onNewsUpdated,
}) {
  final controller = Get.put(
    NewsController(
      service: service,
      cachedNewsList: cachedNewsList,
      onNewsUpdated: onNewsUpdated,
    ),
    tag: DateTime.now().microsecondsSinceEpoch.toString(),
  );
  Widget widget = Obx(
    () => controller.filterednewsList.value == null
        ? const CupertinoActivityIndicator()
        : CarouselSlider.builder(
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
            itemCount: controller.filterednewsList.value!.length,
            itemBuilder: (context, index, realIndex) {
              return controller.filterednewsList.value!.isNotEmpty
                  ? InkWell(
                      onTap: () {
                        newsFunction(controller.filterednewsList.value![index]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                            image: CachedNetworkImageProvider(
                              controller
                                  .filterednewsList.value![index].newsImage,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                          controller.filterednewsList
                                              .value![index].authoravatar,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        controller.filterednewsList
                                            .value![index].author,
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
                                            controller.filterednewsList
                                                .value![index].newsViews
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
                                    controller.filterednewsList.value![index]
                                        .newssummary,
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
                      width: MediaQuery.of(context).size.width,
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
  return NewsWidgetBundle(
    widget: Rxn(widget),
    refresh: () async => await controller.refreshAllNews(),
    loadMore: () async => await controller.loadMoreNews(),
  );
}
