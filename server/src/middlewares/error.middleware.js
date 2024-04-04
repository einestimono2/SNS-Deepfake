import { Message, StatusCode } from '#constants';
import { BadRequestError, NotFoundError, UnauthorizedError } from '#modules';
import { logger } from '#utils';

// eslint-disable-next-line no-unused-vars
export function ErrorMiddleware(err, req, res, next) {
  logger.error(`[${err.name}]: ${err.message}`);

  // Inital values
  err.statusCode = err.statusCode ?? StatusCode.INTERNAL_SERVER_ERROR_500;
  err.ec = err.ec ?? err.statusCode;
  err.message = err.message ?? Message.INTERNAL_SERVER_ERROR;
  console.log(err);

  // SequelizeValidationError
  if (err.name === 'SequelizeValidationError') {
    // Only show first error
    const firstError = err.errors[Object.keys(err.errors)[0]].message;

    err = new BadRequestError(firstError);
  }

  // Wrong JWT error
  if (err.name === 'JsonWebTokenError') {
    err = new UnauthorizedError(Message.TOKEN_IS_INVALID_TRY_AGAIN);
  }

  // JWT EXPIRE error
  if (err.name === 'TokenExpiredError') {
    err = new UnauthorizedError(Message.TOKEN_IS_EXPIRED_TRY_AGAIN);
  }

  // File not exist
  if (err.code === 'ENOENT') {
    err = new NotFoundError(Message.FILE_NOT_FOUND);
  }

  if (err.name === 'MulterError' && err.code === 'LIMIT_FILE_SIZE') {
    if (err.field === 'images') {
      err = new BadRequestError(Message.IMAGE_TOO_LARGE);
    } else if (err.field === 'videos') {
      err = new BadRequestError(Message.VIDEO_TOO_LARGE);
    }
  }

  res.status(err.statusCode).json({
    status: 'error',
    ec: err.ec,
    message: err.message
  });
}
