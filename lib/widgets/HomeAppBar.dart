import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

///
/// Created by  on 11/21/2020.
/// HomeAppBar.dart : App bar widget with search bar and settings navigation icon
///
class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String appBarTitle;
  final TextEditingController searchEditingController;
  final Function onSettingsButtonTapped;

  HomeAppBar(this.appBarTitle, this.searchEditingController,
      this.onSettingsButtonTapped)
      : preferredSize = Size.fromHeight(60.0);

  @override
  State<StatefulWidget> createState() {
    return HomeAppBarState(
        appBarTitle, searchEditingController, onSettingsButtonTapped);
  }

  @override
  final Size preferredSize;
}

class HomeAppBarState extends State<HomeAppBar> {
  String appBarTitleText;
  Icon actionIcon = Icon(Icons.search);
  Widget appBarTitle;
  TextEditingController searchEditingController;
  Function onSettingsButtonTapped;

  HomeAppBarState(this.appBarTitleText, this.searchEditingController,
      this.onSettingsButtonTapped);

  @override
  initState() {
    super.initState();
    appBarTitle = Text(appBarTitleText);
  }

  @override
  Widget build(BuildContext context) {
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
                appBarTitle = TextFormField(
                  controller: searchEditingController,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    hintText: "Search...",
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    filled: true,
                  ),
                );
              } else {
                actionIcon = Icon(Icons.search);
                appBarTitle = Text('Home Page');
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
                  if (onSettingsButtonTapped != null) onSettingsButtonTapped();
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
    if (searchEditingController != null) searchEditingController.clear();
  }
}

///App bar with title in the middle
///[titleText] : String title
class DefaultAppBarWithTitle extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;

  DefaultAppBarWithTitle(this.titleText): preferredSize = Size.fromHeight(60.0);

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
