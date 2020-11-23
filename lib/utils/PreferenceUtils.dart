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
    String userId = await getStringItem(Constants.USER_ID);
    String nickName = await getStringItem(Constants.USER_NICKNAME);
    String photoUrl = await getStringItem(Constants.USER_PHOTOURL);
    String aboutMe = await getStringItem(Constants.USER_ABOUTME);

    User user = User(userId, nickName, photoUrl, aboutMe);
    return user;
  }

  static Future<Set<String>> getAllKeys() async {
    final SharedPreferences prefs = await _prefs;

    return prefs.getKeys();
  }
}
