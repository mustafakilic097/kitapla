import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../cache/locale_manager.dart';

class LanguageManager extends Translations {
  static final LanguageManager _instance = LanguageManager();
  static LanguageManager get instance => _instance;
  LanguageManager();

  Locale get enLocale => const Locale("en", "US");
  Locale get trLocale => const Locale("tr", "TR");

  List<Locale> get supportedLocales => [enLocale, trLocale];

  Future<void> updateLocale(Locale locale) async {
    await Get.updateLocale(locale);
    await LocaleManager.instance.setStringValue("locale", locale.languageCode);
  }

  
  @override
  Map<String, Map<String, String>> get keys => {
    //Türkçe ve ingilizce desteği için key'lerin girilmesi
        'tr_TR': {
        },
        'en_US': {
        },
      };
}
