import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/models/User.dart';
import 'package:flutter_chat_app/models/message.dart';
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

  void sendMessage(Message message, User sender, User receiver, Function onSuccess, Function onError){
    return _chatDataProvider.sendMessage(message, sender, receiver, onSuccess, onError);
  }

  Stream<List<Message>> getMessageList(String otherUserId, String currentUserId){
    return _chatDataProvider.getChatList(otherUserId, currentUserId);
  }
}