import 'package:armoyu_services/armoyu_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';

class ARMOYUTextfields {
  final ARMOYUServices service;

  ARMOYUTextfields(this.service);

  Widget costum3({
    Key? key,
    String? title,
    required TextEditingController controller,
    required Function(String val)? onChanged,
    bool isPassword = false,
    String? placeholder,
    Icon? preicon,
    IconButton? suffixiconbutton,
    TextInputType? type,
    Function? onTap,
    int? maxLength,
    int? minLength,
    bool? enabled = true,
    int? maxLines,
    int? minLines = 1,
    FocusNode? focusNode,
  }) {
    if (minLines != null) {
      maxLines = minLines + 5;
    }

    if (title != null && placeholder == null) {
      placeholder = title;
    }

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onTap: () {
            if (onTap == null) {
              return;
            }
            onTap();
          },
          onChanged: (value) {
            if (onChanged != null) {
              onChanged(value);
            }

            if (!isPassword && maxLength != null) {
              if (value.length >= maxLength) {
                return;
              }
            }
          },
          focusNode: focusNode,
          enabled: enabled,
          controller: controller,
          obscureText: isPassword,
          minLines: minLines,
          maxLines: !isPassword ? maxLines : 1,
          maxLength: maxLength,
          keyboardType: type,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.username],
          decoration: InputDecoration(
            labelText: title,
            contentPadding: const EdgeInsets.all(16.0),
            suffixIcon: suffixiconbutton,
            counter: minLength != null || maxLength != null
                ? minLength != null && controller.value.text.length < minLength
                    ? Text(
                        "${controller.value.text.length}/$maxLength",
                        style: TextStyle(
                          color: controller.value.text.length < minLength
                              ? Colors.red
                              : Colors.grey,
                        ),
                      )
                    : maxLength != null
                        ? Text(
                            "${controller.value.text.length}/${controller.value.text.length >= maxLength ? maxLength : maxLength}",
                            style: TextStyle(
                              color: controller.value.text.length == maxLength
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                          )
                        : null
                : null,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide.none,
            ),
            prefixIcon: preicon,
            hintText: placeholder,
            filled: true,
          ),
        ),
      ],
    );
  }

  // FlutterMentions mentionTextFiled({
  //   required GlobalKey<FlutterMentionsState> key,
  //   required double height,
  //   required String hinttext,
  //   Color? suggestionlistColor,
  //   int? minLines = 1,
  //   // required User currentUser,
  //   Timer? searchTimer,
  //   required Function(String val)? onChanged,
  // }) {
  //   return FlutterMentions(
  //     key: key,
  //     suggestionPosition: SuggestionPosition.Top,
  //     maxLines: 20,
  //     minLines: minLines,
  //     // suggestionListDecoration: BoxDecoration(color: Get.theme.cardColor),
  //     suggestionListDecoration: BoxDecoration(color: suggestionlistColor),
  //     // suggestionListHeight: Get.height / 3,
  //     suggestionListHeight: height,
  //     onChanged: (value) {
  //       List<String> words = value.split(' ');
  //       final String lastWord = words.isNotEmpty ? words.last : "";

  //       if (lastWord.isEmpty) {
  //         // Eğer son kelime boşsa, mevcut sorguyu iptal eder
  //         searchTimer?.cancel();
  //         return;
  //       }

  //       //Oyuncu listesi bomboşsa
  //       if (service.peopleList.isEmpty) {
  //         searchTimer = Timer(const Duration(milliseconds: 500), () async {
  //           Map<String, dynamic> response =
  //               await service.searchServices.onlyusers(searchword: "", page: 1);

  //           // SearchAPI f = SearchAPI(currentUser: currentUser);
  //           // Map<String, dynamic> response =
  //           //     await f.onlyusers(searchword: "", page: 1);
  //           if (response["durum"] == 0) {
  //             log(response["aciklama"]);
  //             return;
  //           }
  //           for (var element in response["icerik"]) {
  //             service.addpeopleList({
  //               'id': element["ID"].toString(),
  //               'display': element["username"].toString(),
  //               'full_name': element["Value"].toString(),
  //               'photo': element["avatar"].toString()
  //             });
  //           }
  //           // key.refresh();
  //         });
  //       }
  //       //Hashtag listesi bomboşsa
  //       if (service.hashtagList.isEmpty) {
  //         searchTimer = Timer(const Duration(milliseconds: 500), () async {
  //           // SearchAPI f = SearchAPI(currentUser: currentUser);
  //           // Map<String, dynamic> response =
  //           //     await f.hashtag(hashtag: "", page: 1);

  //           Map<String, dynamic> response =
  //               await service.searchServices.hashtag(hashtag: "", page: 1);

  //           if (response["durum"] == 0) {
  //             log(response["aciklama"]);
  //             return;
  //           }
  //           for (var element in response["icerik"]) {
  //             service.addhashtagList({
  //               'id': element["hashtag_ID"].toString(),
  //               'display': element["hashtag_value"].toString(),
  //               'numberofuses': element["hashtag_numberofuses"],
  //             });
  //           }
  //           // key.refresh();
  //         });
  //       }

  //       if (lastWord.length <= 3) {
  //         return;
  //       }

  //       if (lastWord[0] != "@" && lastWord[0] != "#") {
  //         // Eğer son kelime @ veya # ile başlamıyorsa, mevcut sorguyu iptal eder
  //         searchTimer?.cancel();
  //         return;
  //       }

  //       // Eğer buraya kadar gelindi ise, yeni bir kelime girilmiştir, mevcut sorguyu iptal eder
  //       searchTimer?.cancel();
  //       searchTimer = Timer(const Duration(milliseconds: 500), () async {
  //         // SearchAPI f = SearchAPI(currentUser: currentUser);

  //         Map<String, dynamic> response;
  //         if (lastWord[0] == "@") {
  //           // response = await f.onlyusers(searchword: lastWord.substring(1), page: 1);

  //           response = await service.searchServices
  //               .onlyusers(searchword: lastWord.substring(1), page: 1);
  //         } else if (lastWord[0] == "#") {
  //           // response = await f.hashtag(hashtag: lastWord.substring(1), page: 1);

  //           response = await service.searchServices
  //               .hashtag(hashtag: lastWord.substring(1), page: 1);
  //         } else {
  //           return;
  //         }

  //         if (response["durum"] == 0) {
  //           log(response["aciklama"]);
  //           return;
  //         }
  //         for (var element in response["icerik"]) {
  //           if (lastWord[0] == "@") {
  //             service.addpeopleList({
  //               'id': element["ID"].toString(),
  //               'display': element["username"].toString(),
  //               'full_name': element["Value"].toString(),
  //               'photo': element["avatar"].toString()
  //             });
  //           }
  //           if (lastWord[0] == "#") {
  //             service.addhashtagList({
  //               'id': element["hashtag_ID"].toString(),
  //               'display': element["hashtag_value"].toString(),
  //               'numberofuses': element["hashtag_numberofuses"],
  //             });
  //           }
  //         }

  //         key.refresh();
  //       });
  //     },
  //     // decoration: InputDecoration(hintText: SocialKeys.socialwritesomething.tr),
  //     decoration: InputDecoration(hintText: hinttext),
  //     mentions: [
  //       ARMOYUMention.poplementions(),
  //       ARMOYUMention.hashtag(),
  //     ],
  //   );
  // }

  TextField number({
    String? placeholder,
    required TextEditingController controller,
    required int length,
    required Icon icon,
    String? category,
  }) {
    List<TextInputFormatter>? formatter;
    if (category.toString() == "phoneNumber") {
      length = 15;
      formatter = [MaskedInputFormatter('(###) ### ## ##')];
    }

    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      maxLength: length,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.username],
      style: const TextStyle(color: Colors.white),
      inputFormatters: formatter,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(8.0),
        counterText: "", //Limiti gizler
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide.none,
        ),
        prefixIcon: icon,
        prefixIconColor: Colors.white,
        hintText: placeholder,

        filled: true,
      ),
    );
  }
}
