import 'package:get/get.dart';
import 'package:widgets/app/modules/chat/views/chat_view.dart';
import 'package:widgets/app/modules/chat/views/chatcall_view.dart';
import 'package:widgets/app/modules/chat/views/chatdetail_view.dart';
import 'package:widgets/app/routes/app_route.dart';

class ChatModule {
  static const route = Routes.CHAT;

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const ChatView(),
    ),
    GetPage(
      name: "$route/detail",
      page: () => const ChatdetailView(),
    ),
    GetPage(
      name: "$route/call",
      page: () => const ChatcallView(),
    ),
  ];
}
