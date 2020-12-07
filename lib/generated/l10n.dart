// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hello in English`
  String get hello {
    return Intl.message(
      'Hello in English',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `Account Settings`
  String get accountSettings {
    return Intl.message(
      'Account Settings',
      name: 'accountSettings',
      desc: '',
      args: [],
    );
  }

  /// `Home Page`
  String get homePageTitle {
    return Intl.message(
      'Home Page',
      name: 'homePageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logoutButtonText {
    return Intl.message(
      'Logout',
      name: 'logoutButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Search...`
  String get searchHint {
    return Intl.message(
      'Search...',
      name: 'searchHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your Nick name`
  String get nickNameValidationErrorMessage {
    return Intl.message(
      'Please enter your Nick name',
      name: 'nickNameValidationErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `e.g - Amit/Nick`
  String get nickNameHint {
    return Intl.message(
      'e.g - Amit/Nick',
      name: 'nickNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Nick Name`
  String get nickNameLabel {
    return Intl.message(
      'Nick Name',
      name: 'nickNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please provide your bio. It should at-least 10 characters long`
  String get bioValidationErrorMessage {
    return Intl.message(
      'Please provide your bio. It should at-least 10 characters long',
      name: 'bioValidationErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Please write something about yourself.`
  String get bioHint {
    return Intl.message(
      'Please write something about yourself.',
      name: 'bioHint',
      desc: '',
      args: [],
    );
  }

  /// `About you`
  String get bioLabel {
    return Intl.message(
      'About you',
      name: 'bioLabel',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get updateButtonText {
    return Intl.message(
      'Update',
      name: 'updateButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Image uploading, please wait`
  String get uploading_image_message_text {
    return Intl.message(
      'Image uploading, please wait',
      name: 'uploading_image_message_text',
      desc: '',
      args: [],
    );
  }

  /// `Profile image uploaded successfully.`
  String get profile_image_upload_success_message {
    return Intl.message(
      'Profile image uploaded successfully.',
      name: 'profile_image_upload_success_message',
      desc: '',
      args: [],
    );
  }

  /// `User data updating, please wait.`
  String get user_info_update_message {
    return Intl.message(
      'User data updating, please wait.',
      name: 'user_info_update_message',
      desc: '',
      args: [],
    );
  }

  /// `UserData updated successfully`
  String get user_info_update_success_message {
    return Intl.message(
      'UserData updated successfully',
      name: 'user_info_update_success_message',
      desc: '',
      args: [],
    );
  }

  /// `Unable to update data, please try again later.`
  String get user_info_update_failed_message {
    return Intl.message(
      'Unable to update data, please try again later.',
      name: 'user_info_update_failed_message',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}