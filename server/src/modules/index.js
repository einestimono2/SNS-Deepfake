import express from 'express';

import { adminRouter } from './admin/index.js';
import { apiKeyRouter } from './api_key/index.js';
import { NotFoundError } from './core/index.js';
import { postRouter } from './post/index.js';
import { uploadRouter } from './upload/index.js';
import { userRouter } from './user/index.js';

import { Message, Strings } from '#constants';
import { getStandardPath } from '#utils';

export const routers = express.Router();

// ----- List routes -----
// 1. API Key
routers.use(`${Strings.API_PREFIX}/apikey`, apiKeyRouter);
// 2. Upload file & video
routers.use(`${Strings.API_PREFIX}/upload`, uploadRouter);
// 3. User
routers.use(`${Strings.API_PREFIX}/user`, userRouter);
// 4.Post
routers.use(`${Strings.API_PREFIX}/post`, postRouter);

// 5.Admin
routers.use(`${Strings.API_PREFIX}/admin`, adminRouter);
// #. Check Health - test server
routers.use('/health', (_req, res) => {
  res.ok({
    message: '🤗 OK 🤗',
    data: {
      uptime: process.uptime(),
      responseTime: process.hrtime(),
      timestamp: Date.now()
    }
  });
});

//
//! Access video or image *Import trước check Unknown route*
routers.use('/resources', express.static(getStandardPath('../../uploads')));

// -----

//! Unknown route
routers.get('*', (_req, _res, next) => {
  console.log(_req);
  next(new NotFoundError(Message.ROUTE_NOT_FOUND.msg));
});

// -----

// - Export modules
export * from './api_key/index.js';
export * from './block/index.js';
export * from './core/index.js';
export * from './friend/index.js';
// export * from './dev_token/index.js';
// export * from './friend/index.js';
export * from './friend/friend_request/index.js';
export * from './post/category/category.model.js';
export * from './post/feel/feel.model.js';
export * from './post/index.js';
export * from './post/mark/mark.model.js';
export * from './post/post_history/post.history.js';
// export * from './post/post_image/index.js';
// export * from './post/post_video/index.js';
// export * from './post/post_view/post_view.model.js';
export * from './post/report/report.model.js';
export * from './push_setting/index.js';
export * from './user/dev_token/device_token.model.js';
export * from './user/index.js';
export * from './user/verify_code/verify_code.model.js';
