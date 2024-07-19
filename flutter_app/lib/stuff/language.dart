import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// for changing the languages
LanguageSetting languageSetting = LanguageSetting();

enum Language { german, english }

class LanguageSetting {
  static Language _selectedLanguage = Language.german;

  void setLanguage(Language newLanguage, BuildContext context) {
    _selectedLanguage = newLanguage;

    if (newLanguage == Language.german) {
      EasyLocalization.of(context).locale = Locale('de', 'DE');
    } else if (newLanguage == Language.english) {
      EasyLocalization.of(context).locale = Locale('en', 'US');
    }
  }

  static Language get selectedLanguage {
    return _selectedLanguage;
  }
}
