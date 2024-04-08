import { createServer } from 'http';

import { initializeApp, applicationDefault } from 'firebase-admin/app';

// import { serviceAccount } from '../firebase.json';

import { app } from '##/app';
import { SocketServer } from '##/socket';
import { app as appConfig } from '#configs';
import { logger } from '#utils';

//! Firebase cloud messaging
initializeApp({
  credential: applicationDefault(),
  projectId: 'sns-deepfake'
});

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

process
  .on('unhandledRejection', (reason, p) => {
    console.error(reason, 'Unhandled Rejection at Promise', p);
  })
  .on('uncaughtException', (err) => {
    console.error(err, 'Uncaught Exception thrown');
  });
