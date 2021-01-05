import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/generated/l10n.dart';
import 'package:flutter_chat_app/models/common_response.dart';
import 'package:flutter_chat_app/models/user.dart';
import 'package:flutter_chat_app/utils/app_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'settings_repository.dart';

///
/// Created by  on 11/23/2020.
/// settings_bloc.dart : To Provide data related to settings page
///

class SettingsBloc extends AppBlock {
  final BuildContext _context;
  final SettingsRepo _settingsRepo = SettingsRepo();

  final BehaviorSubject<User> _userData = BehaviorSubject<User>();
  final BehaviorSubject<CommonsResponse<String>> _imageUploadTask =
      BehaviorSubject<CommonsResponse<String>>();
  final BehaviorSubject<CommonsResponse<User>> _userUpdate =
      BehaviorSubject<CommonsResponse<User>>();

  BehaviorSubject<User> get userData => _userData;

  BehaviorSubject<CommonsResponse<String>> get imageUploadTask =>
      _imageUploadTask;

  BehaviorSubject<CommonsResponse<User>> get userUpdate => _userUpdate;

  ///Constructor accepting context for multi lang support
  SettingsBloc(this._context);

  ///get user data from Preferences
  void getUserDataFromDevice() async {
    var userData = await _settingsRepo.getSavedUserDataFromDevice();
    _userData.add(userData);
  }

  ///upload image to firebase storage
  ///[imageFile] : File(dart.io) to upload
  void uploadProfileImage(File imageFile) {
    _imageUploadTask.add(
        CommonsResponse.loading(S.of(_context).uploading_image_message_text));

    _settingsRepo.uploadImage(
        imageFile,
        (imageUrl) => _imageUploadTask.add(CommonsResponse.completed(imageUrl,
            message: S.of(_context).profile_image_upload_success_message)),
        (errorMessage) => _imageUploadTask.add(errorMessage));
  }

  ///update user data in fireStore
  ///[imageUrl] : image url string
  ///[profileName] : String profile name to change
  ///[userBio] : String user bio
  void updateUserData(
      String imageUrl, String profileName, String userBio) async {
    _userUpdate
        .add(CommonsResponse.loading(S.of(_context).user_info_update_message));

    var user =
        await _settingsRepo.updateUserData(imageUrl, profileName, userBio);
    if (user != null) {
      _userUpdate.add(CommonsResponse.completed(user,
          message: S.of(_context).user_info_update_success_message));
    } else {
      _userUpdate.add(CommonsResponse.error(
          S.of(_context).user_info_update_failed_message));
    }
  }

  @override
  void dispose() {
    _userData?.close();
    _imageUploadTask.close();
    _userUpdate.close();
  }
}
