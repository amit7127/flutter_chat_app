import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/generated/l10n.dart';
import 'package:flutter_chat_app/models/CommonResponse.dart';
import 'package:flutter_chat_app/models/User.dart';
import 'package:flutter_chat_app/models/message.dart';
import 'package:flutter_chat_app/pages/chatting/chat_repository.dart';
import 'package:flutter_chat_app/utils/AppBloc.dart';
import 'package:rxdart/rxdart.dart';

///
/// Created by  on 12/11/2020.
/// chatting_page_bloc.dart :
///
class ChatPageBloc implements AppBlock {
  final ChatRepo _repo = ChatRepo();

  final BehaviorSubject<bool> _isStickerEnabled = BehaviorSubject<bool>();
  final BehaviorSubject<CommonsResponse<String>> _imageUploadTask =
      BehaviorSubject<CommonsResponse<String>>();
  final BehaviorSubject<CommonsResponse<bool>> _isMessageSent =
      BehaviorSubject<CommonsResponse<bool>>();
  final BehaviorSubject<List<Message>> _messageList =
      BehaviorSubject<List<Message>>();

  ChatPageBloc() {
    _isStickerEnabled.add(false);
  }

  BehaviorSubject<bool> get isStickerEnabled => _isStickerEnabled;

  BehaviorSubject<CommonsResponse<String>> get imageUploadTask =>
      _imageUploadTask;

  BehaviorSubject<CommonsResponse<bool>> get isMessageSent => _isMessageSent;

  BehaviorSubject<List<Message>> get messageList => _messageList;

  void toggleStickerView() {
    _isStickerEnabled.add(!_isStickerEnabled.value);
  }

  ///upload image for message
  ///[imageFile] :
  void uploadChatImage(File imageFile, BuildContext context) {
    _imageUploadTask.add(
        CommonsResponse.loading(S.of(context).chat_image_upload_wait_message));

    _repo.uploadChatImage(
        imageFile,
        (imageUrl) => _imageUploadTask.add(CommonsResponse.completed(imageUrl,
            message: S.of(context).chat_image_upload_success_message)),
        (errorMessage) =>
            _imageUploadTask.add(CommonsResponse.error(errorMessage)),
        (double progress) => _imageUploadTask.add(CommonsResponse.loading(
            S.of(context).image_uploading_progress(progress.round()))));
  }

  /// Send chat message
  /// [message] : Message object
  /// [receiver] : User object
  /// [sender] : Sender User object
  /// [context] : BuildContext
  void sendChatMessage(
      Message message, User sender, User receiver, BuildContext context) {
    _isMessageSent
        .add(CommonsResponse.loading(S.of(context).message_sending_wait));
    _repo.sendMessage(
        message,
        sender,
        receiver,
        () => _isMessageSent.add(CommonsResponse.completed(true,
            message: S.of(context).message_sent_success)),
        (error) => CommonsResponse.error(S.of(context).message_sent_failed));
  }

  ///Get message list
  ///[otherUserId] : String user id of other party
  ///[currentUserId] : String current user id
  ///[context] : BuildContext
  void getMessageList(
      String otherUserId, String currentUserId, BuildContext context) async {
    var chatDocumentList =
        await _repo.getMessageList(otherUserId, currentUserId);
    if (chatDocumentList != null) {
      await _messageList.addStream(chatDocumentList);
    } else {
      _messageList.addError(S.of(context).chat_message_fetch_error);
    }
  }

  @override
  void dispose() {
    _isStickerEnabled.close();
    _imageUploadTask.close();
    _isMessageSent.close();
  }
}
