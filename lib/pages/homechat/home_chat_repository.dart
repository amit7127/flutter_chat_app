import 'package:flutter_chat_app/models/ChatHistory.dart';
import 'package:flutter_chat_app/providers/chat_data_provider.dart';

///
/// Created by Amit Kumar Sahoo (amit.sahoo@mindfiresolutions.com)
/// on 24-12-2020.
/// home_chat_repository.dart :
///
class ChatHistoryRepository {
  final ChatDataProvider _chatDataProvider = ChatDataProvider();

  Future<Stream<List<ChatHistory>>> getChatHistory() {
    return _chatDataProvider.getChatHistory();
  }
}
