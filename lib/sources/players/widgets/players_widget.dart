import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/sources/players/bundle/musiclist_bundle.dart';
import 'package:armoyu_widgets/sources/players/bundle/musicplayer_bundle.dart';
import 'package:armoyu_widgets/sources/players/widgets/players_advenced.dart';
import 'package:armoyu_widgets/sources/players/widgets/players_advencedlist.dart';
import 'package:armoyu_widgets/sources/players/widgets/players_music.dart';
import 'package:flutter/material.dart';

class PlayersWidget {
  final ARMOYUServices service;

  const PlayersWidget(this.service);

  PlayerWidgetBundle advencedPlayer(
    BuildContext context, {
    Color sliderColor = Colors.white,
    Color buttonColor = Colors.white,
    List<Color> bgColors = const [
      Color.fromARGB(255, 0, 119, 255),
      Color.fromARGB(255, 3, 152, 238),
      Color.fromARGB(255, 0, 132, 255),
      Color.fromARGB(255, 7, 62, 158),
    ],
  }) {
    return widgetPlayerAdvenced(
      context,
      service,
      bgColors: bgColors,
      buttonColor: buttonColor,
      sliderColor: sliderColor,
    );
  }

  MusiclistWidgetBundle advencedPlayerlist(
    BuildContext context, {
    Color buttonColor = Colors.white,
    Color? bgColors = Colors.black12,
  }) {
    return widgetPlayerAdvencedlist(
      context,
      service,
      bgColors: bgColors,
      buttonColor: buttonColor,
    );
  }

  PlayerWidgetBundle musicplayer() {
    return widgetPlayerMusic(service);
  }
}
