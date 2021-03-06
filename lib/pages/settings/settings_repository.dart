import 'dart:io';

import 'package:flutter_chat_app/models/user.dart';
import 'package:flutter_chat_app/providers/user_details_provider.dart';
import 'package:flutter_chat_app/utils/preference_utils.dart';

///
/// Created by  on 11/23/2020.
/// settings_repository.dart : Provides data for settings page
///
class SettingsRepo {
  final UserDetailsProvider _userDetailsProvider = UserDetailsProvider();

  ///Get user details from the device storage
  Future<User> getSavedUserDataFromDevice() {
    return PreferenceUtils.getUserDetailsFromPreference();
  }

  ///Upload user profile image
  void uploadImage(File imageFile, Function onSuccess, Function onFailure) {
    return _userDetailsProvider.uploadProfileImageToFireStore(imageFile, onSuccess, onFailure);
  }

  ///Update userdata in fireStore and Preferences
  Future<User> updateUserData(String imageUrl, String profileName, String userBio){
    return _userDetailsProvider.updateUserData(imageUrl, profileName, userBio);
  }
}
