import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/generated/l10n.dart';
import 'package:flutter_chat_app/models/CommonResponse.dart';
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
  final BehaviorSubject<CommonsResponse<bool>> _isMessageSent = BehaviorSubject<CommonsResponse<bool>>();
  final BehaviorSubject<List<Message>> _messageList = BehaviorSubject<List<Message>>();

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

  void sendChatMessage(Message message) {
    _isMessageSent.add(CommonsResponse.loading('Message sending'));
    _repo.sendMessage(message, () => _isMessageSent.add(CommonsResponse.completed(true, message: 'Message sent')),
        (error) => CommonsResponse.error('Message sending failed'));
  }

  void getMessageList(String otherUserId, String currentUserId) async{
    var chatDocumentList = await _repo.getMessageList(otherUserId, currentUserId);
    if(chatDocumentList != null){
      await _messageList.addStream(chatDocumentList);
    } else {
      _messageList.addError('Unable to fetch.');
    }
  }

  @override
  void dispose() {
    _isStickerEnabled.close();
    _imageUploadTask.close();
    _isMessageSent.close();
  }
}
