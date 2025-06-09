import 'package:armoyu_widgets/sources/popup/widgets/popup_calling.dart';
import 'package:flutter/material.dart';

class PopupWidget {
  static void showIncomingCallDialog({
    required String callerName,
    required String callerAvatarUrl,
    required VoidCallback onAccept,
    required VoidCallback onDecline,
  }) {
    widgetPopupCalling(
      callerName: callerName,
      callerAvatarUrl: callerAvatarUrl,
      onAccept: onAccept,
      onDecline: onDecline,
    );
  }
}
