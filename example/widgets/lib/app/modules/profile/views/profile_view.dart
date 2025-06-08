import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/modules/profile/controllers/profile_controller.dart';
import 'package:widgets/app/services/app_service.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text("Profile Page"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppService.widgets.elevatedButton.costum1(
              enabled: true,
              text: "Profile Settings",
              onPressed: () {
                AppService.widgets.profile.popupProfileSettings(
                  context,
                );
              },
              loadingStatus: false,
            ),
          ),
        ],
      ),
    );
  }
}
