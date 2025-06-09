import 'package:armoyu_widgets/data/models/Chat/chat.dart';
import 'package:armoyu_widgets/sources/chat/bundle/chat_bundle.dart';
import 'package:armoyu_widgets/sources/chat/controllers/newchatlist_controller.dart';
import 'package:armoyu_widgets/widgetsv2/chat/chat_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

ChatWidgetBundle widgetNewList(
  BuildContext context,
  service, {
  required Function(Chat chat) onPressed,
  List<Chat>? cachedChatList,
  Function(List<Chat> updatedChat)? onChatUpdated,
}) {
  final controller = Get.put(
    SourceNewchatlistController(
      service,
      cachedChatList,
      onChatUpdated,
    ),
  );
  Widget widget = Obx(
    () => controller.filteredchatList.value == null
        ? const Center(
            child: CupertinoActivityIndicator(),
          )
        : Column(
            children: List.generate(
              controller.filteredchatList.value!.length,
              (index) {
                return Obx(
                  () => ChatWidgetv2.listtilechat(
                    context,
                    chat: controller.filteredchatList.value![index],
                    onPressed: onPressed,
                    onDelete: () {
                      controller.filteredchatList.value!.removeWhere(
                        (element) =>
                            element.user.userID ==
                            controller
                                .filteredchatList.value![index].user.userID,
                      );
                      controller.filteredchatList.refresh();
                    },
                  ),
                );
              },
            ),
          ),
  );

  return ChatWidgetBundle(
    widget: Rxn(widget),
    refresh: () async => await controller.refreshAllChatList(),
    loadMore: () async => await controller.loadMoreChatList(),
    filterList: (String text) => controller.filterList(text),
  );
}
