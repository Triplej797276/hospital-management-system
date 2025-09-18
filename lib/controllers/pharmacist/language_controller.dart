import 'package:get/get.dart';

enum Language { english, marathi, hindi }

class LanguageController extends GetxController {
  var selectedLanguage = Language.english.obs;

  void changeLanguage(Language lang) {
    selectedLanguage.value = lang;
  }

  String getText({required String en, required String mr, required String hi}) {
    switch (selectedLanguage.value) {
      case Language.marathi:
        return mr;
      case Language.hindi:
        return hi;
      case Language.english:
      default:
        return en;
    }
  }
}
