import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_chat_app/generated/l10n.dart';
import 'package:flutter_chat_app/models/ChatHistory.dart';
import 'package:flutter_chat_app/models/CommonResponse.dart';
import 'package:flutter_chat_app/models/User.dart';
import 'package:flutter_chat_app/pages/chatting/chatting_page.dart';
import 'package:flutter_chat_app/pages/drawer/app_drawer.dart';
import 'package:flutter_chat_app/pages/homechat/home_chat_bloc.dart';
import 'package:flutter_chat_app/utils/Constants.dart';
import 'package:flutter_chat_app/utils/StringUtils.dart';
import 'package:flutter_chat_app/utils/extension_utils.dart';
import 'package:flutter_chat_app/widgets/HomeAppBar.dart';
import 'package:flutter_chat_app/widgets/ProgressWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';

///
/// Created by Amit Kumar Sahoo (amit.sahoo@mindfiresolutions.com)
/// on 24-12-2020.
/// home_chat_history_page.dart :
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
                        var messageDate = StringUtils.getChatListDateFormat(
                            serverTime: chatData.timeStampFromServer,
                            context: context);

                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.black,
                              backgroundImage: CachedNetworkImageProvider(
                                  chatData.userPhotoUrl),
                            ),
                            title: Text(
                              chatData.userName.titleCase(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            subtitle: getMessageBody(
                                chatData.messageType, chatData.lastMessage),
                            trailing: Text(messageDate),
                            onTap: () =>
                                _bloc.getUsers(chatData.userId, context),
                          ),
                        );
                      });
                } else {
                  return circularProgress();
                }
              },
            ),
          ],
        ));
  }

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

  void refreshWidget() {
    setState(() {});
  }

  void navigateToChatPage(List<User> users) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ChatPage(users[1], users[0])));
  }
}
