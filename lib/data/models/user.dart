import 'package:armoyu_services/core/models/ARMOYU/API/login&register&password/login.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/game.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/group.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/job.dart' as widgetjob;
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/role.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/school.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/station.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/team.dart';
import 'package:armoyu_widgets/data/models/Social/post.dart';
import 'package:armoyu_widgets/data/models/Story/storylist.dart';
import 'package:armoyu_widgets/data/models/socailaccounts.dart';
import 'package:armoyu_widgets/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'ARMOYU/country.dart';
import 'ARMOYU/province.dart';

class User {
  int? userID = -1;
  Rx<String>? userName = "0".obs;
  Rx<String>? firstName = "".obs;
  Rx<String>? lastName = "".obs;
  Rx<String>? displayName = "".obs;
  Media? avatar;
  Media? banner;
  Media? wallpaper;

  // Rx<String>? userMail = "".obs;

  // Rx<Country>? country;
  // Rx<Province>? province;
  String? registerDate = "";
  widgetjob.Job? job;
  Role? role;

  // Rx<String>? aboutme = "".obs;
  Rx<String>? burc = "".obs;
  // Rx<String>? invitecode = "".obs;
  // Rx<String>? lastlogin = "".obs;
  // Rx<String>? lastloginv2 = "".obs;
  // Rx<String>? lastfaillogin = "".obs;

  Rxn<UserDetailInfo>? detailInfo;

  Rx<int>? level = 0.obs;
  Rx<String>? levelColor;
  Rx<String>? xp;

  // int? friendsCount = 0;

  // int? postsCount = 0;
  // int? awardsCount = 0;

  // Rxn<String>? phoneNumber;
  // Rxn<String>? birthdayDate;
  Team? favTeam;

  bool? status;
  Rx<bool>? ismyFriend;

  // //Arkadaşlarım

  RxList<User>? myFriends;
  RxList<User>? mycloseFriends;

  // //ARAÇ GEREÇ
  // RxList<Chat>? chatlist;

  // //Gruplarım & Okullarım & İşyerlerim
  List<Group>? myGroups = [];
  List<School>? mySchools = [];
  List<Station>? myStations = [];

  //Sosyal KISIM
  RxList<Post>? widgetPosts;
  RxList<StoryList>? widgetStoriescard;
  Rx<Socialaccounts>? socialaccounts;
  RxList<Game>? popularGames;

  User({
    this.userID,
    this.userName,
    this.firstName,
    this.lastName,
    this.displayName,
    this.avatar,
    this.banner,
    this.wallpaper,
    // this.userMail,
    // this.country,
    // this.province,
    this.registerDate,
    this.job,
    this.role,
    // this.aboutme,
    this.burc,
    // this.invitecode,
    // this.lastlogin,
    // this.lastloginv2,
    // this.lastfaillogin,
    this.level,
    this.levelColor,
    this.xp,
    // this.friendsCount,
    // this.postsCount,
    // this.awardsCount,
    this.favTeam,
    this.status,
    this.ismyFriend,
    // this.phoneNumber,
    this.detailInfo,
    // this.birthdayDate,
    this.myFriends,
    // this.chatlist,
    this.mycloseFriends,
    this.myGroups,
    this.mySchools,
    this.myStations,
    this.widgetPosts,
    this.widgetStoriescard,
    this.socialaccounts,
    this.popularGames,
  });

  // JSON'dan User nesnesine dönüşüm
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userID: json['userID'],
      userName:
          json['username'] == null ? null : (json['username'] as String).obs,
      firstName:
          json['firstname'] == null ? null : (json['firstname'] as String).obs,
      lastName:
          json['lastname'] == null ? null : (json['lastname'] as String).obs,
      displayName: json['displayname'] == null
          ? null
          : (json['displayname'] as String).obs,
      // aboutme: json['aboutme'] == null ? null : (json['aboutme'] as String).obs,
      level: json['level'] == null ? null : (json['level'] as int).obs,
      levelColor: json['levelcolor'] == null
          ? null
          : (json['levelcolor'] as String).obs,
      xp: json['xp'] == null ? null : (json['xp'] as String).obs,
      // phoneNumber: Rxn<String>(json['phoneNumber']),
      detailInfo: json['detailInfo'] == null
          ? null
          : Rxn(
              UserDetailInfo.fromJson(json['detailInfo']),
            ),
      // birthdayDate: Rxn<String>(json['birthdayDate']),
      // userMail:
      //     json['usermail'] == null ? null : (json['usermail'] as String).obs,
      // country: json['country'] == null
      //     ? null
      //     : Country.fromJson(json['country']).obs,
      // province: json['province'] == null
      //     ? null
      //     : Province.fromJson(json['province']).obs,
      role: json['role'] == null
          ? null
          : Role(
              roleID: json['role']['roleID'],
              color: json['role']['color'],
              name: json['role']['name'],
            ),
      // friendsCount: json['friendscount'],
      // postsCount: json['postscount'],
      // awardsCount: json['awardscount'],
      avatar: json['avatar'] == null
          ? null
          : Media(
              mediaID: json['avatar']['media_ID'],
              mediaURL: MediaURL(
                bigURL: Rx<String>(json['avatar']['media_bigURL']),
                normalURL: Rx<String>(json['avatar']['media_normalURL']),
                minURL: Rx<String>(json['avatar']['media_minURL']),
              ),
            ),
      banner: json['banner'] == null
          ? null
          : Media(
              mediaID: json['banner']['media_ID'],
              mediaURL: MediaURL(
                bigURL: Rx<String>(json['banner']['media_bigURL']),
                normalURL: Rx<String>(json['banner']['media_normalURL']),
                minURL: Rx<String>(json['banner']['media_minURL']),
              ),
            ),
      wallpaper: json['wallpaper'] == null
          ? null
          : Media(
              mediaID: json['wallpaper']['media_ID'],
              mediaURL: MediaURL(
                bigURL: Rx<String>(json['wallpaper']['media_bigURL']),
                normalURL: Rx<String>(json['wallpaper']['media_normalURL']),
                minURL: Rx<String>(json['wallpaper']['media_minURL']),
              ),
            ),
      myFriends: json['myfriends'] == null
          ? null
          : (json['myfriends'] as List<dynamic>?)
              ?.map((friendJson) => User.fromJson(friendJson))
              .toList()
              .obs,
      myGroups: json['myGroups'] == null
          ? null
          : (json['myGroups'] as List<dynamic>?)
              ?.map((myGroups) => Group.fromJson(myGroups))
              .toList()
              .obs,
      // lastlogin:
      //     json['lastlogin'] == null ? null : (json['lastlogin'] as String).obs,
      // lastloginv2: json['lastloginv2'] == null
      //     ? null
      //     : (json['lastloginv2'] as String).obs,
      widgetPosts: json['widgetposts'] == null
          ? null
          : (json['widgetposts'] as List<dynamic>?)
              ?.map((widgetpost) => Post.fromJson(widgetpost))
              .toList()
              .obs,
      widgetStoriescard: json['widgetstoriescard'] == null
          ? null
          : (json['widgetstoriescard'] as List<dynamic>?)
              ?.map((storylistJson) => StoryList.fromJson(storylistJson))
              .toList()
              .obs,
      socialaccounts: json['socialaccounts'] == null
          ? null
          : (Socialaccounts.fromJson(json['socialaccounts'])).obs,
      popularGames: json['popularGames'] == null
          ? null
          : (json['popularGames'] as List<dynamic>?)
              ?.map((widgetpost) => Game.fromJson(widgetpost))
              .toList()
              .obs,
      ismyFriend:
          json['ismyFriend'] == null ? null : (json['ismyFriend'] as bool).obs,
    );
  }

  // User nesnesinden JSON'a dönüşüm
  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'username': userName?.value,
      'firstname': firstName?.value,
      'lastname': lastName?.value,
      'displayname': displayName?.value,
      // 'aboutme': aboutme?.value,
      'level': level?.value,
      'xp': xp?.value,
      // 'phoneNumber': phoneNumber?.value,
      'detailInfo':
          detailInfo?.value == null ? null : detailInfo!.value!.toJson(),
      // 'birthdayDate': birthdayDate?.value,
      'levelcolor': levelColor?.value,
      // 'usermail': userMail?.value,
      // 'country': country?.value.toJson(),
      // 'province': province?.value.toJson(),
      'role': role != null
          ? {
              'roleID': role!.roleID,
              'color': role!.color,
              'name': role!.name,
            }
          : null,
      // 'friendscount': friendsCount,
      // 'postscount': postsCount,
      // 'awardscount': awardsCount,
      'avatar': avatar != null
          ? {
              'media_ID': avatar!.mediaID,
              'media_bigURL': avatar!.mediaURL.bigURL.value,
              'media_normalURL': avatar!.mediaURL.normalURL.value,
              'media_minURL': avatar!.mediaURL.minURL.value,
            }
          : null,
      'banner': banner != null
          ? {
              'media_ID': banner!.mediaID,
              'media_bigURL': banner!.mediaURL.bigURL.value,
              'media_normalURL': banner!.mediaURL.normalURL.value,
              'media_minURL': banner!.mediaURL.minURL.value,
            }
          : null,
      'wallpaper': wallpaper != null
          ? {
              'media_ID': wallpaper!.mediaID,
              'media_bigURL': wallpaper!.mediaURL.bigURL.value,
              'media_normalURL': wallpaper!.mediaURL.normalURL.value,
              'media_minURL': wallpaper!.mediaURL.minURL.value,
            }
          : null,
      'myfriends': myFriends?.map((friend) => friend.toJson()).toList(),
      'myGroups': myGroups?.map((myGroups) => myGroups.toJson()).toList(),
      // 'lastlogin': lastlogin?.value,
      // 'lastloginv2': lastloginv2?.value,
      'widgetposts': widgetPosts?.map((posts) => posts.toJson()).toList(),
      'widgetstoriescard':
          widgetStoriescard?.map((stories) => stories.toJson()).toList(),
      'socialaccounts': socialaccounts?.value.toJson(),
      'popularGames': popularGames?.map((game) => game.toJson()).toList(),
      'ismyFriend': ismyFriend?.value
    };
  }

  //kRİTİK ÖNEME SAHİPTİR

  factory User.apilogintoUser(APILogin response) {
    return User(
      // ismyFriend: "",
      // myGroups: "",
      // mySchools: "",
      // myStations: "",
      // mycloseFriends: "",
      // status: "",
      // widgetPosts: "",
      // widgetStoriescard: "",

      userID: response.playerID,
      userName: response.username?.obs,
      firstName: response.firstName?.obs,
      lastName: response.lastName?.obs,
      // userMail: response.detailInfo?.email!.obs,

      //ÖNEMLİ
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
      //ÖNemli

      registerDate: response.registeredDate,
      // postsCount: response.detailInfo!.posts!,
      // phoneNumber: Rxn(response.detailInfo?.phoneNumber),

      // birthdayDate: Rxn(response.detailInfo?.birthdayDate),
      burc: response.burc != null ? Rx(response.burc!) : null,

      // lastfaillogin: response.detailInfo?.lastfailedDate?.obs,
      // lastlogin: response.detailInfo?.lastloginDate?.obs,
      // lastloginv2: response.detailInfo?.lastloginDateV2?.obs,
      level: response.level?.obs,
      levelColor: response.levelColor?.obs,
      xp: response.levelXP?.obs,
      // friendsCount: response.detailInfo!.friends!,
      // invitecode: Rx(response.detailInfo!.inviteCode!),

      // aboutme:
      //     response.detailInfo != null ? Rx(response.detailInfo!.about!) : null,
      avatar: response.avatar != null
          ? Media(
              mediaID: response.avatar!.mediaID,
              mediaURL: MediaURL(
                bigURL: Rx(response.avatar!.mediaURL.bigURL),
                normalURL: Rx(response.avatar!.mediaURL.normalURL),
                minURL: Rx(response.avatar!.mediaURL.minURL),
              ),
            )
          : null,
      banner: response.avatar != null
          ? Media(
              mediaID: response.banner!.mediaID,
              mediaURL: MediaURL(
                bigURL: Rx(response.banner!.mediaURL.bigURL),
                normalURL: Rx(response.banner!.mediaURL.normalURL),
                minURL: Rx(response.banner!.mediaURL.minURL),
              ),
            )
          : null,
      wallpaper: response.wallpaper != null
          ? Media(
              mediaID: response.wallpaper!.mediaID,
              mediaURL: MediaURL(
                bigURL: Rx(response.wallpaper!.mediaURL.bigURL),
                normalURL: Rx(response.wallpaper!.mediaURL.normalURL),
                minURL: Rx(response.wallpaper!.mediaURL.minURL),
              ),
            )
          : null,
      // awardsCount: response.detailInfo?.awards,

      // country: Country(
      //   countryID: response.detailInfo!.country!.countryID,
      //   name: response.detailInfo!.country!.name,
      //   countryCode: response.detailInfo!.country!.code,
      //   phoneCode: response.detailInfo!.country!.phonecode,
      // ).obs,
      displayName: response.displayName?.obs,
      favTeam: response.favTeam != null
          ? Team(
              teamID: response.favTeam!.teamID,
              name: response.favTeam!.teamName,
              logo: response.favTeam!.teamLogo.minURL,
            )
          : null,

      job: response.job != null
          ? widgetjob.Job(
              jobID: response.job!.jobID,
              name: response.job!.jobName,
              shortName: response.job!.jobShortName,
            )
          : null,

      myFriends: response.arkadasliste
          ?.map(
            (friend) => User(
              displayName: friend.oyuncuKullaniciAdi.obs,
              avatar: Media(
                mediaID: 0,
                mediaURL: MediaURL(
                  bigURL: Rx(friend.oyuncuMinnakAvatar.bigURL),
                  normalURL: Rx(friend.oyuncuMinnakAvatar.normalURL),
                  minURL: Rx(friend.oyuncuMinnakAvatar.minURL),
                ),
              ),
            ),
          )
          .toList()
          .obs,

      popularGames: response.popularGames
          ?.map(
            (e) => Game(
              gameID: e.gameID!,
              name: e.gameName!,
              logo: Media(
                mediaID: e.gameLogo!.mediaID,
                mediaURL: MediaURL(
                  bigURL: Rx(e.gameLogo!.mediaURL.bigURL),
                  normalURL: Rx(e.gameLogo!.mediaURL.normalURL),
                  minURL: Rx(
                    e.gameLogo!.mediaURL.minURL,
                  ),
                ),
              ),
              gameURL: e.gameURL!,
              gameType: "-------- GİRİLMEDİ --------",
            ),
          )
          .toList()
          .obs,

      // province: Province(
      //   provinceID: response.detailInfo!.province!.provinceID,
      //   name: response.detailInfo!.province!.name,
      //   plateCode: response.detailInfo!.province!.platecode,
      //   phoneCode: response.detailInfo!.province!.phonecode,
      // ).obs,

      role: response.userRole != null
          ? Role(
              roleID: response.userRole!.roleID,
              name: response.userRole!.roleName,
              color: response.userRole!.roleColor,
            )
          : null,
      socialaccounts: response.socailAccounts != null
          ? Socialaccounts(
              facebook: Rxn(response.socailAccounts!.facebook),
              github: Rxn(response.socailAccounts!.github),
              instagram: Rxn(response.socailAccounts!.instagram),
              linkedin: Rxn(response.socailAccounts!.linkedin),
              reddit: Rxn(response.socailAccounts!.reddit),
              steam: Rxn(response.socailAccounts!.steam),
              twitch: Rxn(response.socailAccounts!.twitch),
              youtube: Rxn(response.socailAccounts!.youtube),
              discord: Rxn(response.socailAccounts!.youtube),
            ).obs
          : null,
    );
  }
  //kRİTİK ÖNEME SAHİPTİR

  void updateUser({required User targetUser}) {
    if (userID != null) targetUser.userID = userID;
    if (userName != null) targetUser.userName = userName;
    if (firstName != null) {
      targetUser.firstName = firstName;
    }
    if (lastName != null) targetUser.lastName = lastName;
    if (displayName != null) {
      targetUser.displayName = displayName;
    }
    if (avatar != null) targetUser.avatar = avatar;
    if (banner != null) targetUser.banner = banner;
    if (wallpaper != null) targetUser.wallpaper = wallpaper;

    // if (userMail != null) targetUser.userMail = userMail;
    // if (country != null) targetUser.country = country;
    // if (province != null) targetUser.province = province;
    if (registerDate != null) {
      targetUser.registerDate = registerDate;
    }
    if (job != null) targetUser.job = job;
    if (role != null) targetUser.role = role;
    // if (aboutme != null) targetUser.aboutme = aboutme;
    if (burc != null) targetUser.burc = burc;
    // if (invitecode != null) {
    //   targetUser.invitecode = invitecode;
    // }
    // if (lastlogin != null) {
    //   targetUser.lastlogin = lastlogin;
    // }
    // if (lastloginv2 != null) {
    //   targetUser.lastloginv2 = lastloginv2;
    // }
    // if (lastfaillogin != null) {
    //   targetUser.lastfaillogin = lastfaillogin;
    // }

    if (detailInfo != null) {
      targetUser.detailInfo!.value = detailInfo!.value;
    }
    if (level != null) targetUser.level = level;
    if (levelColor != null) {
      targetUser.levelColor = levelColor;
    }
    if (xp != null) targetUser.xp = xp;
    // if (friendsCount != null) {
    //   targetUser.friendsCount = friendsCount;
    // }
    // if (postsCount != null) {
    //   targetUser.postsCount = postsCount;
    // }
    // if (awardsCount != null) {
    //   targetUser.awardsCount = awardsCount;
    // }
    // if (phoneNumber != null) {
    //   targetUser.phoneNumber = phoneNumber;
    // }
    // if (birthdayDate != null) {
    //   targetUser.birthdayDate = birthdayDate;
    // }
    if (favTeam != null) targetUser.favTeam = favTeam;
    if (status != null) targetUser.status = status;
    if (ismyFriend != null) {
      targetUser.ismyFriend = ismyFriend;
    }
    if (myFriends != null) {
      targetUser.myFriends = myFriends;
    }

    if (mycloseFriends != null) {
      targetUser.mycloseFriends = mycloseFriends;
    }
    if (myGroups != null) targetUser.myGroups = myGroups;
    if (mySchools != null) {
      targetUser.mySchools = mySchools;
    }
    if (myStations != null) {
      targetUser.myStations = myStations;
    }

    if (widgetPosts != null) {
      targetUser.widgetPosts = widgetPosts;
    }

    if (widgetPosts != null) {
      targetUser.widgetPosts = widgetPosts;
    }

    if (widgetStoriescard != null) {
      targetUser.widgetStoriescard = widgetStoriescard;
    }
  }

  Widget storyViewUserList({bool isLiked = false}) {
    return ListTile(
      leading: CircleAvatar(
        foregroundImage:
            CachedNetworkImageProvider(avatar!.mediaURL.minURL.value),
      ),
      title: CustomText.costum1(displayName!.value, weight: FontWeight.bold),
      trailing: isLiked
          ? const Icon(
              Icons.favorite,
              color: Colors.red,
            )
          : null,
      onTap: () {},
    );
  }
}

class UserDetailInfo {
  Rxn<String> about;
  Rxn<int> age;
  Rxn<String> email;
  Rxn<int> friends;
  Rxn<int> posts;
  Rxn<int> awards;
  Rxn<String> phoneNumber;
  Rxn<String> birthdayDate;
  Rxn<String> inviteCode;
  Rxn<String> lastloginDate;
  Rxn<String> lastloginDateV2;
  Rxn<String> lastfailedDate;
  Rxn<Country> country;
  Rxn<Province> province;

  UserDetailInfo({
    required this.about,
    required this.age,
    required this.email,
    required this.friends,
    required this.posts,
    required this.awards,
    required this.phoneNumber,
    required this.birthdayDate,
    required this.inviteCode,
    required this.lastloginDate,
    required this.lastloginDateV2,
    required this.lastfailedDate,
    required this.country,
    required this.province,
  });

  factory UserDetailInfo.fromJson(Map<String, dynamic> json) {
    return UserDetailInfo(
      about: Rxn(json['about']),
      age: Rxn(json['age']),
      email: Rxn(json['email']),
      friends: Rxn(json['friends']),
      posts: Rxn(json['posts']),
      awards: Rxn(json['awards']),
      phoneNumber: Rxn(json['phoneNumber']),
      birthdayDate: Rxn(json['birthdayDate']),
      inviteCode: Rxn(json['inviteCode']),
      lastloginDate: Rxn(json['lastloginDate']),
      lastloginDateV2: Rxn(json['lastloginDateV2']),
      lastfailedDate: Rxn(json['lastfailedDate']),
      country: Rxn(json['country']),
      province: Rxn(Province.fromJson(json['province'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'about': about.value,
      'age': age.value,
      'email': email.value,
      'friends': friends.value,
      'posts': posts.value,
      'awards': awards.value,
      'phoneNumber': phoneNumber.value,
      'birthdayDate': birthdayDate.value,
      'inviteCode': inviteCode.value,
      'lastloginDate': lastloginDate.value,
      'lastloginDateV2': lastloginDateV2.value,
      'lastfailedDate': lastfailedDate.value,
      'country': country.toJson(),
      'province': province.toJson(),
    };
  }
}
