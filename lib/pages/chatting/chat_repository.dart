import 'dart:io';

import 'package:flutter_chat_app/providers/chat_data_provider.dart';

///
/// Created by Amit Kumar Sahoo (amit.sahoo@mindfiresolutions.com)
/// on 17-12-2020.
/// chat_repository.dart :
///
class ChatRepo {
  final ChatDataProvider _chatDataProvider = ChatDataProvider();

  void uploadChatImage(File imageFile, Function onSuccess, Function onFailure, Function progressUpdate){
    return _chatDataProvider.uploadChatImageToFireStore(imageFile, onSuccess, onFailure, progressUpdate);
  }
}