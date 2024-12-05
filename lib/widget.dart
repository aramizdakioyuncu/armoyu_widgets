import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/sources/elevatedbutton.dart';
import 'package:armoyu_widgets/sources/mention.dart';
import 'package:armoyu_widgets/sources/searchbar/searchbar.dart';
import 'package:armoyu_widgets/sources/textfield.dart';

class ARMOYUWidget {
  final ARMOYUServices service;
  late final ARMOYUElevatedButton elevatedButton = ARMOYUElevatedButton();
  late final ARMOYUTextfields textField = ARMOYUTextfields(service);
  late final ARMOYUMention mention = ARMOYUMention(service);
  late final ARMOYUSearchBar searchBar = ARMOYUSearchBar(service);
  ARMOYUWidget({required this.service});
}
