import dotenv from 'dotenv';

import { EnvTypes } from '#constants';

//! Cấu hình env
dotenv.config();

const dev = {
  app: {
    env: process.env.NODE_ENV ?? EnvTypes.dev,
    port: process.env.DEV_APP_PORT
  },
  postgre: {
    database: process.env.DEV_POSTGRE_DATABASE,
    username: process.env.DEV_POSTGRE_USERNAME,
    password: process.env.DEV_POSTGRE_PASSWORD,
    host: process.env.DEV_POSTGRE_HOST,
    port: process.env.DEV_POSTGRE_PORT,
    dialect: 'postgres'
  },
  redis: {
    port: process.env.DEV_REDIS_PORT,
    host: process.env.DEV_REDIS_HOST,
    username: process.env.DEV_REDIS_USERNAME,
    password: process.env.DEV_REDIS_PASSWORD === 'undefined' ? undefined : process.env.DEV_REDIS_PASSWORD
  }
};

const prod = {
  app: {
    env: process.env.NODE_ENV ?? EnvTypes.dev,
    port: process.env.PROD_APP_PORT
  },
  postgre: {
    database: process.env.PROD_POSTGRE_DATABASE,
    username: process.env.PROD_POSTGRE_USERNAME,
    password: process.env.PROD_POSTGRE_PASSWORD,
    host: process.env.PROD_POSTGRE_HOST,
    port: process.env.PROD_POSTGRE_PORT,
    dialect: 'postgres'
  },
  redis: {
    port: process.env.PROD_REDIS_PORT,
    host: process.env.PROD_REDIS_HOST,
    username: process.env.PROD_REDIS_USERNAME,
    password: process.env.PROD_REDIS_PASSWORD === 'undefined' ? undefined : process.env.PROD_REDIS_PASSWORD
  }
};

const configs = process.env.NODE_ENV === EnvTypes.prod ? prod : dev;

export const isProduction = () => process.env.NODE_ENV === EnvTypes.prod;
export const isDevelopment = () => process.env.NODE_ENV === EnvTypes.dev;

export const { app, postgre, redis } = configs;
