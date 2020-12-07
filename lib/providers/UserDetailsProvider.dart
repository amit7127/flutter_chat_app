import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_app/models/User.dart';
import 'package:flutter_chat_app/utils/Constants.dart';
import 'package:flutter_chat_app/utils/PreferenceUtils.dart';

///
/// Created by  on 12/1/2020.
/// UserDetailsProvider.dart :
///
class UserDetailsProvider {
  StorageReference firebaseStorageReference =
      FirebaseStorage.instance.ref().child('profile');
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> getCurrentUSerId() async {
    final FirebaseUser user = await auth.currentUser();
    return user.uid;
  }

  void uploadProfileImageToFireStore(
      File imageFile, Function onSuccess, Function onFailure) async {
    String currentUserId = await getCurrentUSerId();

    String fileName = currentUserId;
    StorageReference profileStorageRef =
        firebaseStorageReference.child(fileName);

    StorageUploadTask storageUploadTask = profileStorageRef.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot;

    storageUploadTask.onComplete.then((value) {
      storageTaskSnapshot = value;
      storageTaskSnapshot.ref
          .getDownloadURL()
          .then((value) async => onSuccess(value), onError: onFailure);
    }, onError: onFailure);
  }

  Future<User> updateUserData(
      String imageUrl, String profileName, String userBio) async {
    String currentUserId = await getCurrentUSerId();
    User userData;

    await Firestore.instance
        .collection('user')
        .document(currentUserId)
        .updateData({
      'photoUrl': imageUrl,
      'nickname': profileName,
      'aboutMe': userBio
    }).then((data) async {
      await PreferenceUtils.setStringItem(Constants.USER_NICKNAME, profileName);
      await PreferenceUtils.setStringItem(Constants.USER_PHOTOURL, imageUrl);
      await PreferenceUtils.setStringItem(Constants.USER_ABOUTME, userBio);
      userData = await PreferenceUtils.getUserDetailsFromPreference();
    }, onError: (errorMessage) {
      userData = null;
    });

    return userData;
  }
}
