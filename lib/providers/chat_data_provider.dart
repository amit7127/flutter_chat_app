import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_app/models/ChatHistory.dart';
import 'package:flutter_chat_app/models/User.dart';
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

  void uploadChatImageToFireStore(File imageFile, Function onSuccess,
      Function onFailure, Function progressUpdate) async {
    var fileName = DateTime.now().millisecondsSinceEpoch.toString();

    var chatImageRef = firebaseStorageReference.child(fileName);

    var storageUploadTask = chatImageRef.putFile(imageFile);
    storageUploadTask.events.listen((event) {
      var _progress = event.snapshot.bytesTransferred.toDouble() /
          event.snapshot.totalByteCount.toDouble() *
          100;
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
  void sendMessage(
      Message message, User sender, User receiver, Function onSuccess, Function onError) async {
    message.senderId = await getCurrentUSerId();
    var chatRoomId =
        StringUtils.getChatRoomId([message.senderId, message.receiverId]);
    var messageDocRef = await Firestore.instance
        .collection(Constants.MESSAGE_TABLE_NAME)
        .document(chatRoomId);
    var userDocRef =
        await Firestore.instance.collection(Constants.USER_TABLE_NAME);

    message.messageId = DateTime.now().millisecondsSinceEpoch.toString();
    message.timeStamp = FieldValue.serverTimestamp();

    await messageDocRef
        .collection(messageDocRef.documentID)
        .document(message.messageId)
        .setData(message.toMap())
        .then((value) {
      onSuccess();
    }, onError: (e) => onError(e));

    var senderChatHistory = ChatHistory.fromMessage(message, receiver);
    var receiverChatHistory = ChatHistory.fromMessage(message, sender);

    await userDocRef
        .document(message.senderId)
        .collection(Constants.USER_CHATTINGWITH)
        .document(message.receiverId)
        .setData(senderChatHistory.toMap());
    await userDocRef
        .document(message.receiverId)
        .collection(Constants.USER_CHATTINGWITH)
        .document(message.senderId)
        .setData(receiverChatHistory.toMap());
  }

  Stream<List<Message>> getChatList(String otherUserId, String currentUserId) {
    var chatRoomId = StringUtils.getChatRoomId([currentUserId, otherUserId]);

    var snapShots = Firestore.instance
        .collection(Constants.MESSAGE_TABLE_NAME)
        .document(chatRoomId)
        .collection(chatRoomId)
        .orderBy(Constants.MESSAGE_TIMESTAMP, descending: true)
        .snapshots()
        .map((snapShot) => snapShot.documents
            .map((message) => Message.fromMap(message.data))
            .toList());

    return snapShots;
  }

  Future<Stream<List<ChatHistory>>> getChatHistory() async{
    var currentUserId = await getCurrentUSerId();

    return Firestore.instance
        .collection(Constants.USER_TABLE_NAME)
        .document(currentUserId)
        .collection(Constants.USER_CHATTINGWITH)
        .snapshots()
        .map((snapShot) => snapShot.documents.map((map) => ChatHistory.fromMap(map.data)).toList());
  }
}
