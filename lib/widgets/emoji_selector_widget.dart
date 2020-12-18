import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
/// Created by  on 12/14/2020.
/// emoji_selector_widget.dart : Emoji grid layout widget
///
class EmojiStickerSelector extends StatelessWidget {

  final Function onEmojiSelect;

  EmojiStickerSelector({Key key, @required this.onEmojiSelect});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: GridView.count(
      crossAxisCount: 4,
      children: List.generate(9, (index) {
        var stickerPath = 'images/mimi${index + 1}.gif';
        return Card(
          color: Colors.transparent,
          child: InkResponse(
            child: Image.asset(
                stickerPath,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            onTap: (){
              onEmojiSelect(stickerPath);
            },
          ),
        );
      }),
    ));
  }
}
