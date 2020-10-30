import 'package:flutter_chat_app/utils/Constants.dart';

class User {
  String _id;
  String _nickname;
  String _photoUrl;
  String _createdAt;
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

  String get createdAt => _createdAt;

  set createdAt(String value) {
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

  // User.toDataSnapshot(DocumentSnapshot snapshot) {
  //   User(
  //     snapshot.documentID,
  //     snapshot['photoUrl'],
  //     snapshot['nickname'],
  //     snapshot['createdAt'],
  //   );
  //}

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();

    map[Constants.USER_ID] = this._id;
    map[Constants.USER_NICKNAME] = this._nickname;
    map[Constants.USER_PHOTOURL] = this._photoUrl;
    map[Constants.USER_CREATEDAT] = this._createdAt;
    map[Constants.USER_ABOUTME] = this._aboutMe;
    //map[Constants.USER_CHATTINGWITH] = this._chattingWith;

    return map;
  }

  User.fromMap(Map<String, dynamic> map){
    this._id = map[Constants.USER_ID];
    this._nickname = map[Constants.USER_NICKNAME];
    this._photoUrl = map[Constants.USER_PHOTOURL];
    this._createdAt = map[Constants.USER_CREATEDAT];
    this._aboutMe = map[Constants.USER_ABOUTME];

    map[Constants.USER_CHATTINGWITH];
  }
}
