/* eslint-disable no-unused-vars */
import { Server, Socket } from 'socket.io';

import { SocketEvents } from '#constants';
import { logger } from '#utils';

class SocketServer {
  /** @type {SocketServer} */ static instance;

  /** @type {Server} */ io;

  /**
   * User có thể đăng nhập trên nhiều thiết bị hoặc trên các nền tảng
   * Map: userId => [socketId]
   */
  mapper;

  static getInstance() {
    if (!SocketServer.instance) {
      SocketServer.instance = new SocketServer();
    }

    return SocketServer.instance;
  }

  init(server) {
    this.io = new Server(server, {
      serveClient: false,
      pingInterval: 10000,
      pingTimeout: 5000,
      cookie: false,
      cors: {
        origin: '*'
      }
    });

    this.mapper = new Map();

    this.io.on('connect', this.onConnection);
  }

  /**
   * io.emit ==> Gửi event tới tất cả client kết nối với server
   * io.to(room).emit ==> Gửi event tới tất cả client có trong room đó
   * io.to(id).emit ==> Gửi event tới socket id đó
   *
   * socket.emit ==> Gửi event tới client đó
   * socket.to(id).emit ==> Gửi event tới client id đó
   * socket.to(room).emit ==> Gửi event tới tất cả client có trong room đó
   * socket.broadcast.to(room).emit ==> Gửi event tới tất cả client (ngoại trừ client đó) ở trong room đó
   * socket.broadcast.emit ==> Gửi event tới tất cả client (ngoại trừ client đó)
   */
  onConnection = (/** @type {Socket} */ socket) => {
    const userId = Number(socket.handshake.query.userId);
    if (userId) this.addToMapper(userId, socket.id);

    logger.info(`User '${userId}' connected with socket '${socket.id}'!`);
    logger.info([...this.mapper.entries()]);

    // Ngắt kết nối
    socket.on('disconnect', () => {
      this.removeFromMapper(userId, socket.id);
      this.io.emit(SocketEvents.USER_ONLINE, [...this.mapper.keys()]);

      logger.info(`User '${userId}' disconnected with socket '${socket.id}'!`);
    });

    // ==================== All Events ====================

    // 0. Online
    this.io.emit(SocketEvents.USER_ONLINE, [...this.mapper.keys()]);

    // 1. Join conversation
    socket.on(SocketEvents.CONVERSATION_JOIN, ({ conversationId }) => {
      socket.join(conversationId);
    });

    // 2. Leave conversation
    socket.on(SocketEvents.CONVERSATION_LEAVE, ({ conversationId }) => {
      socket.leave(conversationId);
    });

    // 3. Typing --> FE: nên set sau x (s) thì tự end typing kể cả người đó vẫn đang nhập
    socket.on(SocketEvents.TYPING_START, ({ members, conversationId }) => {
      this.triggerEvent(members, SocketEvents.TYPING_START, { conversationId, userId });
    });
    socket.on(SocketEvents.TYPING_END, ({ members, conversationId }) => {
      this.triggerEvent(members, SocketEvents.TYPING_END, { conversationId, userId });
    });

    socket.on('test', (data) => {
      const arr = this.mapUserIdsToSocketIds([5, 7, 9]);

      console.log(arr);
    });

    // ==================== End Events ====================
  };

  addToMapper(userId, socketId) {
    if (this.mapper.get(userId)?.push(socketId)) return;

    this.mapper.set(userId, [socketId]);
  }

  removeFromMapper(userId, socketId) {
    if (!userId || !socketId) return;

    const values = this.mapper.get(userId);

    if (values.length === 1) this.mapper.delete(userId);
    else
      this.mapper.set(
        userId,
        values.filter((value) => value !== socketId)
      );
  }

  mapUserIdsToSocketIds(userIds) {
    return userIds.reduce((result, value) => {
      const values = this.mapper.get(value);

      if (values) {
        result = result.concat(values);
      }

      return result;
    }, []);
  }

  triggerEvent(room, event, data) {
    let _room;

    // Truyền mảng users
    if (Array.isArray(room)) {
      _room = this.mapUserIdsToSocketIds(room);
    } else {
      _room = this.mapper.get(room) ?? room;
    }

    this.io.to(_room).emit(event, data);
  }
}

export const socket = SocketServer.getInstance();
