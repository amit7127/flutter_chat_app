import 'package:flutter/material.dart';

///
/// Created by  on 11/25/2020.
/// ScaleConfig.dart : Size constants for responsive UI for different screen sizes
///

class ScaleConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;          //360.0
  static double screenHeight;         //692.0
  static double blockSizeHorizontal;    //3.6
  static double blockSizeVertical;    //6.92

  static double smallPadding;
  static double mediumPadding;
  static double largePadding;

  static double editProfileImageSize;

  void init(BuildContext context){
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    smallPadding = blockSizeHorizontal * 1;
    mediumPadding = blockSizeHorizontal * 2;
    largePadding = blockSizeHorizontal * 3;

    editProfileImageSize = blockSizeHorizontal * 20;
  }
}