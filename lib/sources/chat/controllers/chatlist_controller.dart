import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/chat/chat_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/Chat/chat.dart';
import 'package:armoyu_widgets/data/models/Chat/chat_message.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/data/services/socketio.dart';
import 'package:get/get.dart';

class SourceChatlistController extends GetxController {
  final ARMOYUServices service;

  List<Chat>? cachedChatList;
  Function(List<Chat> updatedChat)? onChatUpdated;

  SourceChatlistController({
    required this.service,
    this.cachedChatList,
    this.onChatUpdated,
  });

  var chatPage = 1.obs;
  var chatsearchprocess = false.obs;
  var chatsearchEndprocess = false.obs;
  var isFirstFetch = true.obs;

  var chatList = Rxn<List<Chat>>();
  var filteredchatList = Rxn<List<Chat>>();

  Future<void> refreshAllChatList() async {
    await getchat(fetchRestart: true);
  }

  Future<void> loadMoreChatList() async {
    return await getchat();
  }

  void updateChatList() {
    chatList.refresh();
    filteredchatList.refresh();
    onChatUpdated?.call(chatList.value!);
  }

  @override
  void onInit() {
    super.onInit();

    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//

    //Bellekteki paylaşımları yükle
    if (cachedChatList != null) {
      chatList.value ??= [];
      chatList.value = cachedChatList;
    }

    getchat(fetchRestart: true);

    final socketController = Get.find<SocketioController>();

    socketController.onChatUpdated = (chat) {
      // Chat güncellemesi burada işlenir
      log("Chat verisi geldi: ${chat.toJson().toString()}");

      bool chatisthere = chatList.value!.any(
        (chatList) => chatList.user.userID == chat.user.userID,
      );

      if (!chatisthere) {
        chatList.value!.add(chat);
      } else {
        Chat currentChat = chatList.value!.firstWhere(
          (chatList) => chatList.user.userID == chat.user.userID,
        );
        currentChat.messages ??= <ChatMessage>[chat.lastmessage!.value].obs;
        currentChat.lastmessage ??= Rx<ChatMessage>(chat.lastmessage!.value);
        currentChat.chatNotification.value = chat.chatNotification.value;
      }
      updateChatList();
    };
  }

  Future<void> filterList(String text) async {
    if (chatList.value == null) {
      return;
    }

    filteredchatList.value = chatList.value!.where((element) {
      return element.user.displayName!.value.toLowerCase().contains(text);
    }).toList();
    log("Filtered List Length: ${filteredchatList.value!.length}");
    filteredchatList.refresh();
  }

  Future<void> getchat({bool fetchRestart = false}) async {
    if (chatsearchprocess.value || chatsearchEndprocess.value) {
      return;
    }

    if (fetchRestart) {
      chatPage.value = 1;
      filteredchatList.value = null;
    }

    chatsearchprocess.value = true;

    ChatListResponse response =
        await service.chatServices.currentChatList(page: chatPage.value);
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

    chatList.value ??= [];

    for (APIChatList element in response.response!) {
      chatList.value!.add(
        Chat(
          chatID: element.kullID, //sonradan chat id olarak değişecek
          user: User(
            userID: element.kullID,
            userName: Rx(element.kullAdi!),
            displayName: Rx(element.adSoyad),
            avatar: Media(
              mediaID: element.kullID,
              mediaType: MediaType.image,
              mediaURL: MediaURL(
                bigURL: Rx(element.chatImage.mediaURL.bigURL),
                normalURL: Rx(element.chatImage.mediaURL.bigURL),
                minURL: Rx(element.chatImage.mediaURL.bigURL),
              ),
            ),
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
                lastloginDate: Rxn(),
                lastloginDateV2: Rxn(element.sonGiris),
                lastfailedDate: Rxn(),
                country: Rxn(),
                province: Rxn(),
              ),
            ),
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
          chatType: element.sohbetTuru,
          calling: false.obs,
        ),
      );
    }

    filteredchatList.value = chatList.value!;
    updateChatList();

    if (response.response!.length < 30) {
      // 10'dan azsa daha fazla yok demektir
      log("Daha fazla veri yok (ChatList)");
      chatsearchEndprocess.value = true;
    }
    log("ChatList :: Page => $chatPage , Count => ${cachedChatList?.length}");

    chatsearchprocess.value = false;
    isFirstFetch.value = false;
    chatPage++;
  }
}
