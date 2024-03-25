export const Message = {
  API_KEY_INVALID: {
    msg: 'Key is invalid or has expired!',
    ec: 1000
  },
  BEARER_TOKEN_EMPTY: {
    msg: '',
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
  }
};
