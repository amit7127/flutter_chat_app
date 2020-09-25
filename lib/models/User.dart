import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String _id;
  String _nickname;
  String _photoUrl;
  String _createdAt;

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

  User(this._id, this._nickname, this._photoUrl, this._createdAt);

  // User.toDataSnapshot(DocumentSnapshot snapshot) {
  //   User(
  //     snapshot.documentID,
  //     snapshot['photoUrl'],
  //     snapshot['nickname'],
  //     snapshot['createdAt'],
  //   );
  //}
}
