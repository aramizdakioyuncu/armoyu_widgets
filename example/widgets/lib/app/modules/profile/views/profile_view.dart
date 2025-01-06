import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/modules/profile/controllers/profile_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Socail'),
        forceMaterialTransparency: true,
      ),
      body: Column(
        children: [
          TabBar(
            controller: controller.tabController.value,
            labelPadding: const EdgeInsets.all(10),
            tabs: const [
              Text("Paylaşımlar"),
              Text("Galeri"),
              Text("Etiketlenmiş"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController.value,
              children: [
                controller.widget1.value!,
                controller.widget2.value!,
                controller.widget3.value!,
              ],
            ),
          )
        ],
      ),
    );
  }
}
