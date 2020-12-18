import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_app/models/message.dart';
import 'package:flutter_chat_app/utils/Constants.dart';
import 'package:flutter_chat_app/utils/StringUtils.dart';

///
/// Created by Amit Kumar Sahoo (amit.sahoo@mindfiresolutions.com)
/// on 17-12-2020.
/// chat_data_provider.dart :
///
class ChatDataProvider {
  StorageReference firebaseStorageReference =
  FirebaseStorage.instance.ref().child(Constants.CHAT_IMAGE_DIR);
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> getCurrentUSerId() async {
    final user = await auth.currentUser();
    return user.uid;
  }

  void uploadChatImageToFireStore(
      File imageFile, Function onSuccess, Function onFailure, Function progressUpdate) async {

    var fileName = DateTime.now().millisecondsSinceEpoch.toString();

    var chatImageRef = firebaseStorageReference.child(fileName);

    var storageUploadTask = chatImageRef.putFile(imageFile);
    storageUploadTask.events.listen((event) {
      var _progress = event.snapshot.bytesTransferred.toDouble() /
          event.snapshot.totalByteCount.toDouble() * 100;
      progressUpdate(_progress);
    }).onError((error) {
      onFailure(error);
    });

    await storageUploadTask.onComplete.then((snapshot) {
      snapshot.ref.getDownloadURL().then((url) {
        onSuccess(url);
      });
    });
  }

  ///Send message
  void sendMessage(Message message, Function onSuccess, Function onError) async{
    message.senderId = await getCurrentUSerId();
    var chatRoomId = StringUtils.getChatRoomId([message.senderId, message.receiverId]);
    var docRef = await Firestore.instance.collection(Constants.MESSAGE_TABLE_NAME).document(chatRoomId);

    message.messageId = DateTime.now().millisecondsSinceEpoch.toString();
    message.timeStamp = FieldValue.serverTimestamp();

    await docRef.collection(docRef.documentID)
        .document(message.messageId)
        .setData(message.toMap()).then((value) {
      onSuccess();
    }, onError: (e) => onError(e));
  }
}