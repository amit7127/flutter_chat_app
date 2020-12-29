import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/models/message.dart';
import 'package:flutter_chat_app/utils/Constants.dart';

import 'User.dart';

///
/// Created by Amit Kumar Sahoo (amit.sahoo@mindfiresolutions.com)
/// on 28-12-2020.
/// ChatHistory.dart :
///
class ChatHistory {
  String _userId;
  String _userName;
  String _userPhotoUrl;
  String _lastMessage;
  FieldValue _timeStamp;
  Timestamp _timeStampFromServer;

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  String get userPhotoUrl => _userPhotoUrl;

  set userPhotoUrl(String value) {
    _userPhotoUrl = value;
  }

  String get lastMessage => _lastMessage;

  set lastMessage(String value) {
    _lastMessage = value;
  }

  FieldValue get timeStamp => _timeStamp;

  set timeStamp(FieldValue value) {
    _timeStamp = value;
  }

  Timestamp get timeStampFromServer => _timeStampFromServer;

  set timeStampFromServer(Timestamp value) {
    _timeStampFromServer = value;
  }

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
  }

  ChatHistory.fromMessage(Message message, User user) {
    _userId = user.id;
    _lastMessage = message.message;
    _userPhotoUrl = user.photoUrl;
    _timeStamp = message.timeStamp;
    _userName = user.nickname;
  }

  Map<String, dynamic> toMap() {
    return {
      Constants.MESSAGE_HISTORY_USER_ID: _userId,
      Constants.MESSAGE_HISTORY_LAST_MESSAGE: _lastMessage,
      Constants.MESSAGE_HISTORY_TIME_STAMP: _timeStamp,
      Constants.MESSAGE_HISTORY_PROFILE_PICTURE: _userPhotoUrl,
      Constants.MESSAGE_HISTORY_USER_NAME: _userName
    };
  }

  ChatHistory.fromMap(Map<String, dynamic> map) {
    _userId = map[Constants.MESSAGE_HISTORY_USER_ID];
    _lastMessage = map[Constants.MESSAGE_HISTORY_LAST_MESSAGE];
    _timeStampFromServer = map[Constants.MESSAGE_HISTORY_TIME_STAMP];
    _userPhotoUrl = map[Constants.MESSAGE_HISTORY_PROFILE_PICTURE];
    _userName = map[Constants.MESSAGE_HISTORY_USER_NAME];
  }
}
