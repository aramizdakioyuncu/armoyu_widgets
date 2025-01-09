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

class SourceChatlistController extends GetxController {
  final ARMOYUServices service;
  SourceChatlistController(this.service);

  var chatPage = 1.obs;
  var chatsearchprocess = false.obs;
  var isFirstFetch = true.obs;
  var filteredItems = Rxn<List<Chat>>();

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

    getchat(fetchRestart: true);
  }

  Future<void> getchat({bool fetchRestart = false}) async {
    if (chatsearchprocess.value) {
      return;
    }

    if (fetchRestart) {
      chatPage.value = 1;
      currentUserAccounts.value.chatList = <Chat>[].obs;
      filteredItems.value = null;
    }

    chatsearchprocess.value = true;

    ChatListResponse response =
        await service.utilsServices.getchats(page: chatPage.value);
    if (!response.result.status) {
      chatsearchprocess.value = false;
      isFirstFetch.value = false;

      //10 saniye sonra Tekrar çekmeyi dene
      await Future.delayed(const Duration(seconds: 10));
      await getchat();
      return;
    }

    if (response.response!.isEmpty) {
      chatsearchprocess.value = false;
      isFirstFetch.value = false;
      log("Sohbet Liste Sonu!");
      return;
    }

    currentUserAccounts.value.chatList ??= <Chat>[].obs;

    for (APIChatList element in response.response!) {
      currentUserAccounts.value.chatList!.add(
        Chat(
          chatID: element.kullID, //sonradan chat id olarak değişecek
          user: User(
            userID: element.kullID,
            userName: Rx(element.kullAdi!),
            displayName: Rx(element.adSoyad),
            avatar: Media(
              mediaID: element.kullID,
              mediaURL: MediaURL(
                bigURL: Rx(element.chatImage.mediaURL.bigURL),
                normalURL: Rx(element.chatImage.mediaURL.bigURL),
                minURL: Rx(element.chatImage.mediaURL.bigURL),
              ),
            ),
            lastloginv2: Rx(element.sonGiris),
          ),
          chatNotification: element.bildirim == 1 ? true.obs : false.obs,
          lastmessage: Rx(
            ChatMessage(
              messageID: 0,
              messageContext: element.sonMesaj,
              user: User(),
              isMe: true,
            ),
          ),
          chatType: "ozel",
          calling: false.obs,
        ),
      );
    }

    filteredItems.value = currentUserAccounts.value.chatList;

    currentUserAccounts.refresh();
    filteredItems.refresh();

    chatsearchprocess.value = false;
    isFirstFetch.value = false;
    chatPage++;
  }
}
