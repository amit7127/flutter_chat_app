import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
/// Created by  on 12/14/2020.
/// emoji_selector_widget.dart : 
///
class EmojiStickerSelector extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Expanded(child: GridView.count(
      crossAxisCount: 3,
      children: List.generate(9, (index) {
        var stickerPath = 'images/mimi${index + 1}.gif';
        return FlatButton(
          child: Image.asset(
            stickerPath,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        );
      }),
    ));
  }
}
