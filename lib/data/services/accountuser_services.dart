import 'dart:developer';

import 'package:armoyu_widgets/core/armoyu.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:get/get.dart';

class AccountUserController extends GetxController {
  var currentUserAccounts = Rx<UserAccounts>(
    UserAccounts(
      user: User().obs,
      sessionTOKEN: Rx(""),
      language: Rx(""),
    ),
  );
  @override
  void onInit() {
    super.onInit();

    log("-----------------------------Account Controller (ARMOYU WİDGETS)-----------------------------");

    if (ARMOYU.appUsers.isNotEmpty) {
      currentUserAccounts.value = ARMOYU.appUsers.first;
    }
  }

  // Kullanıcıyı değiştir
  void changeUser(UserAccounts userAccounts) {
    currentUserAccounts.value = userAccounts;
  }
}
