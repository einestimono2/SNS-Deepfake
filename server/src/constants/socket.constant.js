export const SocketEvents = {
  MESSAGE_NEW: 'message::new',
  MESSAGE_NEWS: 'message::news',
  MESSAGE_REMOVE: 'message::remove',
  MESSAGE_UPDATE: 'message::update',

  CONVERSATION_UPDATE: 'conversation::update',
  CONVERSATION_NEW: 'conversation::new',
  CONVERSATION_REMOVE: 'conversation::remove',

  CONVERSATION_LASTEST: 'conversation::lastest',

  CONVERSATION_JOIN: 'conversation::join',
  CONVERSATION_LEAVE: 'conversation::leave',
  CONVERSATION_ADD_MEMBER: 'conversation::add_member',

  USER_ONLINE: 'user::online',

  TYPING_START: 'typing::start',
  TYPING_END: 'typing::end'
};
