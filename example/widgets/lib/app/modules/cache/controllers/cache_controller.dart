import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/Social/post.dart';
import 'package:armoyu_widgets/data/models/Story/story.dart';
import 'package:armoyu_widgets/data/models/Story/storylist.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/widgets/notification_bars/notification_bars_view.dart';
import 'package:get/get.dart';
import 'package:widgets/app/services/app_service.dart';

class CacheController extends GetxController {
  var postsProcccess = false.obs;
  var storyiesProcccess = false.obs;
  var notificationsProcccess = false.obs;

  Future<void> fillPosts() async {
    if (postsProcccess.value) {
      return;
    }

    postsProcccess.value = true;

    if (AppService
            .widgets.accountController.currentUserAccounts.value.widgetPosts !=
        null) {
      AppService.widgets.accountController.currentUserAccounts.value
          .widgetPosts = null;
      postsProcccess.value = false;
      return;
    }

    PostFetchListResponse response =
        await AppService.service.postsServices.getPosts(page: 1);

    if (!response.result.status) {
      postsProcccess.value = false;
      return;
    }

    AppService
        .widgets.accountController.currentUserAccounts.value.widgetPosts ??= [];
    AppService.widgets.accountController.currentUserAccounts.value.widgetPosts!
        .addAll(
      response.response!.map(
        (post) => Post(
          postID: post.postID,
          content: post.content,
          postDate: post.date,
          postDateCountdown: post.datecounting,
          sharedDevice: post.postdevice,
          likesCount: post.likeCount,
          isLikeme: post.didilikeit == 1 ? true : false,
          commentsCount: post.commentCount,
          iscommentMe: post.didicommentit == 1 ? true : false,
          owner: User(
            userID: post.postOwner.ownerID,
            userName: post.postOwner.username.obs,
            displayName: post.postOwner.displayName.obs,
            avatar: Media(
              mediaID: 0,
              mediaType: MediaType.image,
              mediaURL: MediaURL(
                bigURL: post.postOwner.avatar.bigURL.obs,
                normalURL: post.postOwner.avatar.normalURL.obs,
                minURL: post.postOwner.avatar.minURL.obs,
              ),
            ),
          ),
          media: post.media!
              .map(
                (media) => Media(
                  mediaID: media.mediaID,
                  mediaType: media.mediaType == "video"
                      ? MediaType.video
                      : MediaType.image,
                  mediaURL: MediaURL(
                    bigURL: media.mediaURL.bigURL.obs,
                    normalURL: media.mediaURL.normalURL.obs,
                    minURL: media.mediaURL.minURL.obs,
                  ),
                ),
              )
              .toList(),
          firstthreecomment: [],
          firstthreelike: [],
          location: post.location,
        ),
      ),
    );
    postsProcccess.value = false;
  }

  Future<void> fillStory() async {
    if (storyiesProcccess.value) {
      return;
    }

    storyiesProcccess.value = true;

    if (AppService.widgets.accountController.currentUserAccounts.value
            .widgetStoriescard !=
        null) {
      AppService.widgets.accountController.currentUserAccounts.value
          .widgetStoriescard = null;
      storyiesProcccess.value = false;
      return;
    }

    StoryFetchListResponse response =
        await AppService.service.storyServices.stories(page: 1);

    if (!response.result.status) {
      storyiesProcccess.value = false;
      return;
    }

    AppService.widgets.accountController.currentUserAccounts.value
        .widgetStoriescard ??= [];

    AppService
        .widgets.accountController.currentUserAccounts.value.widgetStoriescard!
        .addAll(
      response.response!.map(
        (story) => StoryList(
          owner: User(
            userID: story.oyuncuId,
            userName: story.oyuncuKadi.obs,
            displayName: story.oyuncuAdSoyad.obs,
            avatar: Media(
              mediaID: 0,
              mediaType: MediaType.image,
              mediaURL: MediaURL(
                bigURL: story.oyuncuAvatar.bigURL.obs,
                normalURL: story.oyuncuAvatar.normalURL.obs,
                minURL: story.oyuncuAvatar.minURL.obs,
              ),
            ),
          ),
          story: story.hikayeIcerik
              .map(
                (storycontent) => Story(
                  storyID: storycontent.hikayeId,
                  ownerID: storycontent.hikayeSahip,
                  ownerusername: story.oyuncuKadi,
                  owneravatar: story.oyuncuAvatar.minURL,
                  time: storycontent.hikayeZaman,
                  media: storycontent.hikayeMedya,
                  isLike: storycontent.hikayeBenBegeni,
                  isView: storycontent.hikayeBenGoruntulenme,
                ),
              )
              .toList(),
          isView: story.hikayeIcerik.firstWhereOrNull(
                  (element) => element.hikayeBenGoruntulenme == 0) ==
              null,
        ),
      ),
    );
    storyiesProcccess.value = false;
  }

  Future<void> fillNotifications() async {
    if (notificationsProcccess.value) {
      return;
    }

    notificationsProcccess.value = true;

    if (AppService.widgets.accountController.currentUserAccounts.value
            .notificationList !=
        null) {
      AppService.widgets.accountController.currentUserAccounts.value
          .notificationList = null;
      notificationsProcccess.value = false;
      return;
    }

    NotificationListResponse response = await AppService
        .service.notificationServices
        .getnotifications(kategori: "", kategoridetay: "", page: 1);

    if (!response.result.status) {
      notificationsProcccess.value = false;
      return;
    }

    AppService.widgets.accountController.currentUserAccounts.value
        .notificationList ??= [];

    AppService
        .widgets.accountController.currentUserAccounts.value.notificationList!
        .addAll(
      response.response!.map(
        (notifications) {
          bool notificationButtons = false;

          if (notifications.bildirimAmac.toString() == "arkadaslik") {
            if (notifications.bildirimKategori.toString() == "istek") {
              notificationButtons = true;
            }
          } else if (notifications.bildirimAmac.toString() == "gruplar") {
            if (notifications.bildirimKategori.toString() == "davet") {
              notificationButtons = true;
            }
          }

          return Notifications(
            user: User(
              userID: notifications.bildirimGonderenID,
              displayName: Rx<String>(notifications.bildirimGonderenAdSoyad),
              userName: Rx<String>(
                  notifications.bildirimGonderenLink.split("/").last),
              avatar: Media(
                mediaID: notifications.bildirimGonderenID,
                mediaType: MediaType.image,
                mediaURL: MediaURL(
                  bigURL: Rx<String>(notifications.bildirimGonderenAvatar),
                  normalURL: Rx<String>(notifications.bildirimGonderenAvatar),
                  minURL: Rx<String>(notifications.bildirimGonderenAvatar),
                ),
              ),
            ),
            category: notifications.bildirimAmac,
            categorydetail: notifications.bildirimKategori,
            categorydetailID: notifications.bildirimKategoriDetay,
            date: notifications.bildirimZaman,
            enableButtons: notificationButtons,
            text: notifications.bildirimIcerik,
          );
        },
      ),
    );
    notificationsProcccess.value = false;
  }
}
