import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/generated/l10n.dart';

///
/// Created by  on 11/21/2020.
/// HomeAppBar.dart : App bar widget with search bar and settings navigation icon
///
class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  String appBarTitle;
  final TextEditingController searchEditingController;
  final Function onSettingsButtonTapped;

  HomeAppBar(this.appBarTitle, this.searchEditingController,
      this.onSettingsButtonTapped)
      : preferredSize = Size.fromHeight(60.0);

  @override
  State<StatefulWidget> createState() {
    return HomeAppBarState();
  }

  @override
  final Size preferredSize;
}

class HomeAppBarState extends State<HomeAppBar> {
  Icon actionIcon;
  Widget appBarTitle;
  bool isSearchClicked;

  @override
  void initState() {
    actionIcon = Icon(Icons.search);
    isSearchClicked = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appBarTitle = isSearchClicked
        ? TextFormField(
            controller: widget.searchEditingController,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.white),
              hintText: S.of(context).searchHint,
              hintStyle: TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              filled: true,
            ),
          )
        : Text(widget.appBarTitle);
    return AppBar(
      title: appBarTitle,
      centerTitle: true,
      titleSpacing: 0.0,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        IconButton(
          icon: actionIcon,
          onPressed: () {
            setState(() {
              if (actionIcon.icon == Icons.search) {
                actionIcon = Icon(Icons.close);
                //appBarTitle;
                isSearchClicked = true;
              } else {
                actionIcon = Icon(Icons.search);
                //appBarTitle = Text('Home Page');
                isSearchClicked = false;
                emptyTextFormField();
              }
            });
          },
        ),
        IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () =>
                SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                  if (widget.onSettingsButtonTapped != null)
                    widget.onSettingsButtonTapped();
                }))
      ],
      leading: IconButton(
          icon: Icon(
            Icons.account_circle,
            color: Colors.white,
          ),
          onPressed: null),
    );
  }

  ///clear search text box
  void emptyTextFormField() {
    if (widget.searchEditingController != null)
      widget.searchEditingController.clear();
  }
}

///App bar with title in the middle
///[titleText] : String title
class DefaultAppBarWithTitle extends StatelessWidget
    implements PreferredSizeWidget {
  final String titleText;

  DefaultAppBarWithTitle(this.titleText)
      : preferredSize = Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.lightBlue,
      title: Text(
        titleText,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }

  @override
  final Size preferredSize;
}
