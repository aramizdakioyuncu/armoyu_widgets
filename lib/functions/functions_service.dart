import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/login&register&password/login.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/service_result.dart';

import 'package:armoyu_widgets/core/armoyu.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu_widgets/functions/functions.dart';
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';

class FunctionService {
  final ARMOYUServices service;
  FunctionService(this.service);
  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  Future<ServiceResult> getappdetail() async {
    ServiceResult jsonData = await service.utilsServices.getappdetail();
    return jsonData;
  }

///////////Fonksiyonlar Başlangıcı

  Future<LoginResponse> adduserAccount(
    String username,
    String userpass,
  ) async {
    // password = generateMd5(password);

    LoginResponse response = await service.authServices
        .login(username: username, password: userpass);

    if (!response.result.status ||
        response.result.description == "Oyuncu bilgileri yanlış!") {
      return response;
    }

    APILogin oyuncubilgi = response.response!;

    User userdetail = ARMOYUFunctions.userfetch(oyuncubilgi);

    int isUserAccountHas = ARMOYU.appUsers.indexWhere(
        (element) => element.user.value.userID == userdetail.userID);

    if (isUserAccountHas != -1) {
      log("Zaten Kullanıcı Oturum Açmış!");
      return response;
    }
    ARMOYU.appUsers.add(
      UserAccounts(
        user: userdetail.obs,
        sessionTOKEN: Rx(response.result.description),
        language: Rxn(),
      ),
    );

    // Kullanıcı listesini Storeage'e kaydetme
    List<String> usersJson =
        ARMOYU.appUsers.map((user) => jsonEncode(user.toJson())).toList();
    ARMOYU.storage.write("users", usersJson);
    // Kullanıcı listesini Storeage'e kaydetme
    return response;
  }

  Future<User?> fetchUserInfo({required int userID}) async {
    LookProfileResponse response = await lookProfile(userID);

    if (!response.result.status ||
        response.result.description == "Oyuncu bilgileri yanlış!") {
      return User();
    }

    User userdetail = ARMOYUFunctions.userfetch(response.response!);

    return userdetail;
  }

  Future<LoginResponse> login(String username, String password) async {
    LoginResponse response = await service.authServices
        .login(username: username, password: password);

    if (!response.result.status ||
        response.result.description == "Oyuncu bilgileri yanlış!") {
      return response;
    }

    ARMOYU.version = response.result.descriptiondetail["versiyon"].toString();
    ARMOYU.securityDetail =
        response.result.descriptiondetail["projegizliliksozlesmesi"];

    APILogin oyuncubilgi = response.response!;

    UserAccounts userdetail = UserAccounts(
      user: ARMOYUFunctions.userfetch(oyuncubilgi).obs,
      sessionTOKEN: Rx(response.result.description),
      language: Rxn(),
    );

    //İlk defa giriş yapılıyorsa
    if (ARMOYU.appUsers.isEmpty) {
      ARMOYU.appUsers.add(userdetail);
    }

    // Kullanıcı listesini Storeage'e kaydetme
    List<String> usersJson =
        ARMOYU.appUsers.map((user) => jsonEncode(user.toJson())).toList();
    ARMOYU.storage.write("users", usersJson);
    // Kullanıcı listesini Storeage'e kaydetme

    userdetail.updateUser(targetUser: ARMOYU.appUsers.first.user.value);

    if (ARMOYU.deviceModel != "Bilinmeyen") {
      log("Onesignal işlemleri!");
      // OneSignalsetupOneSignal(currentUserAccounts: userdetail);
    }

    //Socket Güncelle
    // var socketio = Get.find<SocketioController>();
    // socketio.registerUser(userdetail.user.value);
    //Socket Güncelle

    LoginResponse ll = LoginResponse(
      result: ServiceResult(
        status: true,
        description: "Başarılı",
        descriptiondetail: response.result.descriptiondetail,
      ),
      response: oyuncubilgi,
    );

    return ll;
  }

  Future<RegisterResponse> register(
    String username,
    String name,
    String lastname,
    String email,
    String password,
    String rpassword,
    String inviteCode,
  ) async {
    RegisterResponse jsonData = await service.authServices.register(
      username: username,
      firstname: name,
      lastname: lastname,
      email: email,
      password: password,
      rpassword: rpassword,
      inviteCode: inviteCode,
    );
    return jsonData;
  }

  Future<Map<String, dynamic>> logOut(int userID) async {
    //Oturumunu Kapat
    ARMOYU.appUsers
        .removeWhere((element) => element.user.value.userID == userID);
    //Oturumunu Kapat Bitiş

    // Kullanıcı listesini Storeage'e kaydetme
    List<String> usersJson =
        ARMOYU.appUsers.map((user) => jsonEncode(user.toJson())).toList();
    ARMOYU.storage.write("users", usersJson);
    // Kullanıcı listesini Storeage'e kaydetme
    //
    Map<String, dynamic> jsonData = {
      'durum': 1,
      'aciklama': "Başarılı bir şekilde çıkış yapıldı.",
    };
    String jsonencode = jsonEncode(jsonData);
    Map<String, dynamic> jsonString = jsonData = json.decode(jsonencode);
    return jsonString;
  }

  Future<ServiceResult> forgotpassword(
      String username, String useremail, String userresettype) async {
    ServiceResult jsonData = await service.utilsServices.forgotpassword(
      username: username,
      useremail: useremail,
      userresettype: userresettype,
    );
    return jsonData;
  }

  Future<ServiceResult> forgotpassworddone(String username, String useremail,
      String securitycode, String password, String repassword) async {
    ServiceResult jsonData = await service.utilsServices.forgotpassworddone(
      username: username,
      useremail: useremail,
      securitycode: securitycode,
      password: password,
      repassword: repassword,
    );
    return jsonData;
  }

  Future<LookProfileResponse> lookProfile(int userID) async {
    LookProfileResponse jsonData =
        await service.utilsServices.lookProfile(userID: userID);
    return jsonData;
  }

  Future<LookProfilewithUsernameResponse> lookProfilewithusername(
      String username) async {
    LookProfilewithUsernameResponse jsonData = await service.utilsServices
        .lookProfilewithusername(userusername: username);
    return jsonData;
  }

  Future<APIMyGroupListResponse> myGroups() async {
    APIMyGroupListResponse jsonData = await service.utilsServices.myGroups();
    return jsonData;
  }

  Future<APIMySchoolListResponse> mySchools() async {
    APIMySchoolListResponse jsonData = await service.utilsServices.mySchools();
    return jsonData;
  }

  Future<ServiceResult> myStations() async {
    ServiceResult jsonData = await service.utilsServices.myStations();
    return jsonData;
  }

  Future<PostFetchListResponse> getprofilePosts(
      int page, int userID, String category) async {
    PostFetchListResponse jsonData = await service.postsServices.getPosts(
      userID: userID,
      page: page,
      category: category,
    );
    return jsonData;
  }

  Future<PlayerPopResponse> getplayerxp(int page) async {
    PlayerPopResponse jsonData =
        await service.utilsServices.getplayerxp(page: page);
    return jsonData;
  }

  Future<PlayerPopResponse> getplayerpop(int page) async {
    PlayerPopResponse jsonData =
        await service.utilsServices.getplayerpop(page: page);
    return jsonData;
  }

  Future<NotificationListResponse> getnotifications(
      String kategori, String kategoridetay, int page) async {
    NotificationListResponse jsonData =
        await service.notificationServices.getnotifications(
      kategori: kategori,
      kategoridetay: kategoridetay,
      page: page,
    );
    return jsonData;
  }

  Future<ChatListResponse> getchats(int page) async {
    ChatListResponse jsonData =
        await service.chatServices.currentChatList(page: page);
    return jsonData;
  }

  Future<ChatNewListResponse> getnewchatfriendlist(int page) async {
    ChatNewListResponse jsonData =
        await service.chatServices.newChatlist(page: page);
    return jsonData;
  }

  Future<ServiceResult> sendchatmessage(
      int userID, String message, String type) async {
    ServiceResult jsonData = await service.chatServices.sendchatmessage(
      userID: userID,
      message: message,
      type: type,
    );
    return jsonData;
  }
}
