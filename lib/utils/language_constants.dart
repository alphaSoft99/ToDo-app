import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'translations.dart';

const String LAGUAGE_CODE = 'languageCode';

//languages code
const String RUSSIAN = 'ru';
const String UZB = 'uz';
const String ENGLISH = 'en';


// functions

String localisedString(BuildContext context, String key) =>
    Translations.of(context).text(key);

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LAGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LAGUAGE_CODE) ?? "ru";
  return _locale(languageCode);
}

Future<String> getLanguage() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LAGUAGE_CODE) ?? "ru";
  return languageCode;
}

// ignore: missing_return
Locale _locale(String languageCode) {
  switch (languageCode) {
    case RUSSIAN:
      return Locale(RUSSIAN, '');
    case UZB:
      return Locale(UZB, "");
    case ENGLISH:
      return Locale(ENGLISH, "");
  }
}