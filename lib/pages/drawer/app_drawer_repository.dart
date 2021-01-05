import 'package:flutter_chat_app/models/user.dart';
import 'package:flutter_chat_app/providers/login_data_provider.dart';
import 'package:flutter_chat_app/utils/preference_utils.dart';

///
/// Created by Amit Kumar Sahoo (amit.sahoo@mindfiresolutions.com)
/// on 28-12-2020.
/// app_drawer_repository.dart :
///
class AppDrawerRepo {
  final LoginProvider _loginProvider = LoginProvider();

  ///Get user details from the device storage
  Future<User> getSavedUserDataFromDevice() {
    return PreferenceUtils.getUserDetailsFromPreference();
  }

  ///Provides method for logout user
  Future<bool> logoutUser() {
    return _loginProvider.signOutUser();
  }
}
