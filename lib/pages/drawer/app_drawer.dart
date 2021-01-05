import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/generated/l10n.dart';
import 'package:flutter_chat_app/models/common_response.dart';
import 'package:flutter_chat_app/models/user.dart';
import 'package:flutter_chat_app/pages/login/login_page.dart';
import 'package:flutter_chat_app/pages/search/search_user_page.dart';
import 'package:flutter_chat_app/pages/settings/settings_page.dart';
import 'package:flutter_chat_app/widgets/progress_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../widgets/circular_profile_image_view.dart';
import 'app_drawer_bloc.dart';

///
/// Created by Amit Kumar Sahoo on 12/7/2020.
/// app_drawer.dart : App drawer for navigation to diff menu options
///

class AppDrawer extends StatefulWidget {
  final Function refreshWidget;

  AppDrawer({Key key, this.refreshWidget}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AppDrawerState();
  }
}

class AppDrawerState extends State<AppDrawer>
    with AutomaticKeepAliveClientMixin<AppDrawer> {
  AppDrawerBloc _appDrawerBloc;
  bool _langListVisible = false;
  List<Locale> langsList = S.delegate.supportedLocales;
  String currentLocaleSelected = Intl.getCurrentLocale().split('_')[0];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _appDrawerBloc = AppDrawerBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _appDrawerBloc.getUserDataFromDevice();

    super.build(context);

    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: ListTile.divideTiles(
          //          <-- ListTile.divideTiles
          context: context,
          tiles: <Widget>[
            //User profile image view
            DrawerHeader(
              child: Container(
                child: Row(
                  children: <Widget>[
                    StreamBuilder<User>(
                      stream: _appDrawerBloc.userData.stream,
                      builder:
                          (BuildContext context, AsyncSnapshot<User> snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          //If data available show circular profile image
                          return CircularProfileImageFromNetwork(
                              snapshot.data.photoUrl, 30);
                        } else {
                          //Data is not available or data is empty for the profile image, so show placeholder
                          return circularProgress();
                        }
                      },
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),

            //Language dropDown
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

            //Edit menu
            ListTile(
              title: Text(S.of(context).menu_edit_profile),
              trailing: Icon(Icons.edit_location_sharp),
              onTap: () {
                // Update the state of the app
                Navigator.pop(context);
                navigateToSettingsPage();
              },
            ),

            //Logout menu
            ListTile(
              title: Text(S.of(context).logoutButtonText),
              trailing: StreamBuilder<CommonsResponse<bool>>(
                stream: _appDrawerBloc.logout.stream,
                builder: (BuildContext context,
                    AsyncSnapshot<CommonsResponse<bool>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.status == Status.LOADING) {
                      //Loading screen
                      return Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(bottom: 14, right: 14),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.yellow),
                        ),
                      );
                    } else if (snapshot.data.status == Status.ERROR) {
                      Fluttertoast.showToast(msg: snapshot.data.message);
                      return Icon(Icons.logout);
                    } else if (snapshot.data.status == Status.COMPLETED) {
                      Fluttertoast.showToast(msg: snapshot.data.message);
                      if (snapshot.data.data == true) {
                        SchedulerBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          navigateToLoginPage();
                        });
                      }
                      return Container();
                    }
                  }
                  return Icon(Icons.logout);
                },
              ),
              onTap: () {
                // Update the state of the app
                _appDrawerBloc.logOutUser(context);
              },
            ),

            //Todo: Add App version menu, FAQ, About, Contact us
          ],
        ).toList(),
      ),
    );
  }

  ///navigates to home page
  void navigateToLoginPage() {
    Navigator.push(context,
        MaterialPageRoute<SearchScreen>(builder: (context) => LoginScreen()));
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
              changeDrawerLanguage(locale);
              //widget.changeLanguage(locale);
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

  ///Change language of the app
  ///[locale] : Locale to change lang
  void changeDrawerLanguage(Locale locale) {
    print(locale.languageCode);
    setState(() {
      S.load(locale);
    });
    widget.refreshWidget();
  }

  ///navigate to Settings page
  void navigateToSettingsPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Settings()));
  }
}
