import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/chat/chat_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/Chat/chat.dart';
import 'package:armoyu_widgets/data/models/Chat/chat_message.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:get/get.dart';

class SourceNewchatlistController extends GetxController {
  final ARMOYUServices service;
  SourceNewchatlistController(this.service);

  var chatPage = 1.obs;
  var chatsearchprocess = false.obs;
  var chatsearchEndprocess = false.obs;
  var isFirstFetch = true.obs;
  var chatListCache = Rxn<List<Chat>>();
  var filteredchatList = Rxn<List<Chat>>();

  var currentUserAccounts = Rx<UserAccounts>(
    UserAccounts(
      user: User().obs,
      sessionTOKEN: Rx(""),
      language: Rxn(),
    ),
  );

  @override
  void onInit() {
    super.onInit();

    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//
    currentUserAccounts = findCurrentAccountController.currentUserAccounts;

    getnewchat();
  }

  Future<void> refreshAllChatList() async {
    await getnewchat(fetchRestart: true);
  }

  Future<void> loadMoreChatList() async {
    return await getnewchat();
  }

  Future<void> filterList(String text) async {
    if (chatListCache.value == null) {
      return;
    }
    filteredchatList.value = chatListCache.value!.where((element) {
      return element.user.displayName!.value.toLowerCase().contains(text);
    }).toList();
    filteredchatList.refresh();
  }

  Future<void> getnewchat({bool fetchRestart = false}) async {
    if (chatsearchprocess.value || chatsearchEndprocess.value) {
      return;
    }

    if (fetchRestart) {
      chatPage.value = 1;
    }

    chatsearchprocess.value = true;
    ChatNewListResponse response = await service.chatServices.newChatlist(
      page: chatPage.value,
    );
    if (!response.result.status) {
      chatsearchprocess.value = false;
      isFirstFetch.value = false;

      //10 saniye sonra Tekrar çekmeyi dene
      await Future.delayed(const Duration(seconds: 10));
      await getnewchat();
      return;
    }

    chatListCache.value ??= [];

    if (response.response!.isEmpty) {
      chatsearchprocess.value = true;
      isFirstFetch.value = false;
      return;
    }
    for (APIChatList element in response.response!) {
      chatListCache.value!.add(
        Chat(
          user: User(
            userID: element.kullID,
            displayName: Rx(element.adSoyad),
            detailInfo: Rxn(
              UserDetailInfo(
                about: Rxn(),
                age: Rxn(),
                email: Rxn(),
                friends: Rxn(),
                posts: Rxn(),
                awards: Rxn(),
                phoneNumber: Rxn(),
                birthdayDate: Rxn(),
                inviteCode: Rxn(),
                lastloginDate: Rxn(element.sonGiris),
                lastloginDateV2: Rxn(element.sonGiris),
                lastfailedDate: Rxn(),
                country: Rxn(),
                province: Rxn(),
              ),
            ),
            avatar: Media(
              mediaID: 0,
              mediaType: MediaType.image,
              mediaURL: MediaURL(
                bigURL: Rx(element.chatImage.mediaURL.bigURL),
                normalURL: Rx(element.chatImage.mediaURL.normalURL),
                minURL: Rx(element.chatImage.mediaURL.minURL),
              ),
            ),
          ),
          lastmessage: ChatMessage(
            messageID: 0,
            messageContext: "",
            user: User(
              userID: element.kullID,
              displayName: Rx(element.adSoyad),
              detailInfo: Rxn(
                UserDetailInfo(
                  about: Rxn(),
                  age: Rxn(),
                  email: Rxn(),
                  friends: Rxn(),
                  posts: Rxn(),
                  awards: Rxn(),
                  phoneNumber: Rxn(),
                  birthdayDate: Rxn(),
                  inviteCode: Rxn(),
                  lastloginDate: Rxn(element.sonGiris),
                  lastloginDateV2: Rxn(element.sonGiris),
                  lastfailedDate: Rxn(),
                  country: Rxn(),
                  province: Rxn(),
                ),
              ),
            ),
            isMe: false,
          ).obs,
          chatType: element.sohbetTuru,
          chatNotification: false.obs,
        ),
      );
    }
    if (response.response!.length < 30) {
      // 10'dan azsa daha fazla yok demektir
      log("Daha fazla veri yok (newChatList)");

      chatsearchEndprocess.value = true;
    }
    log("ChatList :: Page => $chatPage , Count => ${chatListCache.value!.length}");

    chatsearchprocess.value = false;
    isFirstFetch.value = false;
    chatPage++;

    filteredchatList.value = chatListCache.value;
    chatListCache.refresh();
    filteredchatList.refresh();
  }
}
