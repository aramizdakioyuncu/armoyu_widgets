import 'dart:developer';

import 'package:armoyu_widgets/core/armoyu.dart';
import 'package:armoyu_widgets/core/widgets.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/sources/social/bundle/postcreate_bundle.dart';
import 'package:armoyu_widgets/sources/social/controllers/postcreate_controller.dart';
import 'package:armoyu_widgets/translations/app_translation.dart';
import 'package:armoyu_widgets/widgets/buttons.dart';
import 'package:armoyu_widgets/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

PostcreateWidgetBundle widgetPostcreate(service) {
  final controller = Get.put(PostcreateController(service: service));
  Widget widget = Padding(
    padding: const EdgeInsets.all(8.0),
    child: SingleChildScrollView(
      child: Column(
        children: [
          controller.medialistWidgetBundle.widget.value!,
          SizedBox(
            width: Get.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => controller.userLocation.value == null
                        ? Container()
                        : Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomButtons.costum2(
                                  text: controller.userLocation.value,
                                  icon: const Icon(Icons.location_on),
                                  onPressed: () {},
                                ),
                              ),
                              Positioned(
                                right: 12,
                                top: 12,
                                child: InkWell(
                                  onTap: () {
                                    controller.userLocation.value = null;
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => CustomTextfields(service).mentionTextFiled(
              key: controller.key,
              minLines: 3,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Spacer(),
                IconButton(
                  onPressed: () async {
                    dynamic aa = await controller.determinePosition();
                    log(aa.toString());

                    Position position = await Geolocator.getCurrentPosition(
                      locationSettings: LocationSettings(
                        accuracy: LocationAccuracy.high,
                      ),
                    );

                    await placemarkFromCoordinates(
                            position.latitude, position.longitude)
                        .then((List<Placemark> placemarks) {
                      Placemark place = placemarks[0];
                      controller.userLocation.value =
                          place.subAdministrativeArea.toString();
                      ARMOYUWidget.toastNotification(
                          "${place.street}, ${place.subLocality} ,${place.subAdministrativeArea}, ${place.postalCode}");
                    }).catchError((e) {
                      debugPrint(e);
                    });
                  },
                  icon: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    controller.key.value.currentState!.controller!.text += "@";
                  },
                  icon: const Icon(
                    Icons.person_2,
                    color: Colors.amber,
                  ),
                ),
                const Spacer(),
                if (ARMOYU.cameras != null)
                  IconButton(
                    onPressed: () async {
                      final List<Media> photo =
                          await Get.toNamed("/camera", arguments: {
                        "canPop": true,
                      });

                      for (var element in photo) {
                        log(element.mediaURL.minURL.value);
                      }
                      controller.media += photo;
                    },
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.deepPurple,
                    ),
                  ),
                if (ARMOYU.cameras != null) const Spacer(),
                IconButton(
                  onPressed: () {
                    controller.key.value.currentState!.controller!.text += "#";
                  },
                  icon: const Icon(
                    Icons.numbers_rounded,
                    color: Colors.blue,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          SizedBox(
            height: 100,
            child: Column(
              children: [
                Obx(
                  () => CustomButtons.costum1(
                    text: CommonKeys.share.tr,
                    onPressed: controller.sharePost,
                    loadingStatus: controller.postshareProccess,
                  ),
                ),
                const SizedBox(height: 10),
                Obx(
                  () => Text(controller.postsharetext.value.text),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  return PostcreateWidgetBundle(
    widget: Rxn(widget),
    refresh: () async {
      log("refresh");
    },
  );
}
