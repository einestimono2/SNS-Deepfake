import jwt from 'jsonwebtoken';

import { CatchAsyncError } from './async.middleware.js';

import { redis } from '#configs';
import { Message } from '#constants';
import { BadRequestError, ForbiddenError, NotFoundError } from '#modules';

//! Bearer Token
export const isAuthenticated = CatchAsyncError(async (req, res, next) => {
  const accessToken = req.headers.authorization?.split(' ')[1];
  if (!accessToken) {
    next(new NotFoundError(Message.BEARER_TOKEN_EMPTY));
    return;
  }

  // Giải mã lấy id
  const payload = jwt.verify(accessToken, process.env.JWT_SECRET);
  if (!payload) {
    next(new BadRequestError(Message.TOKEN_IS_INVALID));
    return;
  }

  // Check blacklist
  // const blacklist = await redis.get(`BL_${payload.id}`);
  // if (blacklist && blacklist === accessToken) {
  //   next(new BadRequestError(Message.TOKEN_IS_INVALID_TRY_AGAIN));
  //   return;
  // }

  // Gán theater khi token chưa cập nhật
  // if (!payload.theater && payload.role !== Roles.User) {
  // payload.theater = (await ManagerModel.findById(payload.id))?.theater;
  // }

  req.userPayload = payload;
  req.accessToken = accessToken;

  next();
});

//! Lấy token nếu đăng nhập, còn không thì null
export const isAuthenticatedOrNot = CatchAsyncError(async (req, res, next) => {
  const accessToken = req.headers.authorization?.split(' ')[1];
  if (!accessToken) {
    next();
    return;
  }

  // Giải mã lấy id
  try {
    const payload = jwt.verify(accessToken, process.env.ACCESS_TOKEN_SECRET);
    if (!payload) {
      next();
      return;
    }

    req.userPayload = payload;
    req.accessToken = accessToken;

    next();
  } catch (_) {
    next();
  }
});

export const verifyRefreshToken = CatchAsyncError(async (req, res, next) => {
  const { refreshToken } = req.body;
  if (!refreshToken) {
    next(new NotFoundError(Message.TOKEN_IS_INVALID));
    return;
  }

  try {
    const payload = jwt.verify(refreshToken, process.env.REFRESH_TOKEN_SECRET);

    if (!payload) {
      next(new BadRequestError(Message.TOKEN_IS_INVALID_TRY_AGAIN));
      return;
    }

    // verify if token is in store or not
    const userJSON = await redis.get(payload.id);
    if (!userJSON) {
      next(new NotFoundError(Message.USER_NOT_FOUND));
      return;
    }

    const user = JSON.parse(userJSON); // { accessToken, refreshToken }

    if (user.refreshToken !== refreshToken) {
      next(new BadRequestError(Message.TOKEN_IS_INVALID));
      return;
    }

    req.userPayload = payload;
    req.accessToken = user.accessToken;

    next();
  } catch (_) {
    next(new BadRequestError(Message.TOKEN_IS_EXPIRED_TRY_AGAIN_NO_EC));
  }
});

// Check role
export const authorizeRoles = (...roles) => {
  return (req, _res, next) => {
    if (!roles.includes(req.userPayload?.role ?? '')) {
      // Role: ${req.user.role} insufficient access rights
      next(new ForbiddenError(Message.INSUFFICIENT_ACCESS_RIGHTS));
      return;
    }

    next();
  };
};
