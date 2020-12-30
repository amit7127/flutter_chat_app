import 'package:flutter_chat_app/models/ChatHistory.dart';
import 'package:flutter_chat_app/models/User.dart';
import 'package:flutter_chat_app/providers/UserDetailsProvider.dart';
import 'package:flutter_chat_app/providers/chat_data_provider.dart';
import 'package:flutter_chat_app/utils/PreferenceUtils.dart';

///
/// Created by Amit Kumar Sahoo (amit.sahoo@mindfiresolutions.com)
/// on 24-12-2020.
/// home_chat_repository.dart :
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

  Future<User> getUser(String userId){
    return _userDetailsProvider.getUserFromId(userId);
  }
}
