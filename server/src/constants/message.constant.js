export const Message = {
  API_KEY_INVALID: {
    msg: 'Key is invalid or has expired!',
    ec: 1000
  },
  BEARER_TOKEN_EMPTY: {
    msg: 'Bearer token is empty!',
    ec: 1001
  },
  TOKEN_IS_INVALID_TRY_AGAIN: {
    ec: 1002,
    msg: 'Session has expired!'
  },
  TOKEN_IS_EXPIRED_TRY_AGAIN: {
    ec: 1003,
    msg: 'Token het han!'
  },
  INSUFFICIENT_ACCESS_RIGHTS: {
    msg: 'Insufficient Access Rights!',
    ec: 1004
  },
  ROUTE_NOT_FOUND: {
    msg: 'Route Not Found'
  },
  INTERNAL_SERVER_ERROR: {
    msg: 'Internal Server Error'
  },
  POSTGRE_CONNECTION_ERROR: {
    ec: -100,
    msg: 'Unable to connect to Postgre. Trying to reconnect!'
  },
  REDIS_CONNECTION_ERROR: {
    ec: -101,
    msg: 'Unable to connect to Redis. Trying to reconnect!'
  },
  UNSUPPORTED_IMAGE_FORMAT: {
    msg: 'Image format is not supported! (png|jpg|jpeg)'
  },
  UNSUPPORTED_VIDEO_FORMAT: {
    msg: 'Video format is not supported! (mp4|mkv|mov|avi)'
  },
  IMAGE_TOO_LARGE: {
    msg: 'Image size exceeds allowed size! (5 mb)'
  },
  VIDEO_TOO_LARGE: {
    msg: 'Video size exceeds allowed size! (30 mb)'
  },
  IMAGE_EMPTY: {
    msg: "Field 'images' can not be empty!"
  },
  VIDEO_EMPTY: {
    msg: "Field 'videos' can not be empty!"
  },
  PATH_EMPTY: {
    msg: "Param 'path' can not be empty!"
  },
  PHONE_NUMBER_IS_INVALID: {
    msg: 'Phone number is invalid!'
  },
  EMAIL_ALREADY_EXISTS: {
    msg: 'Email already exist!'
  },
  EMAIL_NOT_EXISTS: {
    msg: 'Email does not exist!'
  },
  FILE_NOT_FOUND: {
    msg: 'File does not exist!'
  },
  FILE_BROKEN: {
    msg: 'There was a problem with the uploaded file. Please re-upload the file!'
  },
  IMAGE_NOT_FOUND: {
    msg: 'Image does not exist!'
  },
  VIDEO_NOT_FOUND: {
    msg: 'Video does not exist!'
  },
  USER_IS_INVALID: {
    msg: 'User is invalid!'
  },
  USER_NOT_FOUND: {
    msg: 'User not found!'
  },
  NO_ENOUGH_COINS: {
    msg: 'No enough coins'
  },
  POST_NOT_FOUND: {
    msg: 'Post not found!'
  },
  CODE_NOT_FOUND: {
    msg: 'Code not found!'
  },
  NO_ENOUGH_INFORMATION: {
    msg: 'No enough information!'
  },
  CAN_NOT_BLOCK: {
    msg: 'Can not block!'
  },
  USED_PASSWORD: {
    msg: 'Password has been used before'
  },
  WRONG_PASSWORD: {
    msg: 'Wrong password'
    // msg: {
    //   vi: 'Sai mật khẩu',
    //   en: 'Wrong password'
    // }
  },
  MARK_IS_INVALID: {
    msg: 'Mark is invalid!'
  },
  UNABLE_TO_SENT_FRIEND_REQUEST: {
    msg: 'Unable to send friend request!'
  },
  FRIEND_REQUEST_NOT_FOUND: {
    msg: 'Friend request not found!'
  },
  CONVERSATION_MEMBERS_INVALID: {
    msg: 'Conversation must have at least 2 members!'
  },
  CONVERSATION_NOT_FOUND: {
    msg: 'Conversation not found!'
  },
  ID_EMPTY: {
    msg: 'ID empty!'
  },
  PAGE_INVALID: {
    msg: 'Invalid page! (must >= 1)'
  },
  PAGE_SIZE_INVALID: {
    msg: 'Invalid size! (must >= 1)'
  },
  ACCOUNT_NOT_ACTIVATED: {
    msg: 'Account has not been activated'
  }
};
