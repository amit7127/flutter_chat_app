import 'dart:async';

import 'package:flutter_chat_app/models/user.dart';
import 'package:flutter_chat_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  PreferenceUtils._();

  static final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  /// ----------------------------------------------------------
  /// Generic routine to fetch an application preference
  /// ----------------------------------------------------------
  static Future<String> getStringItem(String name) async {
    final prefs = await _prefs;

    return prefs.getString(name) ?? '';
  }

  /// ----------------------------------------------------------
  /// Generic routine to saves an application preference
  /// ----------------------------------------------------------
  static Future<bool> setStringItem(String name, String value) async {
    final prefs = await _prefs;

    return prefs.setString(name, value);
  }

  ///save user details in the device preference
  ///[user] : User model to store data
  /// Returns boolean value after successfully data stored
  static Future<bool> saveUserDetailsPreference(User user) async {
    await setStringItem(Constants.USER_ID, user.id);
    await setStringItem(Constants.USER_NICKNAME, user.nickname);
    await setStringItem(Constants.USER_PHOTOURL, user.photoUrl);
    return await setStringItem(Constants.USER_ABOUTME, user.aboutMe);
  }

  ///Get user details from device preferences
  static Future<User> getUserDetailsFromPreference() async {
    var userId = await getStringItem(Constants.USER_ID);
    var nickName = await getStringItem(Constants.USER_NICKNAME);
    var photoUrl = await getStringItem(Constants.USER_PHOTOURL);
    var aboutMe = await getStringItem(Constants.USER_ABOUTME);

    var user = User(userId, nickName, photoUrl, aboutMe);
    return user;
  }

  static Future<Set<String>> getAllKeys() async {
    final prefs = await _prefs;

    return prefs.getKeys();
  }
}
