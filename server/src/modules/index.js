import express from 'express';
import path from 'path';

import { Message } from '#constants';
import { NotFoundError } from '#modules';

export const routers = express.Router();

// Test
routers.use('/health', (_req, res) => {
  res.ok({
    message: 'OK 🤗',
    data: {
      uptime: process.uptime(),
      responseTime: process.hrtime(),
      timestamp: Date.now()
    }
  });
});

// Routes

//! Static - Import trước check Unknown route
routers.use('/files', express.static(path.join(path.resolve(), '../uploads')));

//! Unknown route
routers.get('*', (_req, _res, next) => {
  next(new NotFoundError(Message.ROUTE_NOT_FOUND.msg));
});

// - Export modules
export * from './core/index.js';
