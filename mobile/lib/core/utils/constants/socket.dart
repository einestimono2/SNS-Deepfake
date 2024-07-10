// ignore_for_file: constant_identifier_names

class SocketEvents {
  SocketEvents._();

  static const String MESSAGE_NEW = 'message::new';
  static const String MESSAGE_NEWS = 'message::news';
  static const String MESSAGE_REMOVE = 'message::remove';
  static const String MESSAGE_UPDATE = 'message::update';

  static const String CONVERSATION_UPDATE = 'conversation::update';
  static const String CONVERSATION_ADD_MEMBER = 'conversation::add_member';
  static const String CONVERSATION_NEW = 'conversation::new';
  static const String CONVERSATION_REMOVE = 'conversation::remove';

  static const String CONVERSATION_LASTEST = 'conversation::lastest';

  static const String CONVERSATION_JOIN = 'conversation::join';
  static const String CONVERSATION_LEAVE = 'conversation::leave';

  static const String USER_ONLINE = 'user::online';

  static const String TYPING_START = 'typing::start';
  static const String TYPING_END = 'typing::end';
}
