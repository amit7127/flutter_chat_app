import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/User.dart';
import 'package:flutter_chat_app/widgets/CircularProfileImageView.dart';
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
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.lightBlue,
        title: Text(
          "Account Settings",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
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

  @override
  void initState() {
    super.initState();
    bloc = SettingsBloc();

    bloc.getUserDataFromDevice();
  }

  @override
  Widget build(BuildContext context) {
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
                                      snapshot.data.photoUrl);
                                } else {
                                  //Data is not available or data is empty for the profile image, so show placeholder
                                  return Icon(Icons.account_circle,
                                      size: 90.0, color: Colors.grey);
                                }
                              },
                            )
                          : CircularProfileImageFromMemory(imageFileAvatar), //File is selected from the gallery
                      IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          size: 100.0,
                          color: Colors.white54.withOpacity(0.3),
                        ),
                        onPressed: getImageFromDeviceGallery,
                        padding: EdgeInsets.all(0.0),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.grey,
                        iconSize: 200.0,
                      )
                    ],
                  ),
                ),
                width: double.infinity,
                margin: EdgeInsets.all(20.0),
              )
            ],
          ),
        )
      ],
    );
  }

  ///get image from the device gallery
  Future getImageFromDeviceGallery() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile =
        await imagePicker.getImage(source: ImageSource.gallery);
    File newImageSelected = File(pickedFile.path);

    if (newImageSelected != null) {
      setState(() {
        this.imageFileAvatar = newImageSelected;
      });
    }

    //Todo: Upload image file to FireStore and Storage
    //uploadImageAndSaveData();
  }
}
