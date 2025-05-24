import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:media_kit/media_kit.dart';
import 'package:widgets/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Video
  MediaKit.ensureInitialized();

  runApp(
    Portal(
      child: const MyApp(),
    ),
  );
}
