import Redis from 'ioredis';

import { isDevelopment, redis as redisConfigs } from '#configs';
import { Message, Vars } from '#constants';
import { RedisTimeoutError } from '#modules';
import { logger } from '#utils';

class RedisDatabase {
  static instance = null;

  redis;

  #timeoutEvent;

  constructor() {
    if (RedisDatabase.instance) {
      return RedisDatabase.instance;
    }

    this.initConnection();

    RedisDatabase.instance = this;
  }

  static getInstance() {
    if (!RedisDatabase.instance) {
      return new RedisDatabase();
    }

    return RedisDatabase.instance;
  }

  initConnection() {
    this.redis = new Redis({
      port: redisConfigs.port,
      host: redisConfigs.host,
      username: redisConfigs.username,
      password: redisConfigs.password,
      //
      retryStrategy(times) {
        const delay = Math.min(times * 50, 2000);
        return delay;
      },
      showFriendlyErrorStack: isDevelopment()
    });

    this.handleEvent();
  }

  handleEvent() {
    this.redis.on('connect', () => {
      logger.info(`Redis ⭐ Connected with '${redisConfigs.host}:${redisConfigs.port}'`);

      clearTimeout(this.#timeoutEvent);
    });

    this.redis.on('reconnecting', () => {
      logger.warn(`Redis ⭐ Trying to reconnect to '${redisConfigs.host}:${redisConfigs.port}'`);

      clearTimeout(this.#timeoutEvent);
    });

    this.redis.on('error', (error) => {
      logger.error('Redis ⭐ Connection failed: ', error);

      this.handleTimeout();
    });

    this.redis.on('end', () => {
      logger.info(`Redis ⭐ Disconnected to ''${redisConfigs.host}:${redisConfigs.port}''`);

      this.handleTimeout();
    });
  }

  handleTimeout() {
    this.#timeoutEvent = setTimeout(() => {
      throw new RedisTimeoutError(Message.REDIS_CONNECTION_ERROR);
    }, Vars.REDIS_CONNECT_TIMEOUT);
  }
}

export const { redis } = RedisDatabase.getInstance();
