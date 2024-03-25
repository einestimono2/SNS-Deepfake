import { Message } from '#constants';
import { ApiKeyServices, ForbiddenError } from '#modules';
import { CatchAsyncError } from './async.middleware.js';

export const apiKey = CatchAsyncError(async (req, res, next) => {
  const key = req.headers['x-api-key']?.toString();

  if (!key) {
    next(new ForbiddenError(Message.API_KEY_INVALID));
    return;
  }

  const model = await ApiKeyServices.getApiKeyDetails(key);
  if (!model) {
    next(new ForbiddenError(Message.API_KEY_INVALID));
    return;
  }

  req.apiKey = model;

  next();
});

// - Usage: router.xxxx('permission')
export const verifyPermission = (permission) => {
  return (req, res, next) => {
    if (!req.apiKey.permissions) {
      next(new ForbiddenError(Message.INSUFFICIENT_ACCESS_RIGHTS));
      return;
    }

    const isValid = req.apiKey.permissions.includes(permission);
    if (!isValid) {
      next(new ForbiddenError(Message.INSUFFICIENT_ACCESS_RIGHTS));
      return;
    }

    next();
  };
};
