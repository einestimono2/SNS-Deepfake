import { createServer } from 'http';

import { app } from '##/app';
import { socket as SocketServer } from '##/modules/socket/socket';
import { app as appConfig } from '#configs';
import { logger } from '#utils';

const PORT = appConfig.port;
const httpServer = createServer(app);

//! Socket Server
SocketServer.init(httpServer);

//! Http Server
export const server = httpServer.listen(PORT, () => {
  logger.info(`Server ⭐ Running at port ${PORT}`);
});

// Process Events
process.on('SIGINT', () => {
  server.close(() => {
    logger.info('Exit express server!');
    process.exit();
  });
});

process
  .on('unhandledRejection', (reason, p) => {
    console.error(reason, 'Unhandled Rejection at Promise', p);
  })
  .on('uncaughtException', (err) => {
    console.error(err, 'Uncaught Exception thrown');
  });
