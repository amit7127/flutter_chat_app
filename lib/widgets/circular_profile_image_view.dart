import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/utils/scale_config.dart';

import 'progress_widget.dart';

///
/// Created by Amit Kumar Sahoo on 11/23/2020.
/// circular_profile_image_view.dart : Circular profile image
///

///Circular Profile image from the Network
///[imageUrl] : String image url of the profile photo
class CircularProfileImageFromNetwork extends StatelessWidget {
  final String imageUrl;
  final double imageRadius;

  CircularProfileImageFromNetwork(this.imageUrl, this.imageRadius);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CachedNetworkImage(
        placeholder: (context, url) => Container(
          child: circularProgress(),
        ),
        errorWidget: (context, url, error) => Icon(Icons.report_gmailerrorred_rounded,size: ScaleConfig.blockSizeHorizontal * 30,),
        imageUrl: imageUrl,
        width: ScaleConfig.blockSizeHorizontal * imageRadius,
        height: ScaleConfig.blockSizeHorizontal * imageRadius,
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.all(
          Radius.circular(ScaleConfig.blockSizeHorizontal * imageRadius)),
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
        width: ScaleConfig.blockSizeHorizontal * 50,
        height: ScaleConfig.blockSizeHorizontal * 50,
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.all(
          Radius.circular(ScaleConfig.blockSizeHorizontal * 40)),
      clipBehavior: Clip.hardEdge,
    );
  }
}
