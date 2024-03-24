import Redis from 'ioredis';

import { isDevelopment, redis as redisConfigs } from '#configs';
import { logger } from '#utils';

class RedisDatabase {
  static instance;

  constructor() {
    this.connect();
  }

  connect() {
    const _redis = new Redis({
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

    // if (isDevelopment()) {
    _redis.on('connect', () => {
      logger.info(`Redis connected with ${redisConfigs.host}:${redisConfigs.port}`);
    });

    _redis.on('error', (error) => {
      logger.error('Redis connection failed: ', error);
    });
    // }

    this.instance = _redis;
  }

  static getInstance() {
    if (!RedisDatabase.instance) {
      // eslint-disable-next-line no-new
      new RedisDatabase();
    }

    return RedisDatabase.instance;
  }
}

export const redis = RedisDatabase.getInstance();
