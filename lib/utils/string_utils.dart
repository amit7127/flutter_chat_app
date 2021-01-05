import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/generated/l10n.dart';
import 'package:intl/intl.dart';

///
/// Created by  on 12/10/2020.
/// string_utils.dart : String related utility functions
///

class StringUtils {
  static DateFormat dayFormat = DateFormat('dd/MMMM/yyyy');
  static DateFormat timeFormat = DateFormat('jm');

  static List<String> setSearchParam(String nameQuery) {
    var caseSearchList = <String>[];
    var temp = '';
    for (var i = 0; i < nameQuery.length; i++) {
      temp = temp + nameQuery[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }

  static String getChatRoomId(List<String> usersList) {
    usersList.sort();
    return usersList.join('-');
  }

  ///get chat list time format
  ///[serverTime] : TimerStamp from server
  ///[conetxt] : BuildContext object
  static String getChatListDateFormat(
      {@required Timestamp serverTime, BuildContext context}) {
    if (serverTime != null && serverTime.millisecondsSinceEpoch != null) {
      var todayString = dayFormat.format(DateTime.now());
      var yesterdayString =
          dayFormat.format(DateTime.now().subtract(Duration(days: 1)));
      var serverTimeString = dayFormat.format(
          DateTime.fromMillisecondsSinceEpoch(
              serverTime.millisecondsSinceEpoch));

      if (serverTimeString == todayString) {
        return timeFormat.format(DateTime.fromMillisecondsSinceEpoch(
            serverTime.millisecondsSinceEpoch));
      } else if (serverTimeString == yesterdayString) {
        return S.of(context).yesterday_string;
      } else {
        return serverTimeString;
      }
    } else {
      return '';
    }
  }
}
