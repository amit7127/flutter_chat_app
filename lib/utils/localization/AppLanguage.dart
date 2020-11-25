import 'package:flutter/material.dart';
import 'package:flutter_chat_app/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
/// Created by  on 11/23/2020.
/// Language :
///
class AppLanguage extends ChangeNotifier {
  Locale _appLocale = Locale(Constants.LANGUAGE_CODE_ENGLISH);

  Locale get appLocal => _appLocale ?? Locale(Constants.LANGUAGE_CODE_ENGLISH);

  fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString(Constants.LOCAL_LANGUAGE) == null) {
      _appLocale = Locale(Constants.LANGUAGE_CODE_ENGLISH);
      return Null;
    }
    _appLocale = Locale(prefs.getString(Constants.LOCAL_LANGUAGE));
    return Null;
  }

  void changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();
    if (_appLocale == type) {
      return;
    }
    if (type == Locale(Constants.LANGUAGE_CODE_ARABIC)) {
      _appLocale = Locale(Constants.LANGUAGE_CODE_ARABIC);
      await prefs.setString(
          Constants.LOCAL_LANGUAGE, Constants.LANGUAGE_CODE_ARABIC);
      await prefs.setString(
          Constants.LANGUAGE_COUNTRY_CODE, Constants.LANGUAGE_COUNTRY_ARABIC);
    } else {
      _appLocale = Locale(Constants.LANGUAGE_CODE_ENGLISH);
      await prefs.setString(
          Constants.LOCAL_LANGUAGE, Constants.LANGUAGE_CODE_ENGLISH);
      await prefs.setString(
          Constants.LANGUAGE_COUNTRY_CODE, Constants.LANGUAGE_COUNTRY_ENGLISH);
    }
    notifyListeners();
  }
}
