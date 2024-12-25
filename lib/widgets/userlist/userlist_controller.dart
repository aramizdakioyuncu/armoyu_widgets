import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/service_result.dart';

import 'package:get/get.dart';

class UserlistController extends GetxController {
  final ARMOYUServices service;
  UserlistController(this.service);
  var buttonbefriend = "Arkadaş Ol".obs;
  var buttonremovefriend = "Çıkar".obs;

  Future<void> friendrequest(int userID) async {
    ServiceResult response =
        await service.profileServices.friendrequest(userID: userID);

    if (!response.status) {
      log(response.description);
      return;
    }

    buttonbefriend.value = "Gönderildi";
  }

  Future<void> removefriend(int userID, bool isFriend) async {
    ServiceResult response =
        await service.profileServices.friendremove(userID: userID);
    if (!response.status) {
      log(response.description);
      return;
    }

    isFriend = false;
    buttonremovefriend.value = "Arkadaş Ol";
  }
}
