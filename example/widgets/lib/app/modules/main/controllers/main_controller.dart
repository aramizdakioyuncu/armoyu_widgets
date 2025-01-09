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
          userID: 11107,
          displayName: Rx("Test Kullanıcısı"),
          userName: Rx("deneme"),
          avatar: Media(
            mediaID: 0,
            mediaURL: MediaURL(
              bigURL:
                  Rx("https://aramizdakioyuncu.com/galeri/ana-yapi/armoyu.png"),
              normalURL:
                  Rx("https://aramizdakioyuncu.com/galeri/ana-yapi/armoyu.png"),
              minURL:
                  Rx("https://aramizdakioyuncu.com/galeri/ana-yapi/armoyu.png"),
            ),
          ),
        ).obs,
        sessionTOKEN: Rx(
            "5221d07eb0049191ed17b3d1ea773941aa3ab1960c9696c64de2281766d13df2"),
        language: Rxn(),
      ),
    );
  }
}
