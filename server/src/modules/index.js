import express from 'express';

import { adminRouter } from './admin/admin.route.js';
import { apiKeyRouter } from './api_key/api_key.route.js';
import { blockRouter } from './block/block.route.js';
import { NotFoundError } from './core/index.js';
import { postRouter } from './post/post.route.js';
import { uploadRouter } from './upload/upload.route.js';
import { userRouter } from './user/user.route.js';

import { videoRouter } from '##/modules/video/video.route';
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
// 5.Block
routers.use(`${Strings.API_PREFIX}/block`, blockRouter);
// 6. Video
routers.use(`${Strings.API_PREFIX}/video`, videoRouter);
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
export * from './api_key/api_key.model.js';
export * from './api_key/api_key.service.js';
export * from './core/index.js';
