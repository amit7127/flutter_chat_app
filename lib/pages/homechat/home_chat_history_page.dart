import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_chat_app/generated/l10n.dart';
import 'package:flutter_chat_app/models/chat_history.dart';
import 'package:flutter_chat_app/models/common_response.dart';
import 'package:flutter_chat_app/models/user.dart';
import 'package:flutter_chat_app/pages/chatting/chatting_page.dart';
import 'package:flutter_chat_app/pages/drawer/app_drawer.dart';
import 'package:flutter_chat_app/pages/homechat/home_chat_bloc.dart';
import 'package:flutter_chat_app/utils/constants.dart';
import 'package:flutter_chat_app/utils/extension_utils.dart';
import 'package:flutter_chat_app/utils/string_utils.dart';
import 'package:flutter_chat_app/widgets/home_app_bar.dart';
import 'package:flutter_chat_app/widgets/progress_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

///
/// Created by Amit Kumar Sahoo (amit.sahoo@mindfiresolutions.com)
/// on 24-12-2020.
/// home_chat_history_page.dart : Chat history list
///
class HomeChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeChatState();
  }
}

class HomeChatState extends State<HomeChatPage> {
  HomeChatBloc _bloc;

  @override
  void initState() {
    _bloc = HomeChatBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _bloc.getChatHistory(context);

    return Scaffold(
        appBar: DefaultAppBarWithTitle(S.of(context).chat_history_title),
        endDrawer: AppDrawer(refreshWidget: refreshWidget),
        body: Stack(
          children: <Widget>[
            //on chat history click
            //fetch the user details for current user and receiver
            // then navigate to chatting page
            StreamBuilder(
                stream: _bloc.users.stream,
                builder: (BuildContext context,
                    AsyncSnapshot<CommonsResponse<List<User>>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.status == Status.LOADING) {
                      return circularProgress();
                    } else if (snapshot.data.status == Status.COMPLETED) {
                      SchedulerBinding.instance
                          .addPostFrameCallback((timeStamp) {
                        navigateToChatPage(snapshot.data.data);
                      });
                      return Container();
                    } else {
                      Fluttertoast.showToast(msg: snapshot.data.message);
                      return Container();
                    }
                  } else {
                    return Container();
                  }
                }),

            //fetch chat history list
            StreamBuilder(
              stream: _bloc.chatList.stream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<ChatHistory>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) {
                        var chatData = snapshot.data[index];
                        return getCardForListItem(chatData);
                      });
                } else {
                  return circularProgress();
                }
              },
            ),
          ],
        ));
  }

  ///Get chat history list item card view
  ///[chatData] : ChatHistory object
  Widget getCardForListItem(ChatHistory chatData) {
    var messageDate = StringUtils.getChatListDateFormat(
        serverTime: chatData.timeStampFromServer, context: context);
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.black,
          backgroundImage: CachedNetworkImageProvider(chatData.userPhotoUrl),
        ),
        title: Text(
          chatData.userName.titleCase(),
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: getMessageBody(chatData.messageType, chatData.lastMessage),
        trailing: Text(messageDate),
        onTap: () => _bloc.getUsers(chatData.userId, context),
      ),
    );
  }

  ///get message list item body
  ///[messageType] : int [gif/image/text]
  ///[message] : String message content
  Widget getMessageBody(int messageType, String message) {
    if (messageType == Constants.IMAGE_MESSAGE_TYPE) {
      return Row(
        children: <Widget>[
          Icon(Icons.image_outlined),
          Text(S.of(context).image_placeholder)
        ],
      );
    } else if (messageType == Constants.EMOJI_MESSAGE_TYPE) {
      return Row(
        children: <Widget>[
          Icon(
            Icons.gif,
            size: 30,
          ),
          Text(S.of(context).sticker_placeholder)
        ],
      );
    } else {
      return Text(message);
    }
  }

  /// Refresh page on language change
  void refreshWidget() {
    setState(() {});
  }

  /// Navigate to Chat page
  /// [users] : List<User> contains Sender and Receiver Users
  void navigateToChatPage(List<User> users) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ChatPage(users[1], users[0])));
  }
}
