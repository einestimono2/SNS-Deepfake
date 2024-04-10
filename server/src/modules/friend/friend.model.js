import { DataTypes } from 'sequelize';

import { postgre } from '#dbs';
import { logger } from '#utils';

export const Friend = postgre.define('Friend', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  targetId: {
    type: DataTypes.INTEGER
  },
  userId: {
    type: DataTypes.INTEGER
  }
});

(() => {
  Friend.sync({ alter: true }).then(() => logger.info("Table 'Friend' synced!"));
})();
