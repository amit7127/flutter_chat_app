class Constants {
  ///Table names constants
  static const USER_TABLE_NAME = 'users';
  static const MESSAGE_TABLE_NAME = 'messages';

  ///Storage dir name
  static const USER_PROFILE_DIR = 'profile';
  static const CHAT_IMAGE_DIR = 'chat-images';

  ///User table column name
  static const USER_ID = 'id';
  static const USER_NICKNAME = 'nickname';
  static const USER_PHOTOURL = 'photoUrl';
  static const USER_CREATEDAT = 'createAt';
  static const USER_ABOUTME = 'aboutMe';
  static const USER_CHATTINGWITH = 'chattingWith';
  static const USER_NAME_CASE_SEARCH = 'caseSearch';

  ///Chat table column name
  static const MESSAGE_ID = 'id';
  static const MESSAGE_SENDER_ID = 'senderId';
  static const MESSAGE_RECEIVER_ID = 'receiverId';
  static const MESSAGE_TEXT = 'message';
  static const MESSAGE_TYPE = 'messageType';
  static const MESSAGE_TIMESTAMP = 'timeStamp';

  ///Language Constants
  static const LOCAL_LANGUAGE = 'language_code';
  static const LANGUAGE_COUNTRY_CODE = 'countryCode';
  static const LANGUAGE_CODE_ARABIC = 'ar';
  static const LANGUAGE_CODE_ENGLISH = 'en';
  static const LANGUAGE_COUNTRY_ARABIC = '';
  static const LANGUAGE_COUNTRY_ENGLISH = 'US';

  ///Message type constants
  static const TEXT_MESSAGE_TYPE = 0;   // For text message type
  static const IMAGE_MESSAGE_TYPE = 1;  // For image message typr
  static const EMOJI_MESSAGE_TYPE = 2;  // for Emoji message type

  ///Message history fields name
  static const MESSAGE_HISTORY_USER_ID = 'userId';
  static const MESSAGE_HISTORY_LAST_MESSAGE = 'lastMessage';
  static const MESSAGE_HISTORY_TIME_STAMP = 'timeStamp';
  static const MESSAGE_HISTORY_PROFILE_PICTURE = 'userProfilePic';
  static const MESSAGE_HISTORY_USER_NAME = 'userName';
}
