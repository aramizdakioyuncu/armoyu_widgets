import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/armoyuwidgets.dart';

class AppService {
  static ARMOYUServices service = ARMOYUServices(
    apiKey: "",
    usePreviousAPI: true,
  );
  static ARMOYUWidgets widgets = ARMOYUWidgets(service: service);
}
