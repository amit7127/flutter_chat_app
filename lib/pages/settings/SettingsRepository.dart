import 'package:flutter_chat_app/models/User.dart';
import 'package:flutter_chat_app/utils/PreferenceUtils.dart';

///
/// Created by  on 11/23/2020.
/// SettingsRepository.dart : Provides data for settings page
///
class SettingsRepo{

  ///Get user details from the device storage
  Future<User> getSavedUserDataFromDevice(){
    return PreferenceUtils.getUserDetailsFromPreference();
  }
}