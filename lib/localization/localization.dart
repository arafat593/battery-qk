import 'package:batteryqk_web_app/localization/arabic.dart';
import 'package:batteryqk_web_app/localization/eng.dart';
import 'package:get/get.dart';

class Language extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': eng,
    'ar_AE': arabic,
  };
}