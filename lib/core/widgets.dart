import 'dart:io';

import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/translations/app_translation.dart';
import 'package:armoyu_widgets/widgets/text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';

class ARMOYUWidget {
  final ARMOYUServices service;
  List<Map<String, String>> content;
  final bool firstFetch;

  ARMOYUWidget({
    required this.content,
    required this.firstFetch,
    required this.service,
  });

  static void stackbarNotification(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        content: Text(
          text,
          textAlign: TextAlign.center,
        ),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }

  static void toastNotification(String text) {
    if (Platform.isWindows) {
      // For Windows, we can use a simple print statement or a custom dialog
      if (kDebugMode) {
        print(text);
      }
      stackbarNotification(
        Get.context!,
        text,
      );
      return;
    }

    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      fontSize: 14.0,
    );
  }

  static void showConfirmationDialog(BuildContext context,
      {required Function accept, Function? decline, String? question}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          title: CustomText.costum1(QuestionKeys.areyousure.tr),
          content:
              CustomText.costum1(question ?? QuestionKeys.areyousuredetail.tr),
          actions: <Widget>[
            TextButton(
              child: CustomText.costum1(CommonKeys.cancel.tr),
              onPressed: () {
                if (decline != null) {
                  decline();
                }
                Get.back();
              },
            ),
            TextButton(
              child: CustomText.costum1(CommonKeys.accept.tr),
              onPressed: () {
                accept();

                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}
