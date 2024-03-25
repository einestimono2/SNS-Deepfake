import express from 'express';
import path from 'path';

import { Message, Strings } from '#constants';
import { apiKeyRouter } from './api_key/index.js';
import { NotFoundError } from './core/index.js';

export const routers = express.Router();

//! Check Health
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

//! Routes
routers.use(`${Strings.API_PREFIX}/apikey`, apiKeyRouter);

//! Static - Import trước check Unknown route
routers.use('/storage', express.static(path.join(path.resolve(), '../uploads')));

//! Unknown route
routers.get('*', (_req, _res, next) => {
  next(new NotFoundError(Message.ROUTE_NOT_FOUND.msg));
});

// - Export modules
export * from './api_key/index.js';
export * from './core/index.js';
