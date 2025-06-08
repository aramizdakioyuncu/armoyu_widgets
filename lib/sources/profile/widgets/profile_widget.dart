import 'dart:async';

import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/service_result.dart';
import 'package:armoyu_widgets/core/armoyu.dart';
import 'package:armoyu_widgets/core/widgets.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/country.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/province.dart';
import 'package:armoyu_widgets/data/models/select.dart';
import 'package:armoyu_widgets/sources/profile/controllers/profile_settings_controller.dart';
import 'package:armoyu_widgets/translations/app_translation.dart';
import 'package:armoyu_widgets/widgets/buttons.dart';
import 'package:armoyu_widgets/widgets/text.dart';
import 'package:armoyu_widgets/widgets/textfields.dart';
import 'package:armoyu_widgets/widgets/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileWidget {
  final ARMOYUServices service;

  const ProfileWidget(this.service);

  void popupProfileSettings(BuildContext context) {
    final controller = Get.put(ProfileSettingsController(service: service));

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.87,
          child: Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 100,
                                child: CustomText.costum1(
                                  ProfileKeys.profilefirstname.tr,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: CustomTextfields(service).costum3(
                                  placeholder: controller
                                      .currentUser!.displayName!.value,
                                  controller: controller.firstName,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 100,
                                child: CustomText.costum1(
                                  ProfileKeys.profilelastname.tr,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: CustomTextfields(service).costum3(
                                  placeholder: controller
                                      .currentUser!.displayName!.value,
                                  controller: controller.lastName,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 100,
                                child: CustomText.costum1(
                                  ProfileKeys.profileaboutme.tr,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: CustomTextfields(service).costum3(
                                  placeholder: controller.currentUser!
                                      .detailInfo!.value!.about.value,
                                  controller: controller.aboutme,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: SizedBox(
                                  width: 100,
                                  child: CustomText.costum1(
                                    ProfileKeys.profileemail.tr,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: CustomTextfields(service).costum3(
                                  placeholder: controller.currentUser!
                                      .detailInfo!.value!.email.value,
                                  controller: controller.email,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 100,
                                child: CustomText.costum1(
                                  ProfileKeys.profilelocation.tr,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Obx(
                                        () => CustomButtons.costum1(
                                          text: controller.country.value,
                                          onPressed: () {
                                            WidgetUtility.cupertinoselector(
                                              context: context,
                                              title: ProfileKeys
                                                  .profileselectcountry.tr,
                                              onChanged: (selectedIndex,
                                                  selectedValue) {
                                                if (selectedIndex == -1) {
                                                  return;
                                                }
                                                controller.provinceSelectStatus
                                                    .value = false;
                                                controller.province.value =
                                                    ProfileKeys
                                                        .profileselectcity.tr;
                                                controller.country.value =
                                                    selectedValue;
                                                controller.countryIndex =
                                                    selectedIndex;

                                                int countryID = ARMOYU
                                                    .countryList[selectedIndex]
                                                    .countryID;

                                                controller.searchTimer
                                                    ?.cancel();
                                                controller.searchTimer = Timer(
                                                    const Duration(
                                                        milliseconds: 1000),
                                                    () async {
                                                  await controller
                                                      .fetchProvince(countryID,
                                                          selectedIndex);
                                                });
                                              },
                                              selectionList: Selection(
                                                list: ARMOYU.countryList
                                                    .map((country) {
                                                  return Select(
                                                    selectID: country.countryID,
                                                    title: country.name,
                                                    value: country.name,
                                                    selectionList: null,
                                                  );
                                                }).toList(),
                                              ).obs,
                                            );
                                          },
                                          loadingStatus: false.obs,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Obx(
                                        () => CustomButtons.costum1(
                                          text: controller.province.value,
                                          enabled: controller
                                              .provinceSelectStatus.value,
                                          onPressed: () {
                                            WidgetUtility.cupertinoselector(
                                              context: context,
                                              title: ProfileKeys
                                                  .profileselectcity.tr,
                                              onChanged: (selectedIndex,
                                                  selectedValue) {
                                                controller.provinceIndex =
                                                    selectedIndex;
                                                controller.province.value =
                                                    selectedValue;
                                              },

                                              selectionList: Selection(
                                                selectedIndex: Rxn(0),
                                                list: ARMOYU
                                                    .countryList[controller
                                                        .countryIndex!]
                                                    .provinceList!
                                                    .map((country) {
                                                  return Select(
                                                    selectID:
                                                        country.provinceID,
                                                    title: country.name,
                                                    value: country.name,
                                                    selectionList: null,
                                                  );
                                                }).toList(),
                                              ).obs,
                                              // list: ARMOYU
                                              //     .countryList[countryIndex!]
                                              //     .provinceList!
                                              //     .map((item) {
                                              //   return {
                                              //     item.provinceID:
                                              //         item.name.toString(),
                                              //   };
                                              // }).toList(),
                                            );
                                          },
                                          loadingStatus: false.obs,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 100,
                                child: CustomText.costum1(
                                  ProfileKeys.profilebirthdate.tr,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Obx(
                                  () => CustomButtons.costum1(
                                    text: controller.birthday.value.text,
                                    onPressed: () {
                                      WidgetUtility.cupertinoDatePicker(
                                        context: context,
                                        onChanged: (selectedValue) {
                                          controller.birthday.value.text =
                                              selectedValue;
                                        },
                                      );
                                    },
                                    loadingStatus: false.obs,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 100,
                                child: CustomText.costum1(
                                  ProfileKeys.profilephonenumber.tr,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: CustomTextfields(service).number(
                                  placeholder: "(XXX) XXX XX XX",
                                  controller: controller.phoneNumber.value,
                                  icon: const Icon(Icons.phone),
                                  category: "phoneNumber",
                                  length: 10,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 100,
                                child: CustomText.costum1(
                                  ProfileKeys.profilecheckpassword.tr,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: CustomTextfields(service).costum3(
                                    controller: controller.passwordControl,
                                    isPassword: true,
                                    focusNode: controller.myFocusPassword),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Obx(
                            () => CustomButtons.costum1(
                              text: CommonKeys.update.tr,
                              onPressed: () async {
                                if (controller.passwordControl.value.text ==
                                    "") {
                                  ARMOYUWidget.toastNotification(
                                      "Parola doğrulamasını yapınız!");

                                  controller.myFocusPassword.requestFocus();
                                  return;
                                }

                                String cleanedphoneNumber = controller
                                    .phoneNumber.value.text
                                    .replaceAll(RegExp(r'[()\s]'), '');

                                List<String> words =
                                    controller.birthday.value.text.split(".");
                                if (words.isEmpty) {
                                  return;
                                }
                                String newDate =
                                    "${words[2]}-${words[1]}-${words[0]}";

                                String countryID = "";
                                countryID = ARMOYU
                                    .countryList[controller.countryIndex!]
                                    .countryID
                                    .toString();

                                String provinceID = "";
                                if (ARMOYU.countryList[controller.countryIndex!]
                                        .provinceList !=
                                    null) {
                                  provinceID = ARMOYU
                                      .countryList[controller.countryIndex!]
                                      .provinceList![controller.provinceIndex!]
                                      .provinceID
                                      .toString();
                                }

                                log(controller.firstName.value.text);
                                log(controller.lastName.value.text);

                                log(controller.aboutme.value.text);

                                log(controller.email.value.text);
                                log(countryID.toString());
                                log(provinceID.toString());
                                log(newDate);
                                log(cleanedphoneNumber);
                                log(controller.passwordControl.value.text);

                                if (controller.profileeditProcess.value) {
                                  return;
                                }
                                controller.profileeditProcess.value = true;
                                // setstatefunction();

                                ServiceResult response = await service
                                    .profileServices
                                    .saveprofiledetails(
                                  firstname: controller.firstName.value.text,
                                  lastname: controller.lastName.value.text,
                                  aboutme: controller.aboutme.value.text,
                                  email: controller.email.value.text,
                                  countryID: countryID.toString(),
                                  provinceID: provinceID.toString(),
                                  birthday: newDate,
                                  phoneNumber: cleanedphoneNumber,
                                  passwordControl:
                                      controller.passwordControl.value.text,
                                );

                                controller.profileeditProcess.value = false;
                                // setstatefunction();
                                if (!response.status) {
                                  log(response.description);
                                  ARMOYUWidget.toastNotification(
                                    response.description,
                                  );
                                  return;
                                }
                                controller.currentUser!.firstName!.value =
                                    controller.firstName.value.text;
                                controller.currentUser!.lastName!.value =
                                    controller.lastName.value.text;
                                controller.currentUser!.displayName!.value =
                                    "${controller.firstName.value.text} ${controller.lastName.value.text}";

                                controller.currentUser!.detailInfo!.value!.about
                                    .value = controller.aboutme.value.text;
                                controller.currentUser!.detailInfo!.value!.email
                                    .value = controller.email.value.text;
                                controller.currentUser!.detailInfo!.value!
                                    .country.value = Country(
                                  countryID: int.parse(countryID),
                                  name: ARMOYU
                                      .countryList[controller.countryIndex!]
                                      .name,
                                  countryCode: ARMOYU
                                      .countryList[controller.countryIndex!]
                                      .countryCode,
                                  phoneCode: ARMOYU
                                      .countryList[controller.countryIndex!]
                                      .phoneCode,
                                );
                                controller.currentUser!
                                        .detailInfo!.value!.province.value =
                                    provinceID == ""
                                        ? null
                                        : Province(
                                            provinceID: int.parse(provinceID),
                                            name: ARMOYU
                                                .countryList[
                                                    controller.countryIndex!]
                                                .provinceList![
                                                    controller.provinceIndex!]
                                                .name,
                                            plateCode: ARMOYU
                                                .countryList[
                                                    controller.countryIndex!]
                                                .provinceList![
                                                    controller.provinceIndex!]
                                                .plateCode,
                                            phoneCode: ARMOYU
                                                .countryList[
                                                    controller.countryIndex!]
                                                .provinceList![
                                                    controller.provinceIndex!]
                                                .phoneCode,
                                          );
                                controller.currentUser!.detailInfo!.value!
                                    .phoneNumber.value = cleanedphoneNumber;
                                controller
                                    .currentUser!
                                    .detailInfo!
                                    .value!
                                    .birthdayDate
                                    .value = controller.birthday.value.text;

                                ARMOYUWidget.toastNotification(
                                  response.description,
                                );
                                Get.back();
                              },
                              loadingStatus: controller.profileeditProcess,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
