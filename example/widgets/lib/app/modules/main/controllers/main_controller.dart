import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/services/app_service.dart';

class MainController extends GetxController {
  var apikeyController = TextEditingController().obs;
  var usernameController = TextEditingController().obs;
  var passcordController = TextEditingController().obs;

  var statusController = Rx<bool?>(null);
  var savestaus = false.obs;

  @override
  void onInit() {
    super.onInit();
    AppService.widgets.accountController.changeUser(
      UserAccounts(
        user: User(
          userID: 1,
          displayName: Rx("User Display Name"),
          userName: Rx("User Display Name"),
          avatar: Media(
            mediaID: 0,
            mediaURL: MediaURL(
              bigURL: Rx(
                  "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png"),
              normalURL: Rx(
                  "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png"),
              minURL: Rx(
                  "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png"),
            ),
          ),
        ).obs,
        sessionTOKEN: Rx(""),
        language: Rx(""),
      ),
    );
  }
}
