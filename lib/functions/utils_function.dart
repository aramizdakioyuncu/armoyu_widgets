import 'package:get/get.dart';

class UtilsFunction {
  static int calculatePageNumber<T>(
      {required Rxn<List<T>> cardList, int itemsPerPage = 10}) {
    cardList.value ??= [];

    // Şu anki içerik sayısını alıyoruz
    int currentContentCount = cardList.value!.length;

    // Sayfa numarasını içerik sayısına göre hesaplıyoruz
    return (currentContentCount / itemsPerPage).ceil() + 1;
  }
}
