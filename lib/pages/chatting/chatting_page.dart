import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/CommonResponse.dart';
import 'package:flutter_chat_app/models/User.dart';
import 'package:flutter_chat_app/models/message.dart';
import 'package:flutter_chat_app/utils/Constants.dart';
import 'package:flutter_chat_app/utils/ScaleConfig.dart';
import 'package:flutter_chat_app/widgets/HomeAppBar.dart';
import 'package:flutter_chat_app/widgets/emoji_selector_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'chatting_page_bloc.dart';

///
/// Created by  on 12/11/2020.
/// chatting_page.dart :
///
class ChatPage extends StatelessWidget {
  final User receiver;
  final User sender;

  ChatPage(this.receiver, this.sender);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatScreenAppbar(receiver.nickname,
          profileImageUrl: receiver.photoUrl),
      body: ChatListScreen(
        receiver: receiver,
        sender: sender,
      ),
    );
  }
}

class ChatListScreen extends StatefulWidget {
  final User receiver;
  final User sender;

  ChatListScreen({Key key, @required this.receiver, @required this.sender});

  @override
  State<StatefulWidget> createState() {
    return ChatListState();
  }
}

class ChatListState extends State<ChatListScreen> {
  final TextEditingController messageEditingController =
      TextEditingController();
  final FocusNode focusNode = FocusNode();
  ChatPageBloc _bloc;
  AlertDialog loader;

  @override
  void initState() {
    _bloc = ChatPageBloc();
    _bloc.getMessageList(widget.receiver.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    initializeLoader(context);

    return WillPopScope(
      onWillPop: () => onBackPress(),
      child: Stack(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/chat_background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  //Message list
                  listMessages(),

                  //Emoji Layout
                  emojiLayout(),

                  //Send message layout
                  sendMessageLayout()
                ],
              )
              )
        ],
      ),
    );
  }

  ///Emoji layout to send message
  Widget emojiLayout() {
    return StreamBuilder<bool>(
        stream: _bloc.isStickerEnabled,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshots) {
          if (snapshots.hasData) {
            return snapshots.data
                ? EmojiStickerSelector(onEmojiSelect: onEmojiMessageSelected)
                : Container();
          } else {
            return Container();
          }
        });
  }

  void onEmojiMessageSelected(String emoji) {
    sendMessage(emoji, Constants.EMOJI_MESSAGE_TYPE);
    _bloc.toggleStickerView();
  }

  void initializeLoader(BuildContext context) {
    // set up the AlertDialog
    loader = AlertDialog(
      content: StreamBuilder<CommonsResponse<String>>(
          stream: _bloc.imageUploadTask,
          builder: (BuildContext context,
              AsyncSnapshot<CommonsResponse<String>> snapshots) {
            if (snapshots.hasData && snapshots.data != null) {
              if (snapshots.data.status != Status.LOADING) {
                Timer(Duration(seconds: 3), () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                });

                if (snapshots.data.status == Status.COMPLETED) {
                  sendMessage(
                      snapshots.data.data, Constants.IMAGE_MESSAGE_TYPE);
                }
              }
              return Text(snapshots.data.message);
            } else {
              return Container();
            }
          }),
    );
  }

  Widget listMessages() {
    return Flexible(child: Container(
        child: StreamBuilder(
          stream: _bloc.messageList,
          builder: (context, snapshot) {
            if(snapshot.hasData && snapshot.data != null){
              return ListView.builder(
                reverse: true,
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) =>
                    buildChatLayout(snapshot.data.documents[index]),
                itemCount: snapshot.data.documents.length,
              );
            } else {
              return Center(
                child: Text('snapshot.error'),
              );
            }
          },
        )));
  }

  Widget buildChatLayout(DocumentSnapshot snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment:
                snapshot[Constants.MESSAGE_RECEIVER_ID] == widget.receiver.id
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
            children: <Widget>[
              snapshot[Constants.MESSAGE_RECEIVER_ID] == widget.receiver.id
                  ? CircleAvatar(
                      backgroundImage: widget.receiver.photoUrl == null
                          ? Icon(Icons.account_box_outlined)
                          : NetworkImage(widget.receiver.photoUrl),
                      radius: 20.0,
                    )
                  : CircleAvatar(
                      backgroundImage: widget.sender.photoUrl == null
                          ? Icon(Icons.account_box_outlined)
                          : NetworkImage(widget.sender.photoUrl),
                      radius: 20.0,
                    ),
              SizedBox(
                width: 10.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  snapshot[Constants.MESSAGE_RECEIVER_ID] == widget.receiver.id
                      ? Text(
                          widget.receiver.nickname ?? '',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        )
                      : Text(
                          widget.sender.nickname ?? '',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                  Text(
                    snapshot[Constants.MESSAGE_TEXT],
                    style: TextStyle(color: Colors.black, fontSize: 14.0),
                  )
                  // snapshot['type'] == 'text'
                  //     ? Text(
                  //   snapshot['message'],
                  //   style: TextStyle(color: Colors.black, fontSize: 14.0),
                  // )
                  //     : InkWell(
                  //   onTap: (() {
                  //     // Navigator.push(
                  //     //     context,
                  //     //     new MaterialPageRoute(
                  //     //         builder: (context) => FullScreenImage(photoUrl: snapshot['photoUrl'],)));
                  //   }),
                  //   child: Hero(
                  //     tag: snapshot['photoUrl'],
                  //     child: FadeInImage(
                  //       image: NetworkImage(snapshot['photoUrl']),
                  //       placeholder: AssetImage('assets/blankimage.png'),
                  //       width: 200.0,
                  //       height: 200.0,
                  //     ),
                  //   ),
                  // )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget sendMessageLayout() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          //Select media icon
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
              child: IconButton(
                icon: Icon(Icons.image),
                color: Colors.lightBlueAccent,
                onPressed: () => getImageFromDeviceGallery(),
              ),
              color: Colors.white,
            ),
          ),

          //Send emoji button
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
              child: IconButton(
                icon: Icon(Icons.face),
                color: Colors.lightBlueAccent,
                onPressed: () {
                  _bloc.toggleStickerView();
                },
              ),
              color: Colors.white,
            ),
          ),

          //Text input area
          Flexible(
              child: Container(
            padding:
                EdgeInsets.only(bottom: ScaleConfig.blockSizeHorizontal * 4.5),
            width: double.infinity,
            child: TextField(
              maxLines: 5,
              minLines: 1,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
              controller: messageEditingController,
              decoration: InputDecoration.collapsed(
                  hintText: 'Text message',
                  hintStyle: TextStyle(color: Colors.grey)),
              focusNode: focusNode,
            ),
          )),

          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
              child: StreamBuilder<CommonsResponse<bool>>(
                stream: _bloc.isMessageSent,
                builder: (BuildContext context,
                    AsyncSnapshot<CommonsResponse<bool>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.status == Status.COMPLETED) {
                      if (messageEditingController != null) {
                        Timer(Duration(milliseconds: 20), () {
                          messageEditingController.clear();
                        });
                      }
                      return sendButtonWidget();
                    } else if (snapshot.data.status == Status.ERROR) {
                      Fluttertoast.showToast(msg: snapshot.data.message);
                      return sendButtonWidget();
                    } else {
                      return messageSendLoader();
                    }
                  } else {
                    return sendButtonWidget();
                  }
                },
              ),
              color: Colors.white,
            ),
          ),
        ],
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
      ),
    );
  }

  Widget messageSendLoader() {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: 14, right: 14),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.yellow),
      ),
    );
  }

  Widget sendButtonWidget() {
    return IconButton(
      icon: Icon(Icons.send),
      color: Colors.lightBlueAccent,
      onPressed: () => sendMessage(
          messageEditingController.text, Constants.TEXT_MESSAGE_TYPE),
    );
  }

  ///get image from the device gallery
  Future getImageFromDeviceGallery() async {
    var imagePicker = ImagePicker();
    var pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    var newImageSelected = File(pickedFile.path);

    if (newImageSelected != null) {
      uploadImage(newImageSelected);
    }
  }

  Future<bool> onBackPress() {
    if (_bloc.isStickerEnabled.value) {
      _bloc.toggleStickerView();
    } else {
      Navigator.pop(context);
    }
    return Future.value(false);
  }

  void uploadImage(File newImageSelected) {
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return loader;
      },
    );
    _bloc.uploadChatImage(newImageSelected, context);
  }

  void sendMessage(String messageString, int messageCategory) {
    var chatMessage =
        Message('', widget.receiver.id, messageString, messageCategory);
    _bloc.sendChatMessage(chatMessage);
  }
}
