import { isProduction } from '#configs';
import { StatusCode } from '#constants';

// https://github.com/trotrindonesia/custom-error-exceptions/tree/master/lib/errors

class ErrorResponse extends Error {
  constructor(message, statusCode, ec) {
    super(message);
    this.statusCode = statusCode;
    this.ec = ec;

    // Bắt stack-trace nơi xảy ra lỗi, Hiển thị chi tiết vị trí lỗi
    // https://stackoverflow.com/questions/63598211/how-to-use-error-capturestacktrace-in-node-js
    if (!isProduction()) {
      Error.captureStackTrace(this, this.constructor);
    }
  }
}

export class BadRequestError extends ErrorResponse {
  constructor(message, statusCode = StatusCode.BAD_REQUEST_400, ec = message.ec ?? StatusCode.BAD_REQUEST_400) {
    super(typeof message === 'string' ? message : message.msg, statusCode, ec);
  }
}

export class ConflictError extends ErrorResponse {
  constructor(message, statusCode = StatusCode.CONFLICT_409, ec = message.ec ?? StatusCode.CONFLICT_409) {
    super(typeof message === 'string' ? message : message.msg, statusCode, ec);
  }
}

export class ForbiddenError extends ErrorResponse {
  constructor(message, statusCode = StatusCode.FORBIDDEN_403, ec = message.ec ?? StatusCode.FORBIDDEN_403) {
    super(typeof message === 'string' ? message : message.msg, statusCode, ec);
  }
}

export class GatewayTimeoutError extends ErrorResponse {
  constructor(
    message,
    statusCode = StatusCode.GATEWAY_TIMEOUT_504,
    ec = message.ec ?? StatusCode.GATEWAY_TIMEOUT_504
  ) {
    super(typeof message === 'string' ? message : message.msg, statusCode, ec);
  }
}

export class GoneError extends ErrorResponse {
  constructor(message, statusCode = StatusCode.GONE_410, ec = message.ec ?? message.ec ?? StatusCode.GONE_410) {
    super(typeof message === 'string' ? message : message.msg, statusCode, ec);
  }
}

export class InternalServerError extends ErrorResponse {
  constructor(
    message,
    statusCode = StatusCode.INTERNAL_SERVER_ERROR_500,
    ec = message.ec ?? StatusCode.INTERNAL_SERVER_ERROR_500
  ) {
    super(typeof message === 'string' ? message : message.msg, statusCode, ec);
  }
}

export class NotFoundError extends ErrorResponse {
  constructor(message, statusCode = StatusCode.NOT_FOUND_404, ec = message.ec ?? StatusCode.NOT_FOUND_404) {
    super(typeof message === 'string' ? message : message.msg, statusCode, ec);
  }
}

export class RequestTimeoutError extends ErrorResponse {
  constructor(
    message,
    statusCode = StatusCode.REQUEST_TIMEOUT_408,
    ec = message.ec ?? StatusCode.REQUEST_TIMEOUT_408
  ) {
    super(typeof message === 'string' ? message : message.msg, statusCode, ec);
  }
}

export class TooManyRequestsError extends ErrorResponse {
  constructor(
    message,
    statusCode = StatusCode.TOO_MANY_REQUESTS_429,
    ec = message.ec ?? StatusCode.TOO_MANY_REQUESTS_429
  ) {
    super(typeof message === 'string' ? message : message.msg, statusCode, ec);
  }
}

export class UnauthorizedError extends ErrorResponse {
  constructor(message, statusCode = StatusCode.UNAUTHORIZED_401, ec = message.ec ?? StatusCode.UNAUTHORIZED_401) {
    super(typeof message === 'string' ? message : message.msg, statusCode, ec);
  }
}

export class UnsupportedMediaTypeError extends ErrorResponse {
  constructor(
    message,
    statusCode = StatusCode.UNSUPPORTED_MEDIA_TYPE_415,
    ec = message.ec ?? StatusCode.UNSUPPORTED_MEDIA_TYPE_415
  ) {
    super(typeof message === 'string' ? message : message.msg, statusCode, ec);
  }
}

export class MethodNotAllowedError extends ErrorResponse {
  constructor(
    message,
    statusCode = StatusCode.METHOD_NOT_ALLOWED_405,
    ec = message.ec ?? StatusCode.METHOD_NOT_ALLOWED_405
  ) {
    super(typeof message === 'string' ? message : message.msg, statusCode, ec);
  }
}

export class UnprocessableEntityError extends ErrorResponse {
  constructor(
    message,
    statusCode = StatusCode.UNPROCESSABLE_ENTITY_422,
    ec = message.ec ?? StatusCode.UNPROCESSABLE_ENTITY_422
  ) {
    super(typeof message === 'string' ? message : message.msg, statusCode, ec);
  }
}

export class RedisTimeoutError extends ErrorResponse {
  constructor(
    message,
    statusCode = StatusCode.INTERNAL_SERVER_ERROR_500,
    ec = message.ec ?? StatusCode.INTERNAL_SERVER_ERROR_500
  ) {
    super(typeof message === 'string' ? message : message.msg, statusCode, ec);
  }
}
