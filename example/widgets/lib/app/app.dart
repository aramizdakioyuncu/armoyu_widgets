import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/app/routes/app_route.dart';
import 'package:widgets/app/themes/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: appLightThemeData,
      darkTheme: appDarkThemeData,
      themeMode: ThemeMode.dark,
      initialRoute: AppRoute.initial,
      getPages: AppRoute.routes,
    );
  }
}
