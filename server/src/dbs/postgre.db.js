import { Sequelize } from 'sequelize';

import { isDevelopment, postgre } from '#configs';
import { logger } from '#utils';

// Instance
class PostgreDatabase {
  static instance;

  // constructor() {
  //   this.connect();
  // }

  connect() {
    const sequelize = new Sequelize({
      database: postgre.database,
      username: postgre.username,
      password: postgre.password,
      host: postgre.host,
      port: postgre.port,
      dialect: postgre.dialect,
      timezone: '+07:00',
      // replication: ,
      pool: {
        max: 22
      },
      typeValidation: true,
      logQueryParameters: isDevelopment()
    });

    sequelize
      .authenticate()
      .then(() => {
        logger.info(`PostgreSQL connected with ${postgre.host}:${postgre.port}`);
      })
      .catch((error) => logger.error('Unable to connect to the database: ', error));
  }

  static getInstance() {
    if (!PostgreDatabase.instance) {
      PostgreDatabase.instance = new PostgreDatabase();
    }

    return PostgreDatabase.instance;
  }
}

export const postgreDb = PostgreDatabase.getInstance();
