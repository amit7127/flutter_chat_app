import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/generated/l10n.dart';
import 'package:flutter_chat_app/models/CommonResponse.dart';
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

  ChatPageBloc() {
    _isStickerEnabled.add(false);
  }

  BehaviorSubject<bool> get isStickerEnabled => _isStickerEnabled;

  BehaviorSubject<CommonsResponse<String>> get imageUploadTask =>
      _imageUploadTask;

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

  @override
  void dispose() {
    _isStickerEnabled.close();
    _imageUploadTask.close();
  }
}
