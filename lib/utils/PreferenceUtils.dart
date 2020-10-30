import 'dart:async';

import 'package:flutter_chat_app/models/User.dart';
import 'package:flutter_chat_app/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  PreferenceUtils._();

  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  /// ----------------------------------------------------------
  /// Generic routine to fetch an application preference
  /// ----------------------------------------------------------
  static Future<String> getStringItem(String name) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.getString(name) ?? '';
  }

  /// ----------------------------------------------------------
  /// Generic routine to saves an application preference
  /// ----------------------------------------------------------
  static Future<bool> setStringItem(String name, String value) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.setString(name, value);
  }

  static Future<bool> saveUserDetailsPreference(User user) async{
    await setStringItem(Constants.USER_ID, user.id);
    await setStringItem(Constants.USER_NICKNAME, user.nickname);
    await setStringItem(Constants.USER_PHOTOURL, user.photoUrl);
    return await setStringItem(Constants.USER_ABOUTME, user.aboutMe);
  }

  static Future<Set<String>> getAllKeys() async {
    final SharedPreferences prefs = await _prefs;

    return prefs.getKeys();
  }
}
