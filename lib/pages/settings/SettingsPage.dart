import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/generated/l10n.dart';
import 'package:flutter_chat_app/models/CommonResponse.dart';
import 'package:flutter_chat_app/models/User.dart';
import 'package:flutter_chat_app/utils/ScaleConfig.dart';
import 'package:flutter_chat_app/widgets/CircularProfileImageView.dart';
import 'package:flutter_chat_app/widgets/HomeAppBar.dart';
import 'package:flutter_chat_app/widgets/ProgressWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'file:///D:/Practice%20Project/flutter_chat_app/lib/pages/settings/SettingsBloc.dart';

///
/// Created by  on 11/4/2020.
/// SettingsPage.dart : Contains user account related information
///

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWithTitle(S.of(context).accountSettings),
      body: SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsState();
  }
}

class SettingsState extends State<SettingsScreen> {
  SettingsBloc bloc;

  TextEditingController nickNameTextEditingController;
  TextEditingController aboutMeTextEditingController;
  File imageFileAvatar;
  FocusNode nickNameFocusNode;
  FocusNode bioFocusNode;
  String updatedProfileImageUrl;

  @override
  void initState() {
    super.initState();

    nickNameFocusNode = FocusNode();
    bioFocusNode = FocusNode();

    nickNameTextEditingController = TextEditingController();
    aboutMeTextEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    bloc = SettingsBloc(context);

    bloc.getUserDataFromDevice();
    var textStyle = Theme.of(context).textTheme.bodyText1;

    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //Profile image avatar
              Container(
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      (imageFileAvatar == null) ?
                          //File is empty so fetch profile image from url
                          StreamBuilder<User>(
                              stream: bloc.userData.stream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<User> snapshot) {
                                if (snapshot.hasData && snapshot.data != null) {
                                  //If data available show circular profile image
                                  return CircularProfileImageFromNetwork(
                                      snapshot.data.photoUrl, 45);
                                } else {
                                  //Data is not available or data is empty for the profile image, so show placeholder
                                  return Icon(Icons.account_circle,
                                      size:
                                          ScaleConfig.blockSizeHorizontal * 30,
                                      color: Colors.grey);
                                }
                              },
                            )
                          : CircularProfileImageFromMemory(imageFileAvatar),
                      //File is selected from the gallery
                      IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          size: ScaleConfig.blockSizeHorizontal * 20,
                          color: Colors.white54.withOpacity(0.3),
                        ),
                        onPressed: getImageFromDeviceGallery,
                        padding: EdgeInsets.all(0.0),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.grey,
                        iconSize: ScaleConfig.blockSizeHorizontal * 45,
                      )
                    ],
                  ),
                ),
                width: double.infinity,
                margin: EdgeInsets.all(ScaleConfig.smallPadding),
              ),
              Padding(
                padding: EdgeInsets.all(ScaleConfig.mediumPadding),
                child: TextFormField(
                  style: textStyle,
                  controller: nickNameTextEditingController,
                  focusNode: nickNameFocusNode,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return S.of(context).nickNameValidationErrorMessage;
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      hintText: S.of(context).nickNameHint,
                      labelText: S.of(context).nickNameLabel,
                      labelStyle: TextStyle(color: Colors.blue),
                      errorStyle: TextStyle(
                          color: Colors.yellowAccent,
                          fontSize: ScaleConfig.mediumFontSize),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: ScaleConfig.mediumPadding,
                    right: ScaleConfig.mediumPadding),
                child: TextFormField(
                  style: textStyle,
                  controller: aboutMeTextEditingController,
                  focusNode: bioFocusNode,
                  validator: (String value) {
                    if (value.isEmpty || value.length < 10) {
                      return S.of(context).bioValidationErrorMessage;
                    }
                    return null;
                  },
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      hintText: S.of(context).bioHint,
                      labelText: S.of(context).bioLabel,
                      labelStyle: TextStyle(color: Colors.blue),
                      errorStyle: TextStyle(
                          color: Colors.yellowAccent,
                          fontSize: ScaleConfig.mediumFontSize),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: ScaleConfig.smallPadding),
                child: FlatButton(
                  onPressed: () => updateUserData(),
                  child: Text(
                    S.of(context).updateButtonText,
                    style: TextStyle(fontSize: ScaleConfig.mediumFontSize),
                  ),
                  color: Colors.lightBlueAccent,
                  highlightColor: Colors.grey,
                  splashColor: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: ScaleConfig.smallPadding),
                child: RaisedButton(
                    onPressed: () {},
                    color: Colors.red,
                    child: Text(S.of(context).logoutButtonText,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: ScaleConfig.mediumFontSize))),
              ),
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.all(ScaleConfig.smallPadding),
            child: StreamBuilder<User>(
                stream: bloc.userData.stream,
                builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    WidgetsBinding.instance.addPostFrameCallback((duration) {
                      setState(() {
                        nickNameTextEditingController.text =
                            snapshot.data.nickname;
                        aboutMeTextEditingController.text =
                            snapshot.data.aboutMe;
                      });
                    });
                  }
                  return Container();
                })),
        Padding(
            padding: EdgeInsets.all(ScaleConfig.smallPadding),
            child: StreamBuilder<CommonsResponse<String>>(
                stream: bloc.imageUploadTask.stream,
                builder: (BuildContext context,
                    AsyncSnapshot<CommonsResponse<String>> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    if (snapshot.data.status == Status.LOADING) {
                      return circularProgress();
                    } else if (snapshot.data.status == Status.ERROR) {
                      Fluttertoast.showToast(msg: snapshot.data.message);
                      setState(() {
                        imageFileAvatar = null;
                      });
                      return Container();
                    } else if (snapshot.data.status == Status.COMPLETED) {
                      updatedProfileImageUrl = snapshot.data.data;
                      Fluttertoast.showToast(msg: snapshot.data.message);
                    }
                  }
                  return Container();
                })),
        Padding(
            padding: EdgeInsets.all(ScaleConfig.smallPadding),
            child: StreamBuilder<CommonsResponse<User>>(
                stream: bloc.userUpdate.stream,
                builder: (BuildContext context,
                    AsyncSnapshot<CommonsResponse<User>> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    if (snapshot.data.status == Status.LOADING) {
                      return circularProgress();
                    } else if (snapshot.data.status == Status.ERROR) {
                      Fluttertoast.showToast(msg: snapshot.data.message);
                    } else if (snapshot.data.status == Status.COMPLETED) {
                      Fluttertoast.showToast(msg: snapshot.data.message);
                    }
                  }
                  return Container();
                })),
      ],
    );
  }

  ///get image from the device gallery
  Future getImageFromDeviceGallery() async {
    var imagePicker = ImagePicker();
    var pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    var newImageSelected = File(pickedFile.path);

    if (newImageSelected != null) {
      setState(() {
        imageFileAvatar = newImageSelected;
      });
      uploadImageAndSaveData(newImageSelected);
    }
  }

  void uploadImageAndSaveData(File newImageSelected) {
    bloc.uploadProfileImage(newImageSelected);
  }

  void updateUserData() {
    bloc.updateUserData(updatedProfileImageUrl,
        nickNameTextEditingController.text, aboutMeTextEditingController.text);
  }
}
