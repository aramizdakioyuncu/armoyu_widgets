import 'dart:async';

import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/core/armoyu.dart';

import 'package:armoyu_widgets/data/models/ARMOYU/country.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/job.dart' as armoyujob;
import 'package:armoyu_widgets/data/models/ARMOYU/province.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/role.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/team.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';

import 'package:armoyu_widgets/widgets/text.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/login&register&password/login.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/team/team_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/service_result.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ARMOYUFunctions {
  final UserAccounts currentUserAccounts;

  final ARMOYUServices service;
  ARMOYUFunctions({required this.currentUserAccounts, required this.service});

  static User userfetch(APILogin response) {
    return User(
      userID: response.playerID,
      userName: Rx<String>(response.username!),
      firstName: Rx<String>(response.firstName!),
      lastName: Rx<String>(response.lastName!),
      displayName: Rx<String>(response.displayName!),
      // userMail: Rx<String>(response.detailInfo!.email!),
      // aboutme: Rx<String>(response.detailInfo!.about!),
      avatar: Media(
        mediaID: response.avatar!.mediaID,
        mediaType: MediaType.image,
        ownerID: response.playerID,
        mediaURL: MediaURL(
          bigURL: Rx<String>(response.avatar!.mediaURL.bigURL),
          normalURL: Rx<String>(response.avatar!.mediaURL.normalURL),
          minURL: Rx<String>(response.avatar!.mediaURL.minURL),
        ),
      ),
      banner: Media(
        mediaID: response.banner!.mediaID,
        ownerID: response.playerID,
        mediaType: MediaType.image,
        mediaURL: MediaURL(
          bigURL: Rx<String>(response.banner!.mediaURL.bigURL),
          normalURL: Rx<String>(response.banner!.mediaURL.normalURL),
          minURL: Rx<String>(response.banner!.mediaURL.minURL),
        ),
      ),
      burc: response.burc == null ? null : Rx<String>(response.burc!),
      // invitecode: response.detailInfo!.inviteCode == null
      //     ? null
      //     : Rx<String>(response.detailInfo!.inviteCode!),
      // lastlogin: response.detailInfo!.lastloginDate == null
      //     ? null
      //     : Rx<String>(response.detailInfo!.lastloginDate!),
      // lastloginv2: response.detailInfo!.lastloginDateV2 == null
      //     ? null
      //     : Rx<String>(response.detailInfo!.lastloginDateV2!),
      // lastfaillogin: response.detailInfo!.lastfailedDate == null
      //     ? null
      //     : Rx<String>(response.detailInfo!.lastfailedDate!),
      job: response.job == null
          ? null
          : armoyujob.Job(
              jobID: response.job!.jobID,
              name: response.job!.jobName,
              shortName: response.job!.jobShortName,
            ),
      detailInfo: response.detailInfo == null
          ? null
          : Rxn(
              UserDetailInfo(
                about: Rxn(response.detailInfo!.about),
                age: Rxn(response.detailInfo!.age),
                email: Rxn(response.detailInfo!.email),
                friends: Rxn(response.detailInfo!.friends),
                posts: Rxn(response.detailInfo!.posts),
                awards: Rxn(response.detailInfo!.awards),
                phoneNumber: Rxn(response.detailInfo!.phoneNumber),
                birthdayDate: Rxn(response.detailInfo!.birthdayDate),
                inviteCode: Rxn(response.detailInfo!.inviteCode),
                lastloginDate: Rxn(response.detailInfo!.lastloginDate),
                lastloginDateV2: Rxn(response.detailInfo!.lastloginDateV2),
                lastfailedDate: Rxn(response.detailInfo!.lastfailedDate),
                country: response.detailInfo!.country == null
                    ? Rxn()
                    : Rxn(
                        Country(
                          countryID: response.detailInfo!.country!.countryID,
                          name: response.detailInfo!.country!.name,
                          countryCode: response.detailInfo!.country!.code,
                          phoneCode: response.detailInfo!.country!.phonecode,
                        ),
                      ),
                province: response.detailInfo!.province == null
                    ? Rxn()
                    : Rxn(
                        Province(
                          provinceID: response.detailInfo!.province!.provinceID,
                          name: response.detailInfo!.province!.name,
                          plateCode: response.detailInfo!.province!.platecode,
                          phoneCode: response.detailInfo!.province!.phonecode,
                        ),
                      ),
              ),
            ),
      level: Rx<int>(response.level!),
      levelColor: Rx<String>(response.levelColor!),
      xp: Rx<String>(response.levelXP!),
      // awardsCount: response.detailInfo!.awards,
      // postsCount: response.detailInfo!.posts,
      // friendsCount: response.detailInfo!.friends,
      // country: response.detailInfo!.country == null
      //     ? null
      //     : Country(
      //         countryID: response.detailInfo!.country!.countryID,
      //         name: response.detailInfo!.country!.name,
      //         countryCode: response.detailInfo!.country!.code,
      //         phoneCode: response.detailInfo!.country!.phonecode,
      //       ).obs,
      // province: response.detailInfo!.province == null
      //     ? null
      //     : Province(
      //         provinceID: response.detailInfo!.province!.provinceID,
      //         name: response.detailInfo!.province!.name,
      //         plateCode: response.detailInfo!.province!.platecode,
      //         phoneCode: response.detailInfo!.province!.phonecode,
      //       ).obs,
      registerDate: response.registeredDateV2,
      role: Role(
        roleID: response.roleID!,
        name: response.roleName!,
        color: response.roleColor!,
      ),
      // birthdayDate: Rxn<String>(response.detailInfo!.birthdayDate),
      // phoneNumber: Rxn<String>(response.detailInfo!.phoneNumber),
      favTeam: response.favTeam != null
          ? Team(
              teamID: response.favTeam!.teamID,
              name: response.favTeam!.teamName,
              logo: response.favTeam!.teamLogo.minURL,
            )
          : null,
    );
  }

  // Play Store'u açan metod
  static void openPlayStore() async {
    if (await canLaunchUrl(Uri.parse(
        "https://play.google.com/store/apps/details?id=com.ARMOYU"))) {
      await launchUrl(Uri.parse(
          "https://play.google.com/store/apps/details?id=com.ARMOYU"));
    } else {
      throw 'App Store açılamadı!';
    }
  }

  // App Store'u açan metod
  static void openAppStore() async {
    if (await canLaunchUrl(
        Uri.parse("https://apps.apple.com/tr/app/armoyu/id6448871009?l=tr"))) {
      await launchUrl(
          Uri.parse("https://apps.apple.com/tr/app/armoyu/id6448871009?l=tr"));
    } else {
      throw 'App Store açılamadı!';
    }
  }

  static void updateForce(context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Uygulama Güncelleme'),
          content: const Text(
              'Uygulama desteği kesildi. Lütfen güncelleme yapınız.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                if (ARMOYU.devicePlatform == "Android") {
                  ARMOYUFunctions.openPlayStore();
                } else {
                  ARMOYUFunctions.openAppStore();
                }
              },
              child: const Text('Güncelle'),
            ),
          ],
        );
      },
    );
  }

  Future<void> selectFavTeam(context, {bool? force}) async {
    if (force == null || force == false) {
      if (currentUserAccounts.user.value.favTeam != null) {
        log("Favori Takım seçilmiş");
        return;
      }
      if (currentUserAccounts.favteamRequest) {
        log("Sorulmuş ama seçmek istememiş");
        return;
      }
    }

    await favteamfetch();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SizedBox(
            width: ARMOYU.screenWidth * 0.95,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Favori Takımını Seç',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(
                          currentUserAccounts.favoriteteams!.length,
                          (index) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop(
                                    currentUserAccounts.favoriteteams![index]);
                              },
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: currentUserAccounts
                                        .favoriteteams![index].logo,
                                    height: 60,
                                    width: 60,
                                  ),
                                  Text(currentUserAccounts
                                      .favoriteteams![index].name),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop(null);
                        },
                        child: CustomText.costum1("Bunlardan Hiçbiri"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).then((selectedTeam) {
      // Kullanıcının seçtiği takımı işle
      if (selectedTeam != null) {
        log('Seçilen Takım: ${selectedTeam.name}');
        favteamselect(selectedTeam);
      } else {
        favteamselect(null);
      }
      currentUserAccounts.favteamRequest = true;
    });
  }

  Future<void> favteamselect(Team? team) async {
    ServiceResult response =
        await service.profileServices.selectfavteam(teamID: team?.teamID);
    log(response.toString());
    if (!response.status) {
      log(response.description);
      return;
    }
    if (team != null) {
      currentUserAccounts.user.value.favTeam =
          Team(teamID: team.teamID, name: team.name, logo: team.logo);
    } else {
      currentUserAccounts.user.value.favTeam = null;
    }
  }

  Future<void> favteamfetch() async {
    if (currentUserAccounts.favoriteteams == null) {
      TeamListResponse response = await service.teamsServices.fetch();
      if (!response.result.status) {
        log(response.result.description);
        favteamfetch();
        return;
      }

      currentUserAccounts.favoriteteams = [];

      for (APITeamList element in response.response!) {
        currentUserAccounts.favoriteteams!.add(
          Team(
            teamID: element.teamId,
            name: element.teamName,
            logo: element.teamLogo.minURL,
          ),
        );
      }
    }
  }
}
