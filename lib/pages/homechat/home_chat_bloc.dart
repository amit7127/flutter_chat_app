import 'package:flutter/material.dart';
import 'package:flutter_chat_app/generated/l10n.dart';
import 'package:flutter_chat_app/models/ChatHistory.dart';
import 'package:flutter_chat_app/models/CommonResponse.dart';
import 'package:flutter_chat_app/models/User.dart';
import 'package:flutter_chat_app/utils/AppBloc.dart';
import 'package:rxdart/rxdart.dart';

import 'home_chat_repository.dart';

///
/// Created by Amit Kumar Sahoo (amit.sahoo@mindfiresolutions.com)
/// on 24-12-2020.
/// home_chat_bloc.dart :
///
class HomeChatBloc extends AppBlock {
  final ChatHistoryRepository _repo = ChatHistoryRepository();

  final BehaviorSubject<List<ChatHistory>> _chatList =
      BehaviorSubject<List<ChatHistory>>();
  final BehaviorSubject<CommonsResponse<List<User>>> _users =
      BehaviorSubject<CommonsResponse<List<User>>>();

  BehaviorSubject<List<ChatHistory>> get chatList => _chatList;

  BehaviorSubject<CommonsResponse<List<User>>> get users => _users;

  void getChatHistory(BuildContext context) async {
    var chatHistoryList = await _repo.getChatHistory();
    if (chatHistoryList != null) {
      await _chatList.addStream(chatHistoryList);
    } else {
      _chatList.addError(S.of(context).chat_message_fetch_error);
    }
  }

  void getUsers(String userId, BuildContext context) async {
    _users.add(CommonsResponse.loading(S.of(context).user_fetching_dialog));
    var currentUser = await _repo.getSavedUserDataFromDevice();
    var otherUser = await _repo.getUser(userId);

    if (currentUser != null && otherUser != null) {
      _users.add(CommonsResponse.completed([currentUser, otherUser],
          message: S.of(context).user_details_fetch_success));
    } else {
      _users
          .add(CommonsResponse.error(S.of(context).user_details_fetch_failed));
    }
  }

  @override
  void dispose() {
    _chatList.close();
  }
}
