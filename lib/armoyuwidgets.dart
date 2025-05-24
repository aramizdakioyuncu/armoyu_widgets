import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/data/services/socketio.dart';
import 'package:armoyu_widgets/sources/card/widgets/card_widget.dart';
import 'package:armoyu_widgets/sources/chat/widgets/chat_widget.dart';
import 'package:armoyu_widgets/sources/elevatedbutton.dart';
import 'package:armoyu_widgets/sources/gallery/widgets/gallery_widget.dart';
import 'package:armoyu_widgets/sources/mention.dart';
import 'package:armoyu_widgets/sources/news/widgets/news_widget.dart';
import 'package:armoyu_widgets/sources/notifications/widgets/notifications_widget.dart';
import 'package:armoyu_widgets/sources/players/widgets/players_widget.dart';
import 'package:armoyu_widgets/sources/reels/widgets/reels_widget.dart';
import 'package:armoyu_widgets/sources/social/widgets/social_widget.dart';
import 'package:armoyu_widgets/sources/searchbar/searchbar.dart';
import 'package:armoyu_widgets/sources/textfield.dart';
import 'package:get/get.dart';

class ARMOYUWidgets {
  final ARMOYUServices service;

  late final ARMOYUElevatedButton elevatedButton;
  late final ARMOYUTextfields textField;
  late final ARMOYUMention mention;
  late final ARMOYUSearchBar searchBar;
  late final SocialWidget social;
  late final ChatWidget chat;
  late final GalleryWidget gallery;
  late final CardWidget cards;
  late final NewsWidget news;
  late final NotificationsWidget notifications;

  late final PlayersWidget players;
  late final ReelsWidget reels;

  late final AccountUserController accountController;
  late final SocketioController socketIO;

  ARMOYUWidgets({required this.service}) {
    elevatedButton = ARMOYUElevatedButton();
    textField = ARMOYUTextfields(service);
    mention = ARMOYUMention(service);
    searchBar = ARMOYUSearchBar(service);
    social = SocialWidget(service);
    chat = ChatWidget(service);
    gallery = GalleryWidget(service);
    cards = CardWidget(service);
    news = NewsWidget(service);
    notifications = NotificationsWidget(service);
    players = PlayersWidget(service);
    reels = ReelsWidget(service);

    accountController = Get.put(AccountUserController(), permanent: true);

    socketIO = Get.put(SocketioController(), permanent: true);
  }

  Future<bool> setup() async {
    log("ARMOYU Widget initalized");
    return true;
  }
}
