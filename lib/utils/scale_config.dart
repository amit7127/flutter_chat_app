import 'package:flutter/material.dart';
import 'dart:ui' as ui;

///
/// Created by  on 11/25/2020.
/// scale_config.dart : Size constants for responsive UI for different screen sizes
///

class ScaleConfig {
  static double screenWidth;          //360.0
  static double screenHeight;         //692.0
  static double blockSizeHorizontal;    //3.6
  static double blockSizeVertical;    //6.92

  static double smallPadding;
  static double mediumPadding;
  static double largePadding;

  static double smallFontSize;
  static double mediumFontSize;
  static double largeFontSize;

  static double editProfileImageSize;

  void init(){
    screenWidth = ui.window.physicalSize.width / ui.window.devicePixelRatio;;
    screenHeight = ui.window.physicalSize.height / ui.window.devicePixelRatio;;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    smallPadding = blockSizeHorizontal * 3;
    mediumPadding = blockSizeHorizontal * 6;
    largePadding = blockSizeHorizontal * 10;

    smallFontSize = blockSizeHorizontal * 3;
    mediumFontSize = blockSizeHorizontal * 4.5;
    largeFontSize = blockSizeHorizontal * 6;

    editProfileImageSize = blockSizeHorizontal * 20;
  }
}