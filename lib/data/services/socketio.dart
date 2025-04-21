import 'dart:async';
import 'dart:developer';

import 'package:armoyu_services/core/models/ARMOYU/API/chat/chat.dart';
import 'package:armoyu_widgets/data/models/Chat/chat.dart';
import 'package:armoyu_widgets/data/models/Chat/chat_message.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/sources/popupnotifications/calling_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:get/get.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketioController extends GetxController {
  late IO.Socket socket;
  var socketChatStatus = false.obs;

  Timer? userListTimer;
  Timer? pingTimer;
  var pingID = "".obs;

  var pingValue = 0.obs; // Ping değerini reaktif hale getirdik
  DateTime? lastPingTime; // Son ping zamanı
  String socketPREFIX = "||SOCKET|| -> ";

  var isCallingMe = false.obs;
  var whichuserisCallingMe = "".obs;

  //WEBRTC
  webrtc.RTCPeerConnection? peerConnection;
  webrtc.MediaStream? localStream;
  webrtc.MediaStream? remoteStream;

  var localRenderer = webrtc.RTCVideoRenderer().obs;
  var remoteRenderer = webrtc.RTCVideoRenderer().obs;
  var connectionState = Rx<webrtc.RTCPeerConnectionState?>(null);

  Future<void> webRTCinit({bool restoresystem = false}) async {
    if (restoresystem) {
      // Önce eski bağlantıyı temizle
      await peerConnection?.close();
      peerConnection = null;

      await localStream?.dispose();
      localStream = null;
    }

    await localRenderer.value.initialize();
    await remoteRenderer.value.initialize();

    localStream = await webrtc.navigator.mediaDevices.getUserMedia({
      "audio": true,
      "video": true,
    });

    // Akışı bir renderer ile yerel videoda göster
    localRenderer.value.srcObject = localStream;

    peerConnection = await webrtc.createPeerConnection({
      "iceServers": [
        {"urls": "stun:stun.l.google.com:19302"}
      ]
    });

    localStream!.getTracks().forEach((track) {
      peerConnection!.addTrack(track, localStream!);
    });

    peerConnection!.onIceCandidate = (candidate) {
      sendCandidate(candidate.toMap());
    };

    peerConnection!.onTrack = (event) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (event.track.kind == 'audio') {
          log('Gelen ses verisi: ${event.streams[0]}');
        }

        if (event.track.kind == 'video') {
          remoteStream = event.streams[0];
          remoteRenderer.value.srcObject = remoteStream;
        }
      });

      log('//**//');
    };

    peerConnection!.onConnectionState = (state) {
      log("Connection state: $state");
      connectionState.value = state; // Bağlantı durumunu güncelliyoruz
    };
  }
  //WEBRTC

  @override
  void onInit() {
    super.onInit();
    socketInit();
    socket.connect();
  }

  @override
  void onClose() {
    stopPing();
    socket.disconnect();
    super.onClose();
  }

  var currentUserAccounts = Rx<UserAccounts>(
    UserAccounts(
      user: User().obs,
      sessionTOKEN: Rx(""),
      language: Rxn(),
    ),
  );

  void updateuseraccount() {
    pingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      //* *//
      final findCurrentAccountController = Get.find<AccountUserController>();
      //* *//

      currentUserAccounts.value =
          findCurrentAccountController.currentUserAccounts.value;
    });
  }

  socketInit() {
    updateuseraccount();

    // Socket.IO'ya bağlanma
    socket = IO.io('http://socket.armoyu.com:2020', <String, dynamic>{
      // socket = IO.io('http://10.0.2.2:2020', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    startPing(const Duration(seconds: 2));
    // Ping değerini güncelle

    socket.on('ping', (data) {
      // Burada data yerine ping zamanı verilmez.
      pingValue.value = data; // Bu satırda hata var
      log('${socketPREFIX}Ping: ${pingValue.value} ms'); // Log ile göster
    });

    // Pong mesajını dinle
    socket.on('pong', (data) {
      // data içinde ping ID'sini al

      String pingId = data['id'];
      if (pingId != pingID.value) {
        log("PING ID eşleşmedi: Beklenen ${pingID.value}, gelen $pingId");
        return;
      }

      DateTime pongReceivedTime = DateTime.now(); // Pong zamanı
      if (lastPingTime != null) {
        // Ping süresini hesapla
        pingValue.value =
            pongReceivedTime.difference(lastPingTime!).inMilliseconds;
        // log('Pong yanıtı alındı: $pingId');
        log('Ping süresi: ${pingValue.value} ms');
      }
    });

    //WEBRTC

    // 'offer' olayını dinle
    socket.on('offer', (data) async {
      if (kDebugMode) {
        print('Received offer');
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Burada arama popup'ı açılabilir
        CallingWidget.showIncomingCallDialog(
          callerName: "Birisi Arıyor",
          callerAvatarUrl: "",
          onAccept: () {
            //
            // Get.toNamed(Routes.CHATCALL,
            //     arguments: {'chat': controller.chat.value});
          },
          onDecline: () {
            if (kDebugMode) {
              print("Arama reddedildi");
            }
          },
        );
      });

      if (data is Map<String, dynamic>) {
        var offer = webrtc.RTCSessionDescription(
          data['sdp'], // SDP verisini al
          data['type'], // Offer veya Answer tipi
        );

        //teklif geliyor ve kabul ediyoruz peerConnection oluşturuyoruz
        await webRTCinit(restoresystem: true);
        // Peer connection'ı remote description olarak ayarlıyoruz
        peerConnection!.setRemoteDescription(offer).then((_) {
          // Remote description ayarlandıktan sonra cevabı oluştur

          createAnswer(offer);
        }).catchError((e) {
          if (kDebugMode) {
            print("Error setting remote description: $e");
          }
        });
      }
    });

    // 'answer' olayını dinle
    socket.on('answer', (data) async {
      if (kDebugMode) {
        print('Received answer');
      }

      var answer = webrtc.RTCSessionDescription(
        data['sdp'], // SDP verisini al
        data['type'], // Offer veya Answer tipi
      );

      // Gelen "answer"ı remote description olarak ayarlıyoruz
      try {
        await peerConnection!.setRemoteDescription(answer);
      } catch (e) {
        if (kDebugMode) {
          print("Error setting remote description for answer: $e");
        }
      }
    });

    socket.on('candidate', (data) async {
      if (kDebugMode) {
        print('Received candidate: $data');
      }
      var candidate = webrtc.RTCIceCandidate(
        data['candidate'],
        data['sdpMid'],
        data['sdpMLineIndex'],
      );
      // Gelen candidate'ı peer connection'a ekliyoruz

      try {
        await peerConnection!.addCandidate(candidate);
      } catch (e) {
        if (kDebugMode) {
          print("Error adding candidate: $e");
        }
      }
    });

    //WEBRTC

    socket.on('signaling', (data) {
      // Signaling verilerini dinleme
      log('Signaling verisi alındı: $data');
    });

    socket.on('INCOMING_CALL', (data) {
      // Signaling verilerini dinleme

      log('Kullanıcı Seni Arıyor: ${data['callerId']}');

      isCallingMe.value = true;
      whichuserisCallingMe.value = data['callerId'];
    });

    socket.on('CALL_ACCEPTED', (data) {
      // Signaling verilerini dinleme
      log('Çağrı kabul edildi: $data');
    });

    socket.on('CALL_CLOSED', (data) {
      // Signaling verilerini dinleme
      log('Çağrı reddedildi: $data');
    });

    // Başka biri bağlandığında bildiri al
    socket.on('userConnected', (data) {
      if (data != null) {
        log(socketPREFIX + data.toString());
      }
      log(socketPREFIX + data.toString());
    });
    // Bağlantı başarılı olduğunda
    socket.on('connect', (data) {
      log('${socketPREFIX}Bağlandı');

      if (data != null) {
        log(socketPREFIX + data.toString());
      }
      socketChatStatus.value = true;

      // Kullanıcıyı kaydet
      registerUser(currentUserAccounts.value.user.value);
    });

    // Bağlantı kesildiğinde
    socket.on('disconnect', (data) {
      try {
        log('$socketPREFIX$data');
      } catch (e) {
        log('${socketPREFIX}Hata (disconnect): $e');
      }
      log('${socketPREFIX}Bağlantı kesildi');
      socketChatStatus.value = false;
    });

    // Sunucudan gelen mesajları dinleme
    socket.on('chat', (data) {
      ChatMessage chatData = ChatMessage.fromJson(data);

      log("$socketPREFIX${chatData.user.displayName} - ${chatData.messageContext}");

      currentUserAccounts.value.chatList ??= <Chat>[].obs;

      bool chatisthere = currentUserAccounts.value.chatList!.any(
        (chat) => chat.user.userID == chatData.user.userID,
      );

      ChatMessage chat = ChatMessage(
        messageID: 0,
        messageContext: chatData.messageContext,
        user: User(
          displayName: chatData.user.displayName,
          avatar: chatData.user.avatar,
        ),
        isMe: false,
      );
      if (!chatisthere) {
        currentUserAccounts.value.chatList!.add(
          Chat(
            user: chatData.user,
            chatNotification: false.obs,
            lastmessage: chat.obs,
            messages: <ChatMessage>[].obs,
            chatType: APIChat.ozel,
          ),
        );
      }

      Chat a = currentUserAccounts.value.chatList!.firstWhere(
        (chat) => chat.user.userID == chatData.user.userID,
      );

      a.messages ??= <ChatMessage>[].obs;
      a.messages!.add(chat);
      //Son mesajı görünümü güncelle
      a.lastmessage ??= Rx<ChatMessage>(chat);
      if (a.lastmessage != null) {
        a.lastmessage!.value = chat;
      }
      a.chatNotification = true.obs;
      currentUserAccounts.value.chatList!.refresh();
    });

    // Otomatik olarak bağlanma
    socket.connect();

    return this;
  }

// WEBRTC
  Future<void> createOffer() async {
    await webRTCinit();

    webrtc.RTCSessionDescription offer = await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);
    sendOffer(offer.toMap());
  }
// WEBRTC

  Future<void> createAnswer(webrtc.RTCSessionDescription offer) async {
    await peerConnection!.setRemoteDescription(offer);
    webrtc.RTCSessionDescription answer = await peerConnection!.createAnswer();
    await peerConnection!.setLocalDescription(answer);
    sendAnswer(answer.toMap());
  }

  // Socket.io ile mesaj gönderme
  void sendMessage(ChatMessage data, userID) {
    socket.emit("chat", {data.toJson(), userID});
  }

  // Socket.io birisini arama
  Future<void> callUser(User user) async {
    socket.emit("CALL_USER", {user.userName});
  }

  // Socket.io  arama reddetme
  void closecall(String username) {
    socket.emit("CLOSE_CALL", username);

    whichuserisCallingMe.value = "";
    isCallingMe.value = false;
  }

  // Socket.io  arama açma
  void acceptcall(String username) {
    socket.emit("ACCEPT_CALL", username);

    whichuserisCallingMe.value = "";
    isCallingMe.value = false;
  }

  //WEBRTC
  void sendOffer(dynamic offer) {
    socket.emit("offer", offer);
  }

  void sendAnswer(dynamic answer) {
    socket.emit("answer", answer);
  }

  void sendCandidate(dynamic candidate) {
    socket.emit("candidate", candidate);
  }
  //WEBRTC

  // Kullanıcıyı sunucuya kaydetme
  void registerUser(User user) {
    log("Kullanıcı Register Kaydı");
    socket.emit('REGISTER', {
      'name': user.userName?.value,
      'clientId': user.toJson(),
    });
  }

  void fetchUserList({int? groupID}) {
    // Sunucudan kullanıcı listesi isteme
    socket.emit('USER_LIST', {
      "groupID": groupID,
    });
  }

  void startPing(Duration interval) {
    pingTimer = Timer.periodic(interval, (timer) {
      pingID.value =
          "${DateTime.now().millisecondsSinceEpoch}-${currentUserAccounts.value.user.value.userID}";
      // log('Ping gönderiliyor... ID: ${pingID.value}');

      lastPingTime = DateTime.now();
      socket.emit('ping', {'id': pingID.value}); // ID ile ping gönder
    });
  }

  void stopPing() {
    // Timer durdurma (iptal etme)
    if (pingTimer != null) {
      pingTimer!.cancel();
      pingTimer = null;
    }
  }

  // void micOnOff(User user) {
  //   var speaker = user.speaker;
  //   var mic = user.microphone;
  //   mic.value = !mic.value;

  //   if (mic.value == true && speaker.value == false) {
  //     speaker.value = true;
  //   }

  //   userUpdate(user);
  // }

  // void speakerOnOff(User user) {
  //   var speaker = user.speaker;
  //   var mic = user.microphone;

  //   speaker.value = !speaker.value;

  //   mic.value = speaker.value;

  //   userUpdate(user);
  // }

  void userUpdate(User user) {
    try {
      log("Bilgiler Güncellendi");

      socket.emit('profileUpdate', user.toJson());
    } catch (e) {
      log("${socketPREFIX}Hata(changeRoom) $e");
    }
  }
}
