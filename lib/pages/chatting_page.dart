import 'package:flutter/material.dart';
import 'package:flutter_chat_app/utils/ScaleConfig.dart';
import 'package:flutter_chat_app/widgets/HomeAppBar.dart';
import 'package:flutter_chat_app/widgets/ProgressWidget.dart';
import 'package:flutter_chat_app/widgets/emoji_selector_widget.dart';

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

  bool isStickerSelectorOn;

  @override
  void initState() {
    isStickerSelectorOn = true;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(child: listMessages()),

               isStickerSelectorOn ? EmojiStickerSelector() : Container(),

              //Send message layout
              sendMessageLayout()
            ],
          )
        ],
      ),
    );
  }

  Widget listMessages() {
    return Flexible(
        child: Center(
      child: circularProgress(),
    ));
  }

  Widget sendMessageLayout() {
    return
      Flexible(child: Container(
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
                  onPressed: () => print('Get image todo'),
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
                    print('Before state change $isStickerSelectorOn');
                    setState(() {
                      isStickerSelectorOn = !isStickerSelectorOn;
                      print('After state change $isStickerSelectorOn');
                    });
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
}
