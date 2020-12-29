import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/models/User.dart';
import 'package:flutter_chat_app/providers/UserDetailsProvider.dart';
import 'package:flutter_chat_app/utils/PreferenceUtils.dart';

///
/// Created by  on 12/7/2020.
/// search_user_repository.dart :
///
class SearchRepository {
  final UserDetailsProvider _userDetailsProvider = UserDetailsProvider();

  ///Get user details from the device storage
  Future<User> getSavedUserDataFromDevice() {
    return PreferenceUtils.getUserDetailsFromPreference();
  }

  Future<String> getCurrentUserIdFromPreference() async {
    var user = await PreferenceUtils.getUserDetailsFromPreference();
    return user.id;
  }

  ///Get users list from string name
  Future<QuerySnapshot> getListOfUsersFromString(String stringQuery) {
    return _userDetailsProvider.fetchUsersFromStringQuery(stringQuery);
  }
}
