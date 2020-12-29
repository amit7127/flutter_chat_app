import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/utils/Constants.dart';

class User {
  String _id;
  String _nickname;
  String _photoUrl;
  Timestamp _createdAt;
  String _aboutMe;
  List<String> _chattingWith;

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get nickname => _nickname;

  set nickname(String value) {
    _nickname = value;
  }

  String get photoUrl => _photoUrl;

  set photoUrl(String value) {
    _photoUrl = value;
  }

  Timestamp get createdAt => _createdAt;

  set createdAt(Timestamp value) {
    _createdAt = value;
  }

  String get aboutMe => _aboutMe;

  set aboutMe(String value) {
    _aboutMe = value;
  }

  List<String> get chattingWith => _chattingWith;

  // set chattingWith(List<String> value) {
  //   _chattingWith = value;
  // }

  User(this._id, this._nickname, this._photoUrl, [this._aboutMe, this._createdAt,
      this._chattingWith]);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map[Constants.USER_ID] = _id;
    map[Constants.USER_NICKNAME] = _nickname;
    map[Constants.USER_PHOTOURL] = _photoUrl;
    map[Constants.USER_CREATEDAT] = _createdAt;
    map[Constants.USER_ABOUTME] = _aboutMe;
    //map[Constants.USER_CHATTINGWITH] = this._chattingWith;

    return map;
  }

  User.fromMap(Map<String, dynamic> map){
    _id = map[Constants.USER_ID];
    _nickname = map[Constants.USER_NICKNAME];
    _photoUrl = map[Constants.USER_PHOTOURL];
    _createdAt = map[Constants.USER_CREATEDAT];
    _aboutMe = map[Constants.USER_ABOUTME];

    map[Constants.USER_CHATTINGWITH];
  }
}
