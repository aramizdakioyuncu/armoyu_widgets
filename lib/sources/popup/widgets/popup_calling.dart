import 'package:flutter/material.dart';
import 'package:get/get.dart';

widgetPopupCalling({
  required String callerName,
  required String callerAvatarUrl,
  required VoidCallback onAccept,
  required VoidCallback onDecline,
}) {
  Get.defaultDialog(
    title: "Gelen Arama",
    titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    backgroundColor: Colors.grey.shade800,
    barrierDismissible: false, // Kullanıcı dışarı tıklayarak kapatamasın
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(callerAvatarUrl),
        ),
        const SizedBox(height: 10),
        Text(
          callerName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Aramayı Kabul Etme Butonu
            ElevatedButton.icon(
              onPressed: () {
                Get.back(); // Popup'ı kapat
                onAccept(); // Kabul fonksiyonunu çağır
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              icon: const Icon(Icons.call),
              label: const Text("Aç"),
            ),
            // Aramayı Reddetme Butonu
            ElevatedButton.icon(
              onPressed: () {
                Get.back(); // Popup'ı kapat
                onDecline(); // Reddetme fonksiyonunu çağır
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              icon: const Icon(Icons.call_end),
              label: const Text("Reddet"),
            ),
          ],
        ),
      ],
    ),
  );
}
