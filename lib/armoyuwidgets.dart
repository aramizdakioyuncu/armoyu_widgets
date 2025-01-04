import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/data/services/socketio.dart';
import 'package:armoyu_widgets/sources/chat/views/chat_widget.dart';
import 'package:armoyu_widgets/sources/elevatedbutton.dart';
import 'package:armoyu_widgets/sources/mention.dart';
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
  late final AccountUserController accountController;
  late final SocketioController socketIO;

  ARMOYUWidgets({required this.service}) {
    elevatedButton = ARMOYUElevatedButton();
    textField = ARMOYUTextfields(service);
    mention = ARMOYUMention(service);
    searchBar = ARMOYUSearchBar(service);
    social = SocialWidget(service);
    chat = ChatWidget(service);

    accountController = Get.put(AccountUserController(), permanent: true);

    socketIO = Get.put(SocketioController(), permanent: true);
  }
}
