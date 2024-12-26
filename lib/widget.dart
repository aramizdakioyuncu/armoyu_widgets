import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/sources/elevatedbutton.dart';
import 'package:armoyu_widgets/sources/mention.dart';
import 'package:armoyu_widgets/sources/posts/views/post_view.dart';
import 'package:armoyu_widgets/sources/searchbar/searchbar.dart';
import 'package:armoyu_widgets/sources/textfield.dart';
import 'package:get/get.dart';

class ARMOYUWidget {
  final ARMOYUServices service;

  late final ARMOYUElevatedButton elevatedButton;
  late final ARMOYUTextfields textField;
  late final ARMOYUMention mention;
  late final ARMOYUSearchBar searchBar;
  late final TwitterPostWidget social;
  late final AccountUserController accountController;

  ARMOYUWidget({required this.service}) {
    elevatedButton = ARMOYUElevatedButton();
    textField = ARMOYUTextfields(service);
    mention = ARMOYUMention(service);
    searchBar = ARMOYUSearchBar(service);
    social = TwitterPostWidget(service);

    accountController = Get.put(AccountUserController(), permanent: true);
  }
}
