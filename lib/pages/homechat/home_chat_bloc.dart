import 'package:flutter_chat_app/models/ChatHistory.dart';
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

  BehaviorSubject<List<ChatHistory>> get chatList => _chatList;

  void getChatHistory() async {
    var chatHistoryList = await _repo.getChatHistory();
    if (chatHistoryList != null) {
      await _chatList.addStream(chatHistoryList);
    } else {
      _chatList.addError('Unable to fetch.');
    }
  }

  @override
  void dispose() {
    _chatList.close();
  }
}
