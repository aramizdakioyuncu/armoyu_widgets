import 'package:armoyu_widgets/data/models/ARMOYU/province.dart';

class Country {
  final int countryID;
  String name;
  String countryCode;
  int phoneCode;
  List<Province>? provinceList;

  Country({
    required this.countryID,
    required this.name,
    required this.countryCode,
    required this.phoneCode,
    this.provinceList,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      countryID: json['countryID'],
      name: json['name'],
      countryCode: json['countryCode'],
      phoneCode: json['phoneCode'],
      provinceList: json['provinceList'] != null
          ? (json['provinceList'] as List<dynamic>?)
              ?.map((friendJson) => Province.fromJson(friendJson))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'countryID': countryID,
      'name': name,
      'countryCode': countryCode,
      'phoneCode': phoneCode,
      'provinceList':
          provinceList?.map((province) => province.toJson()).toList(),
    };
  }
}
