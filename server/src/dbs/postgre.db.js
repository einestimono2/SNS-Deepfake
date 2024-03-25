import { Sequelize } from 'sequelize';

import { isDevelopment, postgre as postgreConfigs } from '#configs';
import { logger } from '#utils';

class PostgreDatabase {
  static instance = null;

  sequelize;

  constructor() {
    if (PostgreDatabase.instance) {
      return PostgreDatabase.instance;
    }

    this.initConnection();

    PostgreDatabase.instance = this;
  }

  static getInstance() {
    if (!PostgreDatabase.instance) {
      return new PostgreDatabase();
    }

    return PostgreDatabase.instance;
  }

  initConnection() {
    this.sequelize = new Sequelize({
      database: postgreConfigs.database,
      username: postgreConfigs.username,
      password: postgreConfigs.password,
      host: postgreConfigs.host,
      port: postgreConfigs.port,
      dialect: postgreConfigs.dialect,
      timezone: '+07:00',
      // replication: ,
      pool: {
        max: 22
      },
      typeValidation: true,
      logQueryParameters: isDevelopment()
    });
  }

  testConnect() {
    this.sequelize
      .authenticate()
      .then(() => {
        logger.info(`PostgreSQL ⭐ Connected with ${postgreConfigs.host}:${postgreConfigs.port}`);
      })
      .catch((error) => {
        logger.error('PostgreSQL ⭐ Unable to connect to the database: ', error);
      });
  }
}

export const postgreDb = PostgreDatabase.getInstance();
export const postgre = /** @type {Sequelize} */ (PostgreDatabase.getInstance().sequelize);
