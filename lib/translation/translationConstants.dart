import 'package:farreco/translation/demoLocalization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//calling translation method
String getTranslated(BuildContext context, String key) {
  var obj = DemoLocalization.of(context);
  return DemoLocalization.of(context).translate(key);
}

//langauge codes
const String ENGLISH = 'en';
const String TELUGU = 'te';

const String LANGUAGE_CODE = 'languageCode';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LANGUAGE_CODE, languageCode);

  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return Locale(languageCode, 'US');
      break;
    case TELUGU:
      return Locale(languageCode, 'IN');
      break;
    default:
      return Locale(ENGLISH, 'US');
  }
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LANGUAGE_CODE) ?? ENGLISH;
  return _locale(languageCode);
}
