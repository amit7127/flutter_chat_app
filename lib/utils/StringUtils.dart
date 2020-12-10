///
/// Created by  on 12/10/2020.
/// StringUtils.dart :
///

class StringUtils {
  static List<String> setSearchParam(String nameQuery) {
    var caseSearchList = <String>[];
    var temp = '';
    for (var i = 0; i < nameQuery.length; i++) {
      temp = temp + nameQuery[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }
}