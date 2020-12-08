import 'package:flutter_chat_app/models/User.dart';
import 'package:flutter_chat_app/utils/PreferenceUtils.dart';

///
/// Created by  on 12/7/2020.
/// HomeRepsitory.dart : 
///
class HomeRepository{
  ///Get user details from the device storage
  Future<User> getSavedUserDataFromDevice() {
    return PreferenceUtils.getUserDetailsFromPreference();
  }
}