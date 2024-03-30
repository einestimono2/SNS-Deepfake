// models/reaction.model.js

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

// Định nghĩa các mối quan hệ
// Friend.belongsTo(User, {
//   foreignKey: 'targetId',
//   as: 'target',
//   onDelete: 'CASCADE'
// });
// Friend.belongsTo(User, {
//   foreignKey: 'userId',
//   as: 'user',
//   onDelete: 'CASCADE'
// });
(() => {
  // Code here
  Friend.sync({ alter: true }).then(() => logger.info("Table 'Friend' synced!"));
})();
