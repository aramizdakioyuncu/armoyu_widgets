import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/core/widgets.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/news.dart';
import 'package:get/get.dart';

class NewsController extends GetxController {
  final ARMOYUServices service;

  List<News>? cachedNewsList;
  Function(List<News> updatedNotifications)? onNewsUpdated;
  NewsController({
    required this.service,
    this.cachedNewsList,
    this.onNewsUpdated,
  });

  Rxn<List<News>> newsList = Rxn();
  Rxn<List<News>> filterednewsList = Rxn();

  var eventlistProcces = false.obs;
  var newsEndProcces = false.obs;
  var newsPage = 1.obs;

  Future<void> refreshAllNews() async {
    log("Refresh All Notifications");
    await getnewslist(refresh: true);
  }

  Future<void> loadMoreNews() async {
    log("load More Notifications");
    return await getnewslist();
  }

  void updateNewsList() {
    filterednewsList.value = newsList.value;
    newsList.refresh();
    filterednewsList.refresh();
    onNewsUpdated?.call(newsList.value!);
  }

  @override
  void onInit() {
    super.onInit();

    //Bellekteki paylaşımları yükle
    if (cachedNewsList != null) {
      newsList.value ??= [];
      newsList.value = cachedNewsList;
      filterednewsList.value = cachedNewsList;
    }

    getnewslist();
  }

  Future<void> getnewslist({bool refresh = false}) async {
    if (eventlistProcces.value || newsEndProcces.value) {
      return;
    }
    eventlistProcces.value = true;

    NewsListResponse response =
        await service.newsServices.fetch(page: newsPage.value);
    if (!response.result.status) {
      ARMOYUWidget.toastNotification(response.result.description.toString());
      eventlistProcces.value = false;
      //10 saniye sonra Tekrar çekmeyi dene
      await Future.delayed(const Duration(seconds: 10));
      getnewslist();
      return;
    }
    if (refresh) {
      newsList.value = [];
    }
    newsList.value ??= [];
    for (var element in response.response!.news) {
      if (newsList.value!.any((e) => e.newsID == element.newsID)) {
        continue;
      }
      newsList.value!.add(
        News(
          newsID: element.newsID,
          newsTitle: element.title,
          author: element.newsOwner.displayname,
          newsImage: element.media.mediaURL.minURL,
          newssummary: element.summary,
          authoravatar: element.newsOwner.avatar.minURL,
          newsViews: element.views,
        ),
      );
    }

    if (response.response!.news.length < 10) {
      newsEndProcces.value = true;
    }

    updateNewsList();
    newsPage.value++;
    eventlistProcces.value = false;
  }
}
