import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ProgressWidget.dart';

///
/// Created by Amit Kumar Sahoo on 11/23/2020.
/// CircularProfileImageView.dart : Circular profile image
///

///Circular Profile image from the Network
///[imageUrl] : String image url of the profile photo
class CircularProfileImageFromNetwork extends StatelessWidget {
  final String imageUrl;

  CircularProfileImageFromNetwork(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CachedNetworkImage(
        placeholder: (context, url) => Container(
          child: circularProgress(),
        ),
        imageUrl: imageUrl,
        width: 200.0,
        height: 200.0,
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.all(Radius.circular(125.0)),
      clipBehavior: Clip.hardEdge,
    );
  }
}

///Circular image from the internal device storage
///[imageFileAvatar] : File for the image
class CircularProfileImageFromMemory extends StatelessWidget {
  final File imageFileAvatar;

  CircularProfileImageFromMemory(this.imageFileAvatar);

  @override
  Widget build(BuildContext context) {
    return Material(
      //File is selected from the gallery
      child: Image.file(
        imageFileAvatar,
        width: 200.0,
        height: 200.0,
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.all(Radius.circular(125.0)),
      clipBehavior: Clip.hardEdge,
    );
  }
}
