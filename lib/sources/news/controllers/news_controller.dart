import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/core/widgets.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/news.dart';
import 'package:get/get.dart';

class NewsController extends GetxController {
  final ARMOYUServices service;
  NewsController(this.service);
  var newsList = <News>[].obs;
  var postsearchprocess = false.obs;

  var eventlistProcces = false.obs;
  @override
  void onInit() {
    super.onInit();
    getnewslist();
  }

  Future<void> getnewslist() async {
    if (eventlistProcces.value) {
      return;
    }
    eventlistProcces.value = true;

    NewsListResponse response = await service.newsServices.fetch(page: 1);
    if (!response.result.status) {
      ARMOYUWidget.toastNotification(response.result.description.toString());
      eventlistProcces.value = false;
      //10 saniye sonra Tekrar çekmeyi dene
      await Future.delayed(const Duration(seconds: 10));
      getnewslist();
      return;
    }

    newsList.clear();

    for (var element in response.response!.news) {
      newsList.add(
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
    eventlistProcces.value = false;
  }
}
