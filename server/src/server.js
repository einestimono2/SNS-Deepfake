import { createServer } from 'http';

import { app } from '##/app';
import { SocketServer } from '##/socket';
import { app as appConfig } from '#configs';
import { logger } from '#utils';

const PORT = appConfig.port;
const httpServer = createServer(app);

//! Socket Server
SocketServer.getInstance(httpServer);

//! Http Server
export const server = httpServer.listen(PORT, () => {
  logger.info(`Server ⭐ Running at port ${PORT}`);
});

process.on('SIGINT', () => {
  server.close(() => {
    logger.info('Exit express server!');
    process.exit();
  });
});
