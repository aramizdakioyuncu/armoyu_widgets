import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/modules/profile/controllers/profile_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text("asda"),
        ],
      ),
    );
  }
}
