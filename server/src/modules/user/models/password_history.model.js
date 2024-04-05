import { DataTypes } from 'sequelize';

import { postgre } from '#dbs';
import { logger } from '#utils';

export const PasswordHistory = postgre.define('PasswordHistory', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  password: {
    type: DataTypes.STRING,
    allowNull: false
  }
});
(() => {
  // Code here
  PasswordHistory.sync({ alter: true }).then(() => logger.info("Table 'PasswordHistory' synced!"));
})();
