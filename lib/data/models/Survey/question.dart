import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';

class SurveyQuestion {
  String questionValue;
  List<Media>? questionImages;

  SurveyQuestion({
    required this.questionValue,
    this.questionImages,
  });
}
