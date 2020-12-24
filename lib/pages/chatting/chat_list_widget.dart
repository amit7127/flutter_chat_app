import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/User.dart';
import 'package:flutter_chat_app/models/message.dart';
import 'package:flutter_chat_app/utils/Constants.dart';
import 'package:flutter_chat_app/widgets/full_screen_image_widget.dart';
import 'package:intl/intl.dart';

import 'chatting_page_bloc.dart';

///
/// Created by Amit Kumar Sahoo (amit.sahoo@mindfiresolutions.com)
/// on 21-12-2020.
/// chat_list_widget.dart :
///
//ignore: must_be_immutable
class ChatListWidget extends StatelessWidget {
  final User sender;
  final User receiver;
  final ChatPageBloc _bloc = ChatPageBloc();
  String lastMessageDate = '';
  final DateFormat serverFormat = DateFormat('dd-MM-yyyy');

  ChatListWidget({Key key, this.sender, this.receiver}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _bloc.getMessageList(receiver.id, sender.id);

    return Flexible(
        child: Container(
            child: StreamBuilder(
      stream: _bloc.messageList,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return ListView.builder(
            reverse: true,
            padding: EdgeInsets.all(10.0),
            itemBuilder: (context, index) =>
                getChatWidget(snapshot.data[index], context),
            itemCount: snapshot.data.length,
          );
        } else {
          return Center(
            child: Text('snapshot.error'),
          );
        }
      },
    )));
  }

  ///Get chat widget according to the chat type sender/receiver
  Widget getChatWidget(Message message, BuildContext context) {
    if(message.timeStampFromServer != null){
      var messageDate = serverFormat.format(DateTime.fromMillisecondsSinceEpoch(message.timeStampFromServer.millisecondsSinceEpoch));
      if(lastMessageDate.isEmpty || lastMessageDate == messageDate){
        lastMessageDate = messageDate;
        return getTextChatBubble(message, context);
      } else {
        lastMessageDate = messageDate;
        return getDateBubble(messageDate, message, context);
      }
    } else {
      return Container();
    }
  }

  /// Sender bubble
  /// [message] : Message object for sender
  Widget getTextChatBubble(Message message, BuildContext context) {
    var messageSentDate = DateFormat('hh:mm:aa').format(
        DateTime.fromMillisecondsSinceEpoch(
            (message.timeStampFromServer.millisecondsSinceEpoch)));

    var isSender = message.senderId == sender.id;

    return Container(
      child: Row(
        mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[

          //For sender show profile icon on left side
          isSender ? CircleAvatar(
            backgroundColor: Colors.black,
            backgroundImage: CachedNetworkImageProvider(sender.photoUrl),
            radius: 10,
          ) : Container(),

          //Message area
          Column(
            children: <Widget>[
              Bubble(
                margin: BubbleEdges.only(top: 10),
                alignment: isSender ? Alignment.topRight : Alignment.topLeft,
                nipWidth: 8,
                nipHeight: 24,
                nip: isSender ? BubbleNip.rightTop : BubbleNip.leftTop,
                color: Color.fromRGBO(225, 255, 199, 1.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      getMessageContainer(message, context),
                      Padding(padding: EdgeInsets.only(left: 10),
                          child: Text(messageSentDate,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10))
                      )

                    ],
                  ),
                )
              ),
            ],
          ),

          //For receiver show profile icon on right side
          isSender ? Container() : CircleAvatar(
            backgroundColor: Colors.black,
            backgroundImage: CachedNetworkImageProvider(receiver.photoUrl),
            radius: 10,
          )
        ],
      ),
    );
  }

  /// Time bubble
  /// [message] : Message object for sender/receiver
  /// [time] : Time date formatted String
  Widget getDateBubble(String time, Message message, BuildContext context) {
    var todayString = serverFormat.format(DateTime.now());

    return Column(
      children: <Widget>[
        Bubble(
          alignment: Alignment.center,
          color: Color.fromRGBO(212, 234, 244, 1.0),
          child: Text(todayString == time ? 'Today': time, textAlign: TextAlign.center, style: TextStyle(fontSize: 11.0)),
        ),
        getTextChatBubble(message, context)
      ],
    );
  }

  ///Return message body according to message type
  ///[message] : Message object
  Widget getMessageContainer(Message message, BuildContext context){
    if(message.messageType == Constants.EMOJI_MESSAGE_TYPE) {
      //Show emoji type message
      return Image.asset(
        message.message,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    } else if(message.messageType == Constants.IMAGE_MESSAGE_TYPE){
      //Show image type message
      return GestureDetector(
        child: CachedNetworkImage(
          imageUrl: message.message,
          placeholder: (context, url) => Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: CircularProgressIndicator()
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FullScreenImageView(imageUrl: message.message,)));
        },
      );
    } else {
      //Show Text Message
      return Text(message.message, textAlign: TextAlign.right);
    }
  }
}
