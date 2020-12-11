import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/HomeAppBar.dart';

///
/// Created by  on 12/11/2020.
/// chatting_page.dart : 
///
class ChatPage extends StatelessWidget{
  final String receiverId;
  final String receiverName;
  final String receiverProfilePic;

  ChatPage(this.receiverId, this.receiverName, this.receiverProfilePic);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatScreenAppbar(receiverName, profileImageUrl: receiverProfilePic),
    );
  }
}
