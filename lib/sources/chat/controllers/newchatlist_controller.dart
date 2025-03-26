import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/chat/chat_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/Chat/chat.dart';
import 'package:armoyu_widgets/data/models/Chat/chat_message.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SourceNewchatlistController extends GetxController {
  final ARMOYUServices service;
  final ScrollController scrollController;
  SourceNewchatlistController(this.service, this.scrollController);

  var chatPage = 1.obs;
  var chatsearchprocess = false.obs;
  var isFirstFetch = true.obs;
  // var chatList = Rxn<List<APIChatList>>();
  var chatList = Rxn<List<Chat>>();

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

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent * 0.5) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        getnewchat();
      }
    });

    // if (currentUserAccounts.value.user.value.myFriends != null) {
    //   chatList.value = currentUserAccounts.value.user.value.myFriends
    //       ?.map(
    //         (element) => Chat(
    //           user: User(
    //             userID: element.userID,
    //             displayName: element.displayName,
    //             detailInfo: element.detailInfo == null
    //                 ? Rxn()
    //                 : Rxn(
    //                     UserDetailInfo(
    //                       about: Rxn(),
    //                       age: Rxn(),
    //                       email: Rxn(),
    //                       friends: Rxn(),
    //                       posts: Rxn(),
    //                       awards: Rxn(),
    //                       phoneNumber: Rxn(),
    //                       birthdayDate: Rxn(),
    //                       inviteCode: Rxn(),
    //                       lastloginDate: Rxn(
    //                           element.detailInfo!.value!.lastloginDate.value),
    //                       lastloginDateV2: Rxn(
    //                           element.detailInfo!.value!.lastloginDateV2.value),
    //                       lastfailedDate: Rxn(),
    //                       country: Rxn(),
    //                       province: Rxn(),
    //                     ),
    //                   ),
    //             avatar: element.avatar,
    //           ),
    //           lastmessage: ChatMessage(
    //             messageID: 0,
    //             messageContext: "",
    //             user: User(
    //               userID: element.userID,
    //               displayName: element.displayName,
    //               detailInfo: element.detailInfo == null
    //                   ? Rxn()
    //                   : Rxn(
    //                       UserDetailInfo(
    //                         about: Rxn(),
    //                         age: Rxn(),
    //                         email: Rxn(),
    //                         friends: Rxn(),
    //                         posts: Rxn(),
    //                         awards: Rxn(),
    //                         phoneNumber: Rxn(),
    //                         birthdayDate: Rxn(),
    //                         inviteCode: Rxn(),
    //                         lastloginDate: Rxn(
    //                             element.detailInfo!.value!.lastloginDate.value),
    //                         lastloginDateV2: Rxn(element
    //                             .detailInfo!.value!.lastloginDateV2.value),
    //                         lastfailedDate: Rxn(),
    //                         country: Rxn(),
    //                         province: Rxn(),
    //                       ),
    //                     ),
    //             ),
    //             isMe: false,
    //           ).obs,
    //           chatType: "ozel",
    //           chatNotification: false.obs,
    //         ),
    //       )
    //       .toList();
    // }

    getnewchat();
  }

  Future<void> getnewchat({bool fetchRestart = false}) async {
    if (chatsearchprocess.value) {
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

    chatList.value ??= [];

    if (response.response!.isEmpty) {
      chatsearchprocess.value = true;
      isFirstFetch.value = false;
      return;
    }
    for (APIChatList element in response.response!) {
      chatList.value!.add(
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

    log("ChatList :: Page => $chatPage , Count => ${chatList.value!.length}");

    chatList.refresh();
    chatsearchprocess.value = false;
    isFirstFetch.value = false;
    chatPage++;
  }
}
