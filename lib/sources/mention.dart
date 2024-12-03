import 'dart:async';

import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/search/search_hashtaglist.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/search/search_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';

class ARMOYUMention {
  final ARMOYUServices service;

  ARMOYUMention(this.service);

  FlutterMentions mentionTextFiled({
    required GlobalKey<FlutterMentionsState> key,
    required double height,
    required String hinttext,
    required Function(String val)? onChanged,
    Color? suggestionlistColor,
    int? minLines = 1,
    // required User currentUser,
    Timer? searchTimer,
  }) {
    return FlutterMentions(
      key: key,
      suggestionPosition: SuggestionPosition.Top,
      maxLines: 20,
      minLines: minLines,
      // suggestionListDecoration: BoxDecoration(color: Get.theme.cardColor),
      suggestionListDecoration: BoxDecoration(color: suggestionlistColor),
      // suggestionListHeight: Get.height / 3,
      suggestionListHeight: height,
      onChanged: (value) {
        List<String> words = value.split(' ');
        final String lastWord = words.isNotEmpty ? words.last : "";

        if (lastWord.isEmpty) {
          // Eğer son kelime boşsa, mevcut sorguyu iptal eder
          searchTimer?.cancel();
          return;
        }

        //Oyuncu listesi bomboşsa
        if (service.peopleList.isEmpty) {
          searchTimer = Timer(const Duration(milliseconds: 500), () async {
            SearchListResponse response =
                await service.searchServices.onlyusers(searchword: "", page: 1);

            if (response.result.status == false) {
              log(response.result.description);
              return;
            }

            for (APISearchDetail element in response.response!.search) {
              service.addpeopleList(
                newPerson: APISearchDetail(
                  id: element.id,
                  value: element.value,
                  turu: element.turu,
                  username: element.username,
                  avatar: element.avatar,
                  gender: element.gender,
                ),
              );
            }
            // key.refresh();
          });
        }
        //Hashtag listesi bomboşsa
        if (service.hashtagList.isEmpty) {
          searchTimer = Timer(const Duration(milliseconds: 500), () async {
            SearchHashtagListResponse response =
                await service.searchServices.hashtag(hashtag: "", page: 1);

            if (response.result.status == false) {
              log(response.result.description);
              return;
            }

            for (APISearcHashtagDetail element in response.response!.search) {
              service.addhashtagList(
                newHashtag: APISearcHashtagDetail(
                  hashtagID: element.hashtagID,
                  value: element.value,
                  firstdate: element.firstdate,
                  numberofuses: element.numberofuses,
                ),
              );
            }
            // key.refresh();
          });
        }

        if (lastWord.length <= 3) {
          return;
        }

        if (lastWord[0] != "@" && lastWord[0] != "#") {
          // Eğer son kelime @ veya # ile başlamıyorsa, mevcut sorguyu iptal eder
          searchTimer?.cancel();
          return;
        }

        // Eğer buraya kadar gelindi ise, yeni bir kelime girilmiştir, mevcut sorguyu iptal eder
        searchTimer?.cancel();
        searchTimer = Timer(const Duration(milliseconds: 500), () async {
          // SearchAPI f = SearchAPI(currentUser: currentUser);

          if (lastWord[0] == "@") {
            SearchListResponse response = await service.searchServices
                .onlyusers(searchword: lastWord.substring(1), page: 1);

            if (response.result.status == false) {
              log(response.result.description);
              return;
            }
            for (APISearchDetail element in response.response!.search) {
              if (lastWord[0] == "@") {
                service.addpeopleList(newPerson: element);
              }
            }
          } else if (lastWord[0] == "#") {
            SearchHashtagListResponse response = await service.searchServices
                .hashtag(hashtag: lastWord.substring(1), page: 1);

            if (response.result.status == false) {
              log(response.result.description);
              return;
            }
            for (APISearcHashtagDetail element in response.response!.search) {
              if (lastWord[0] == "#") {
                service.addhashtagList(newHashtag: element);
              }
            }
          } else {
            return;
          }

          // key.refresh();
        });
      },
      decoration: InputDecoration(hintText: hinttext),
      mentions: [
        poplementions(peopleList: service.peopleList),
        hashtag(hashtagList: service.hashtagList),
      ],
    );
  }

  Mention poplementions(
      {required List<APISearchDetail> peopleList, Color? textcolor}) {
    return Mention(
      trigger: '@',
      style: const TextStyle(color: Colors.amber),
      data: peopleList.map((people) => people.toJson()).toList(),
      matchAll: false,
      suggestionBuilder: (data) {
        return Material(
          child: ListTile(
            contentPadding: const EdgeInsets.all(0),
            enableFeedback: true,
            leading: CircleAvatar(
              foregroundImage: CachedNetworkImageProvider(data['photo']),
            ),
            title: Text(data['full_name']),
            subtitle: Text(
              "@${data['display']}",
              style: TextStyle(
                color: textcolor,
              ),
            ),
          ),
        );
      },
    );
  }

  Mention hashtag(
      {required List<APISearcHashtagDetail> hashtagList, Color? textcolor}) {
    return Mention(
      trigger: '#',
      style: const TextStyle(color: Colors.blue),
      data: hashtagList.map((hashtag) => hashtag.toJson()).toList(),
      matchAll: false,
      suggestionBuilder: (data) {
        return ListTile(
          title: Text("#${data['display']} (${data["numberofuses"]})"),
          subtitle: Text(
            "Gündemdekiler",
            style: TextStyle(
              color: textcolor,
            ),
          ),
        );
      },
    );
  }
}
