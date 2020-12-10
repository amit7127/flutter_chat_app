// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(date) => "Joined: ${date}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function> {
    "about_me_placeHolder" : MessageLookupByLibrary.simpleMessage("About me"),
    "accountSettings" : MessageLookupByLibrary.simpleMessage("Account Settings"),
    "bioHint" : MessageLookupByLibrary.simpleMessage("Please write something about yourself."),
    "bioLabel" : MessageLookupByLibrary.simpleMessage("About you"),
    "bioValidationErrorMessage" : MessageLookupByLibrary.simpleMessage("Please provide your bio. It should at-least 10 characters long"),
    "error_in_logout_message" : MessageLookupByLibrary.simpleMessage("Error: while logging out user."),
    "hello" : MessageLookupByLibrary.simpleMessage("Hello in English"),
    "homePageTitle" : MessageLookupByLibrary.simpleMessage("Home Page"),
    "logoutButtonText" : MessageLookupByLibrary.simpleMessage("Logout"),
    "logout_success_message" : MessageLookupByLibrary.simpleMessage("User logged out successfully."),
    "logout_wait_message" : MessageLookupByLibrary.simpleMessage("Logging out user, please wait."),
    "menu_edit_profile" : MessageLookupByLibrary.simpleMessage("Edit Profile"),
    "nickNameHint" : MessageLookupByLibrary.simpleMessage("e.g - Amit/Nick"),
    "nickNameLabel" : MessageLookupByLibrary.simpleMessage("Nick Name"),
    "nickNameValidationErrorMessage" : MessageLookupByLibrary.simpleMessage("Please enter your Nick name"),
    "no_result_hint" : MessageLookupByLibrary.simpleMessage("No Result Found"),
    "profile_image_upload_success_message" : MessageLookupByLibrary.simpleMessage("Profile image uploaded successfully."),
    "searchHint" : MessageLookupByLibrary.simpleMessage("Search..."),
    "search_user_hint" : MessageLookupByLibrary.simpleMessage("Search Users"),
    "select_language" : MessageLookupByLibrary.simpleMessage("Select Language"),
    "unable_to_logout_message" : MessageLookupByLibrary.simpleMessage("Unable to logout user, please try after some time."),
    "updateButtonText" : MessageLookupByLibrary.simpleMessage("Update"),
    "uploading_image_message_text" : MessageLookupByLibrary.simpleMessage("Image uploading, please wait"),
    "user_fetching_dialog" : MessageLookupByLibrary.simpleMessage("fetching users, please wait"),
    "user_info_update_failed_message" : MessageLookupByLibrary.simpleMessage("Unable to update data, please try again later."),
    "user_info_update_message" : MessageLookupByLibrary.simpleMessage("User data updating, please wait."),
    "user_info_update_success_message" : MessageLookupByLibrary.simpleMessage("UserData updated successfully"),
    "user_joined_text" : m0
  };
}
