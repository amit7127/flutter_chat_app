import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

///
/// Created by Amit Kumar Sahoo (amit.sahoo@mindfiresolutions.com)
/// on 24-12-2020.
/// full_screen_image_widget.dart :
///
class FullScreenImageView extends StatelessWidget {
  final String imageUrl;

  FullScreenImageView({Key key, @required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black.withOpacity(0.5),
        appBar: AppBar(
//        backgroundColor: Colors.transparent,
          backgroundColor: Color(0x44000000),
          elevation: 0,
        ),
      body: Container(
        child: PinchZoom(
          image: CachedNetworkImage(
            imageUrl: imageUrl,
          ),
          zoomedBackgroundColor: Colors.black.withOpacity(0.5),
          resetDuration: const Duration(milliseconds: 100),
          maxScale: 2.5,
        ),
      )
    );
  }
}
