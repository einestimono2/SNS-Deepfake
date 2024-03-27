import express from 'express';

import { apiKeyRouter } from './api_key/index.js';
import { NotFoundError } from './core/index.js';
import { uploadRouter } from './upload/index.js';

import { Message, Strings } from '#constants';
import { getStandardPath } from '#utils';

export const routers = express.Router();

// ----- List routes -----
// 1. API Key
routers.use(`${Strings.API_PREFIX}/apikey`, apiKeyRouter);
// 2. Upload file & video
routers.use(`${Strings.API_PREFIX}/upload`, uploadRouter);

//

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
export * from './core/index.js';
