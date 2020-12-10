///
/// Created by  on 12/10/2020.
/// extension_utils.dart : 
///

extension StringExtension on String {
  String titleCase(){
    // ignore: unnecessary_this
    return this
        .replaceAllMapped(
        RegExp(
            r'[A-Z]{2,}(?=[A-Z][a-z]+[0-9]*|\b)|[A-Z]?[a-z]+[0-9]*|[A-Z]|[0-9]+'),
            (Match m) =>
        '${m[0][0].toUpperCase()}${m[0].substring(1).toLowerCase()}')
        .replaceAll(RegExp(r'(_|-)+'), ' ');
  }
}