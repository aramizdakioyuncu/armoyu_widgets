import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/modules/reels/controllers/reels_controller.dart';

class ReelsView extends StatelessWidget {
  const ReelsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ARMOYUReelsController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Reels"),
        actions: [
          IconButton(onPressed: controller.back, icon: Icon(Icons.arrow_back)),
          IconButton(
              onPressed: controller.next, icon: Icon(Icons.arrow_forward)),
        ],
      ),
      body: controller.reelswidget.widget.value,
    );
  }
}
