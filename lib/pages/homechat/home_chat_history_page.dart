import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/ChatHistory.dart';
import 'package:flutter_chat_app/pages/drawer/app_drawer.dart';
import 'package:flutter_chat_app/pages/homechat/home_chat_bloc.dart';
import 'package:flutter_chat_app/utils/StringUtils.dart';
import 'package:flutter_chat_app/utils/extension_utils.dart';
import 'package:flutter_chat_app/widgets/HomeAppBar.dart';
import 'package:flutter_chat_app/widgets/ProgressWidget.dart';

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
    _bloc.getChatHistory();

    return Scaffold(
      appBar: DefaultAppBarWithTitle('Chat History'),
      endDrawer: AppDrawer(refreshWidget: refreshWidget),
      body: StreamBuilder(
        stream: _bloc.chatList.stream,
        builder:
            (BuildContext context, AsyncSnapshot<List<ChatHistory>> snapshot) {
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
                        backgroundImage:
                            CachedNetworkImageProvider(chatData.userPhotoUrl),
                      ),
                      title: Text(
                        chatData.userName.titleCase(),
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      subtitle: Text(chatData.lastMessage),
                      trailing: Text(messageDate),
                      onTap: () => {},
                    ),
                  );
                });
          } else {
            return circularProgress();
          }
        },
      ),
    );
  }

  void refreshWidget() {
    setState(() {});
  }
}
