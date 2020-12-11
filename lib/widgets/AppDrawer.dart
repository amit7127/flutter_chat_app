import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/generated/l10n.dart';
import 'package:intl/intl.dart';

import 'CircularProfileImageView.dart';

///
/// Created by  on 12/7/2020.
/// AppDrawer.dart :
///

class AppDrawer extends StatefulWidget {
  final String profileImageUrl;
  final Function changeLanguage;
  final Function navigateToSettingsPage;
  final Function logoutUser;

  AppDrawer(this.profileImageUrl, this.changeLanguage,
      this.navigateToSettingsPage, this.logoutUser);

  @override
  State<StatefulWidget> createState() {
    return AppDrawerState();
  }
}

class AppDrawerState extends State<AppDrawer> {
  bool _langListVisible = false;

  List<Locale> langsList = S.delegate.supportedLocales;
  String currentLocaleSelected = Intl.getCurrentLocale().split('_')[0];

  @override
  Widget build(BuildContext context) {
    print(currentLocaleSelected);

    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: ListTile.divideTiles(
          //          <-- ListTile.divideTiles
          context: context,
          tiles: <Widget>[
            DrawerHeader(
              child: Container(
                child: Row(
                  children: <Widget>[
                    CircularProfileImageFromNetwork(widget.profileImageUrl, 30),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text(S.of(context).select_language),
              trailing: _langListVisible
                  ? Icon(Icons.keyboard_arrow_up)
                  : Icon(Icons.keyboard_arrow_down),
              onTap: () {
                // Update the state of the app
                setState(() {
                  _langListVisible = !_langListVisible;
                });
              },
            ),
            Container(
              child: _langListVisible
                  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: langsList.length,
                      itemBuilder: (context, index) {
                        return _languageListItem(langsList[index]);
                      },
                    )
                  : Container(),
            ),
            ListTile(
              title: Text(S.of(context).menu_edit_profile),
              trailing: Icon(Icons.edit_location_sharp),
              onTap: () {
                // Update the state of the app
                Navigator.pop(context);
                widget.navigateToSettingsPage();
              },
            ),
            ListTile(
              title: Text(S.of(context).logoutButtonText),
              trailing: Icon(Icons.logout),
              onTap: () {
                // Update the state of the app
                widget.logoutUser();
              },
            )
          ],
        ).toList(),
      ),
    );
  }

  ///This method provides List item for languag selection
  ///[locale] : Local to be render
  /// Returns List widget object
  Widget _languageListItem(Locale locale) {
    return Container(
      child: Align(
        child: SizedBox(
          width: 250,
          child: RaisedButton(
            onPressed: () {
              widget.changeLanguage(locale);
              setState(() {
                currentLocaleSelected = locale.languageCode;
              });
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Text(
              locale.scriptCode,
            ),
            color: currentLocaleSelected == locale.languageCode
                ? Colors.blue
                : Colors.white70,
          ),
        ),
      ),
    );
  }
}
