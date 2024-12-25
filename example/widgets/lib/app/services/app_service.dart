import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/widget.dart';

class AppService {
  static ARMOYUServices service = ARMOYUServices(
    apiKey: "",
    usePreviousAPI: true,
  );
  static ARMOYUWidget widgets = ARMOYUWidget(service: service);
}
