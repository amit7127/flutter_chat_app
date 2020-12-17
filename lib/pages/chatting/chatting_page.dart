import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/CommonResponse.dart';
import 'package:flutter_chat_app/utils/ScaleConfig.dart';
import 'package:flutter_chat_app/widgets/HomeAppBar.dart';
import 'package:flutter_chat_app/widgets/ProgressWidget.dart';
import 'package:flutter_chat_app/widgets/emoji_selector_widget.dart';
import 'package:image_picker/image_picker.dart';

import 'chatting_page_bloc.dart';

///
/// Created by  on 12/11/2020.
/// chatting_page.dart :
///
class ChatPage extends StatelessWidget {
  final String receiverId;
  final String receiverName;
  final String receiverProfilePic;

  ChatPage(this.receiverId, this.receiverName, this.receiverProfilePic);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          ChatScreenAppbar(receiverName, profileImageUrl: receiverProfilePic),
      body: ChatListScreen(
          receiverId: receiverId, receiverPhotoUrl: receiverProfilePic),
    );
  }
}

class ChatListScreen extends StatefulWidget {
  final String receiverId;
  final String receiverPhotoUrl;

  ChatListScreen(
      {Key key, @required this.receiverId, @required this.receiverPhotoUrl});

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
                  Expanded(child: listMessages()),

                  StreamBuilder<bool>(
                      stream: _bloc.isStickerEnabled,
                      builder: (BuildContext context,
                          AsyncSnapshot<bool> snapshots) {
                        if (snapshots.hasData) {
                          return snapshots.data
                              ? EmojiStickerSelector()
                              : Container();
                        } else {
                          return Container();
                        }
                      }),

                  //Send message layout
                  sendMessageLayout()
                ],
              ))
        ],
      ),
    );
  }

  void initializeLoader(BuildContext context) {
    // set up the AlertDialog
    loader = AlertDialog(
      content: StreamBuilder<CommonsResponse<String>>(
          stream: _bloc.imageUploadTask,
          builder: (BuildContext context,
              AsyncSnapshot<CommonsResponse<String>> snapshots) {
            if (snapshots.hasData && snapshots.data != null) {
              if(snapshots.data.status != Status.LOADING){
                Timer(Duration(seconds: 3), () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                });
              }
              return Text(snapshots.data.message);
            } else {
              return Container();
            }
          }),
    );
  }

  Widget listMessages() {
    return Container(
        child: Center(
      child: circularProgress(),
    ));
  }

  Widget sendMessageLayout() {
    return Flexible(
        child: Container(
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
              child: IconButton(
                icon: Icon(Icons.send),
                color: Colors.lightBlueAccent,
                onPressed: () => print('send button clicked'),
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
    ));
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
}
