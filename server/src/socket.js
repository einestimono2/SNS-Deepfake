import { Server } from 'socket.io';

import { logger } from '#utils';

export class SocketServer {
  static instance;

  io;

  constructor(server) {
    this.io = new Server(server, {
      serveClient: false,
      pingInterval: 10000,
      pingTimeout: 5000,
      cookie: false,
      cors: {
        origin: '*'
      }
    });

    this.io.on('connect', this.onConnection);
  }

  static getInstance(server) {
    if (!SocketServer.instance) {
      SocketServer.instance = new SocketServer(server);
    }

    return SocketServer.instance;
  }

  /**
   * io.to(room).emit('event', ...) ==> Gửi sự kiện 'event' tới tất cả client có trong phòng
   * socket.broadcast.to(room).emit('event', ...) ==> Gửi sự kiện 'event' tới tất cả client có trong phòng trừ người gửi thông điệp ban đầu
   * socket.to(room).emit('event', ...) ==> Là cách viết ngắn gọn của socket.broadcast.to(room).emit('event', ...)
   *
   * socket.emit('event', ...) ==> Gửi sự kiện 'event'  tới client mà gửi thông điệp
   * io.emit('event', ...) ==> Gửi sự kiện 'event' tới tất cả client
   */
  onConnection = (socket) => {
    logger.info(`User '${socket.id}' connected!`);

    // Kết thúc (Done or out)
    socket.on('disconnect', () => {
      logger.info(`User '${socket.id}' disconnected!`);
    });

    // Events
  };
}
