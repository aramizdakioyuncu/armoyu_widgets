import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu_widgets/widgets/buttons.dart';
import 'package:armoyu_widgets/widgets/text.dart';
import 'package:armoyu_widgets/widgets/userlist/userlist_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserListWidget {
  final ARMOYUServices service;

  final UserAccounts currentUserAccounts;
  final int userID;
  final String profileImageUrl;
  final String username;
  final String displayname;
  bool isFriend;

  UserListWidget({
    required this.currentUserAccounts,
    required this.userID,
    required this.profileImageUrl,
    required this.username,
    required this.displayname,
    required this.isFriend,
    required this.service,
  });

  Widget build(BuildContext context, {required Function profileFunction}) {
    final controller = Get.put(UserlistController(service));
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: GestureDetector(
            onTap: () {
              profileFunction();
            },
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              foregroundImage: CachedNetworkImageProvider(profileImageUrl),
              radius: 30,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Sola hizala
            children: [
              CustomText.costum1(displayname, weight: FontWeight.bold),
              CustomText.costum1(username),
            ],
          ),
        ),
        Visibility(
          visible: isFriend && userID != currentUserAccounts.user.value.userID,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButtons.costum1(
              text: controller.buttonremovefriend.value,
              onPressed: () {
                controller.removefriend(userID, isFriend);
              },
              loadingStatus: false.obs,
            ),
          ),
        ),
        Visibility(
          visible: !isFriend && userID != currentUserAccounts.user.value.userID,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButtons.costum1(
              text: controller.buttonbefriend.value,
              onPressed: () {
                controller.friendrequest(userID);
              },
              loadingStatus: false.obs,
            ),
          ),
        )
      ],
    );
  }
}
