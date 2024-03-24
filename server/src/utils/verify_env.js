import assert from 'assert';

import { logger } from '#utils';

const requiredEnvs = [
  'DEV_APP_PORT',
  'PROD_APP_PORT',
  'DEV_POSTGRE_DATABASE',
  'DEV_POSTGRE_USERNAME',
  'DEV_POSTGRE_PASSWORD',
  'DEV_POSTGRE_HOST',
  'DEV_POSTGRE_PORT',
  'PROD_POSTGRE_DATABASE',
  'PROD_POSTGRE_USERNAME',
  'PROD_POSTGRE_PASSWORD',
  'PROD_POSTGRE_HOST',
  'PROD_POSTGRE_PORT',
  'DEV_REDIS_PORT',
  'DEV_REDIS_HOST',
  'DEV_REDIS_USERNAME',
  'DEV_REDIS_PASSWORD',
  'PROD_REDIS_PORT',
  'PROD_REDIS_HOST',
  'PROD_REDIS_USERNAME',
  'PROD_REDIS_PASSWORD'
];

export const verifyEnvironmentVariables = () => {
  let _var;

  requiredEnvs.forEach((env) => {
    try {
      // assert(process.env[(_var = requiredEnvs[1])], `[.env] "${_var}" is required!`);
      assert(process.env[(_var = env)], `[.env] "${_var}" is required!`);
    } catch (error) {
      logger.error(error);
      process.exit();
    }
  });
};
