import 'package:flutter_chat_app/models/chat_history.dart';
import 'package:flutter_chat_app/models/user.dart';
import 'package:flutter_chat_app/providers/chat_data_provider.dart';
import 'package:flutter_chat_app/providers/user_details_provider.dart';
import 'package:flutter_chat_app/utils/preference_utils.dart';

///
/// Created by Amit Kumar Sahoo (amit.sahoo@mindfiresolutions.com)
/// on 24-12-2020.
/// home_chat_repository.dart : chat data repo
///
class ChatHistoryRepository {
  final ChatDataProvider _chatDataProvider = ChatDataProvider();
  final UserDetailsProvider _userDetailsProvider = UserDetailsProvider();

  Future<Stream<List<ChatHistory>>> getChatHistory() {
    return _chatDataProvider.getChatHistory();
  }

  ///Get user details from the device storage
  Future<User> getSavedUserDataFromDevice() {
    return PreferenceUtils.getUserDetailsFromPreference();
  }

  ///Get user details from user id
  ///[userId] : String userId
  Future<User> getUser(String userId) {
    return _userDetailsProvider.getUserFromId(userId);
  }
}
