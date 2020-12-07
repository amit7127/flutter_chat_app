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

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "accountSettings" : MessageLookupByLibrary.simpleMessage("Account Settings"),
    "bioHint" : MessageLookupByLibrary.simpleMessage("Please write something about yourself."),
    "bioLabel" : MessageLookupByLibrary.simpleMessage("About you"),
    "bioValidationErrorMessage" : MessageLookupByLibrary.simpleMessage("Please provide your bio. It should at-least 10 characters long"),
    "hello" : MessageLookupByLibrary.simpleMessage("Hello in English"),
    "homePageTitle" : MessageLookupByLibrary.simpleMessage("Home Page"),
    "logoutButtonText" : MessageLookupByLibrary.simpleMessage("Logout"),
    "nickNameHint" : MessageLookupByLibrary.simpleMessage("e.g - Amit/Nick"),
    "nickNameLabel" : MessageLookupByLibrary.simpleMessage("Nick Name"),
    "nickNameValidationErrorMessage" : MessageLookupByLibrary.simpleMessage("Please enter your Nick name"),
    "profile_image_upload_success_message" : MessageLookupByLibrary.simpleMessage("Profile image uploaded successfully."),
    "searchHint" : MessageLookupByLibrary.simpleMessage("Search..."),
    "updateButtonText" : MessageLookupByLibrary.simpleMessage("Update"),
    "uploading_image_message_text" : MessageLookupByLibrary.simpleMessage("Image uploading, please wait"),
    "user_info_update_failed_message" : MessageLookupByLibrary.simpleMessage("Unable to update data, please try again later."),
    "user_info_update_message" : MessageLookupByLibrary.simpleMessage("User data updating, please wait."),
    "user_info_update_success_message" : MessageLookupByLibrary.simpleMessage("UserData updated successfully")
  };
}