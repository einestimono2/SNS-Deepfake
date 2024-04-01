import { DataTypes } from 'sequelize';

import { User } from '../user.model.js';

import { postgre } from '#dbs';
import { logger } from '#utils';

export const DevToken = postgre.define('DevToken', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  userId: {
    type: DataTypes.INTEGER
  },
  type: {
    type: DataTypes.INTEGER
  },
  token: {
    type: DataTypes.STRING
  }
});
(() => {
  // Code here
  DevToken.sync({ alter: true }).then(() => logger.info("Table 'DevToken' synced!"));
})();
// Định nghĩa mối quan hệ
// DevToken.belongsTo(User, { foreignKey: 'userId', onDelete: 'CASCADE' });
