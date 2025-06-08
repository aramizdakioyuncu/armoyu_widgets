import 'dart:async';

import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/country&province/country.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/country&province/province.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/core/armoyu.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/country.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/province.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/translations/app_translation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileSettingsController extends GetxController {
  final ARMOYUServices service;

  ProfileSettingsController({
    required this.service,
  });
  FocusNode myFocusPassword = FocusNode();

  var firstName = TextEditingController().obs;

  var lastName = TextEditingController().obs;

  var aboutme = TextEditingController().obs;

  var email = TextEditingController().obs;

  var birthday = TextEditingController().obs;

  var country = (ProfileKeys.profileselectcountry.tr).obs;
  int? countryIndex = 0;

  var province = (ProfileKeys.profileselectcity.tr).obs;
  int? provinceIndex = 0;

  Timer? searchTimer;

  var phoneNumber = TextEditingController().obs;

  var passwordControl = TextEditingController().obs;
  var profileeditProcess = false.obs;
  Rx<bool> provinceSelectStatus = false.obs;
  User? currentUser;

  @override
  void onInit() {
    super.onInit();

    final findCurrentAccountController = Get.find<AccountUserController>();
    currentUser =
        findCurrentAccountController.currentUserAccounts.value.user.value;

    firstName.value.text = currentUser!.firstName!.value;

    lastName.value.text = currentUser!.lastName!.value;

    email.value.text = currentUser!.detailInfo!.value!.email.value ?? "";

    birthday.value.text =
        currentUser!.detailInfo!.value!.birthdayDate.value ?? "";

    if (currentUser!.detailInfo != null) {
      aboutme.value.text = currentUser!.detailInfo!.value!.about.toString();
    }

    if (currentUser!.detailInfo != null) {
      if (currentUser!.detailInfo!.value!.country.value != null) {
        country.value = currentUser!.detailInfo!.value!.country.value!.name;
        countryIndex = currentUser!.detailInfo!.value!.country.value!.countryID;
      }
    }

    if (currentUser!.detailInfo != null) {
      if (currentUser!.detailInfo!.value!.province.value != null) {
        province.value = currentUser!.detailInfo!.value!.province.value!.name;
        provinceIndex =
            currentUser!.detailInfo!.value!.province.value!.provinceID;
      }
    }

    if (ARMOYU.countryList.isNotEmpty) {
      if (ARMOYU.countryList[countryIndex!].provinceList != null) {
        provinceSelectStatus.value = true;
        // setstatefunction();
      }
    }
    if (ARMOYU.countryList.isEmpty) {
      fetchCountry();
    }
    if (currentUser!.detailInfo != null) {
      phoneNumber.value.text = formatString(
        currentUser!.detailInfo!.value!.phoneNumber.toString(),
      );
    }
  }

  static String formatString(String str) {
    if (str == "null" || str.isEmpty || str.length < 10) {
      return str;
    }
    String formattedStr = "(";

    formattedStr += "${str.substring(0, 3)}) ";

    formattedStr += "${str.substring(3, 6)} ";

    formattedStr += "${str.substring(6, 8)} ";

    formattedStr += str.substring(8);

    return formattedStr;
  }

  Future<void> fetchCountry() async {
    CountryResponse response = await service.countryServices.countryfetch();
    if (!response.result.status) {
      log(response.result.description);
      return;
    }
    ARMOYU.countryList.clear();

    for (APICountry country in response.response!) {
      ARMOYU.countryList.add(
        Country(
          countryID: country.countryID,
          name: country.name,
          countryCode: country.code,
          phoneCode: country.phonecode,
        ),
      );

      if (currentUser!.detailInfo == null) {
        log("İZİN YOK (COUNTRY)");
        return;
      }
      if (currentUser!.detailInfo!.value!.country.value != null) {
        if (country.countryID ==
            currentUser!.detailInfo!.value!.country.value!.countryID) {
          fetchProvince(
            currentUser!.detailInfo!.value!.country.value!.countryID,
            ARMOYU.countryList.length - 1,
          );
        }
      }
    }
  }

  Future<void> fetchProvince(int countryID, selectedIndex) async {
    if (ARMOYU.countryList[selectedIndex].provinceList != null) {
      if (ARMOYU.countryList[selectedIndex].provinceList!.isNotEmpty) {
        provinceSelectStatus.value = true;
      } else {
        provinceSelectStatus.value = false;
      }
      return;
    }

    ProvinceResponse response =
        await service.countryServices.fetchprovince(countryID: countryID);
    if (!response.result.status) {
      log(response.result.description);
      return;
    }

    if (response.response == null) {
      provinceSelectStatus.value = false;
      return;
    }

    List<Province> provinceList = [];
    for (APIProvince province in response.response!) {
      log(province.name);
      provinceList.add(
        Province(
          provinceID: province.provinceID,
          name: province.name,
          plateCode: province.platecode,
          phoneCode: province.phonecode,
        ),
      );
    }

    ARMOYU.countryList.elementAt(selectedIndex).provinceList = provinceList;

    if (provinceList.isNotEmpty) {
      provinceSelectStatus.value = true;
    } else {
      provinceSelectStatus.value = false;
    }
  }
}
