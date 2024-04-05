export const Message = {
  API_KEY_INVALID: {
    msg: 'Key is invalid or has expired!',
    ec: 1000
  },
  BEARER_TOKEN_EMPTY: {
    msg: 'Bearer token is empty!',
    ec: 1001
  },
  INSUFFICIENT_ACCESS_RIGHTS: {
    msg: 'Insufficient Access Rights!',
    ec: 1002
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
  TOKEN_IS_INVALID_TRY_AGAIN: {
    msg: 'Token khong hop le'
  },
  TOKEN_IS_EXPIRED_TRY_AGAIN: {
    msg: 'Token het han!'
  },
  NO_ENOUGH_INFORMATION: {
    msg: 'No enough information!'
  },
  CAN_NOT_BLOCK: {
    msg: 'Can not block!'
  },
  USED_PASSWORD: {
    msg: 'Password has been used before'
  }
};
