import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/core/armoyu.dart';
import 'package:armoyu_widgets/sources/Story/publish_story_page/controller/storypublish_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StorypublishView extends StatelessWidget {
  final ARMOYUServices service;

  final String imageURL; // Gezdirilecek fotoğrafların listesi
  final int imageID; // Gezdirilecek fotoğrafların ID listesi

  const StorypublishView({
    super.key,
    required this.service,
    required this.imageURL,
    required this.imageID,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      StorypublishController(
        service: service,
        imageURL: imageURL,
        imageID: imageID,
      ),
      tag: imageID.toString(),
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              // Navigator.of(context).pop();
              Get.back();
            },
            icon: const Icon(Icons.close),
          ),
          actions: [
            IconButton(
              onPressed: () {
                controller.addText("Yeni Yazı");
              },
              icon: const Icon(
                Icons.text_fields_rounded,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.tag_faces_outlined,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.music_note_outlined,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.workspaces_outlined,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_horiz_outlined,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {},
                child: Stack(
                  children: [
                    InteractiveViewer(
                      child: Center(
                        child: Hero(
                          tag: 'imageTag',
                          child: CachedNetworkImage(
                            imageUrl: imageURL,
                            height: ARMOYU.screenHeight / 1,
                            width: ARMOYU.screenHeight / 1,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => Stack(
                        children: controller.texts.map((storyText) {
                          return Positioned(
                            left: storyText.position.dx,
                            top: storyText.position.dy,
                            child: GestureDetector(
                              onPanUpdate: (details) {
                                storyText.position = Offset(
                                  storyText.position.dx + details.delta.dx,
                                  storyText.position.dy + details.delta.dy,
                                );
                                controller.texts.refresh();
                              },
                              onTap: () {
                                controller.showEditDialog(
                                    context, controller, storyText);
                              },
                              child: Text(
                                storyText.text,
                                style: TextStyle(
                                  color: storyText.color.value,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  shadows: const [
                                    Shadow(
                                      color: Colors.black,
                                      blurRadius: 4,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onDoubleTap: () {
                            // Çift tıklayınca yakınlaştırmayı sıfırla
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                height: 20,
                color: Colors.blue,
              ),
            ]),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => ElevatedButton(
                            style: controller.isEveryonepublish.value
                                ? const ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll<Color>(
                                            Colors.blue),
                                    foregroundColor:
                                        WidgetStatePropertyAll<Color>(
                                            Colors.white))
                                : null,
                            onPressed: () {
                              controller.isEveryonepublish.value = true;
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  // foregroundImage: CachedNetworkImageProvider(
                                  //   currentUser.avatar!.mediaURL.minURL.value,
                                  // ),
                                  radius: 16,
                                ),
                                SizedBox(width: 10),
                                Text("Herkes"),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Obx(
                          () => ElevatedButton(
                            style: !controller.isEveryonepublish.value
                                ? const ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll<Color>(
                                            Colors.blue),
                                    foregroundColor:
                                        WidgetStatePropertyAll<Color>(
                                            Colors.white),
                                  )
                                : null,
                            onPressed: () {
                              controller.isEveryonepublish.value = false;
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(124),
                                  ),
                                  child: const Icon(Icons.stars_rounded,
                                      color: Colors.green),
                                ),
                                const SizedBox(width: 10),
                                const Text("Arkadaşlar"),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            controller.publishstory(
                                imageURL, controller.isEveryonepublish.value);
                          },
                          icon: const Icon(
                            Icons.send,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
