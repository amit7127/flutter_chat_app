import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/utils/Constants.dart';

///
/// Created by Amit Kumar Sahoo (amit.sahoo@mindfiresolutions.com)
/// on 18-12-2020.
/// message.dart : Message model
///

class Message {
  String _messageId;
  String _senderId;
  String _receiverId;
  String _message;
  int _messageType;
  FieldValue _timeStamp;

  Message(this._senderId, this._receiverId, this._message, this._messageType);

  String get messageId => _messageId;

  set messageId(String value) {
    _messageId = value;
  }

  String get senderId => _senderId;

  set senderId(String value) {
    _senderId = value;
  }

  String get receiverId => _receiverId;

  set receiverId(String value) {
    _receiverId = value;
  }

  String get message => _message;

  set message(String value) {
    _message = value;
  }

  int get messageType => _messageType;

  set messageType(int value) {
    _messageType = value;
  }

  FieldValue get timeStamp => _timeStamp;

  set timeStamp(FieldValue value) {
    _timeStamp = value;
  }

  Message.fromMap(Map<String, dynamic> map) {
    _messageId = map[Constants.MESSAGE_ID];
    _senderId = map[Constants.MESSAGE_SENDER_ID];
    _receiverId = map[Constants.MESSAGE_RECEIVER_ID];
    _message = map[Constants.MESSAGE_TEXT];
    _messageType = map[Constants.MESSAGE_TYPE];
    _timeStamp = map[Constants.MESSAGE_TIMESTAMP];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map[Constants.MESSAGE_ID] = _messageId;
    map[Constants.MESSAGE_SENDER_ID] = _senderId;
    map[Constants.MESSAGE_RECEIVER_ID] = _receiverId;
    map[Constants.MESSAGE_TEXT] = _message;
    map[Constants.MESSAGE_TYPE] = _messageType;
    map[Constants.MESSAGE_TIMESTAMP] = _timeStamp;

    return map;
  }
}
