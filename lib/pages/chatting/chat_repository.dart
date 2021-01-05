import 'dart:io';

import 'package:flutter_chat_app/models/message.dart';
import 'package:flutter_chat_app/models/user.dart';
import 'package:flutter_chat_app/providers/chat_data_provider.dart';

///
/// Created by Amit Kumar Sahoo (amit.sahoo@mindfiresolutions.com)
/// on 17-12-2020.
/// chat_repository.dart : Chat data repository for chatting page
///
class ChatRepo {
  final ChatDataProvider _chatDataProvider = ChatDataProvider();

  ///Upload image
  ///[imageFile] : File object
  ///[onSuccess] : (String filePath) { //body }
  ///[onFailure] : (String errorMessage) { //body }
  ///[progressUpdate] : (double progressPercentage) { //body }
  void uploadChatImage(File imageFile, Function onSuccess, Function onFailure,
      Function progressUpdate) {
    return _chatDataProvider.uploadChatImageToFireStore(
        imageFile, onSuccess, onFailure, progressUpdate);
  }

  ///Send message to DB
  ///[message] : Message Object
  ///[sender] : User
  ///[receiver] : User
  ///[onSuccess] : () { //body }
  ///[onError] : (String errorMessage) { //body }
  void sendMessage(Message message, User sender, User receiver,
      Function onSuccess, Function onError) {
    return _chatDataProvider.sendMessage(
        message, sender, receiver, onSuccess, onError);
  }

  ///Get messages list for sender and receiver
  ///[otherUserId] : String
  ///[currentUserId] : String
  Stream<List<Message>> getMessageList(
      String otherUserId, String currentUserId) {
    return _chatDataProvider.getChatList(otherUserId, currentUserId);
  }
}
