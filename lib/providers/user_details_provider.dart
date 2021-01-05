import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_app/models/user.dart';
import 'package:flutter_chat_app/utils/constants.dart';
import 'package:flutter_chat_app/utils/preference_utils.dart';
import 'package:flutter_chat_app/utils/string_utils.dart';

///
/// Created by  on 12/1/2020.
/// user_details_provider.dart :
///
class UserDetailsProvider {
  StorageReference firebaseStorageReference =
      FirebaseStorage.instance.ref().child(Constants.USER_PROFILE_DIR);
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> getCurrentUSerId() async {
    final user = await auth.currentUser();
    return user.uid;
  }

  void uploadProfileImageToFireStore(
      File imageFile, Function onSuccess, Function onFailure) async {
    var currentUserId = await getCurrentUSerId();

    var fileName = currentUserId;
    var profileStorageRef = firebaseStorageReference.child(fileName);

    var storageUploadTask = profileStorageRef.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot;

    await storageUploadTask.onComplete.then((value) {
      storageTaskSnapshot = value;
      storageTaskSnapshot.ref
          .getDownloadURL()
          .then((value) async => onSuccess(value), onError: onFailure);
    }, onError: onFailure);
  }

  Future<User> updateUserData(
      String imageUrl, String profileName, String userBio) async {
    var currentUserId = await getCurrentUSerId();
    User userData;

    await Firestore.instance
        .collection(Constants.USER_TABLE_NAME)
        .document(currentUserId)
        .updateData({
      Constants.USER_PHOTOURL: imageUrl,
      Constants.USER_NICKNAME: profileName.toLowerCase(),
      Constants.USER_ABOUTME: userBio,
      Constants.USER_NAME_CASE_SEARCH:
          StringUtils.setSearchParam(profileName.toLowerCase())
    }).then((data) async {
      await PreferenceUtils.setStringItem(
          Constants.USER_NICKNAME, profileName.toLowerCase());
      await PreferenceUtils.setStringItem(Constants.USER_PHOTOURL, imageUrl);
      await PreferenceUtils.setStringItem(Constants.USER_ABOUTME, userBio);
      userData = await PreferenceUtils.getUserDetailsFromPreference();
    }, onError: (errorMessage) {
      userData = null;
    });

    return userData;
  }

  ///fetch lists of users, matching the string provided
  ///[stringQuery] : String query to search in the nickName field
  Future<QuerySnapshot> fetchUsersFromStringQuery(String stringQuery) async {
    var query = stringQuery.toLowerCase();
    var allUsers = await Firestore.instance
        .collection(Constants.USER_TABLE_NAME)
        //.where(Constants.USER_NAME_CASE_SEARCH, arrayContains: stringQuery.toLowerCase())
        .where(
          Constants.USER_NICKNAME,
          isGreaterThanOrEqualTo: query,
          isLessThan: query.substring(0, query.length - 1) +
              String.fromCharCode(
                  query.codeUnitAt(query.length - 1) + 1),
        )
        .getDocuments();

    return allUsers;
  }


  ///Get user from user id string
  ///[userId] : String user id
  Future<User> getUserFromId(String userId) async{
    var snapshot = await Firestore.instance
        .collection(Constants.USER_TABLE_NAME).document(userId).get();

    return User.fromMap(snapshot.data);
  }
}
