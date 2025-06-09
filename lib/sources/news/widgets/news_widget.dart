import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/news.dart';
import 'package:armoyu_widgets/sources/news/bundle/news_bundle.dart';
import 'package:armoyu_widgets/sources/news/widgets/news_carousel.dart';

class NewsWidget {
  final ARMOYUServices service;
  const NewsWidget(this.service);

  NewsWidgetBundle newsCarouselWidget({
    required Function(News news) newsFunction,
    List<News>? cachedNewsList,
    Function(List<News> updatedNotifications)? onNewsUpdated,
  }) {
    return widgetNewsCarousel(
      service,
      newsFunction: newsFunction,
      cachedNewsList: cachedNewsList,
      onNewsUpdated: onNewsUpdated,
    );
  }
}
