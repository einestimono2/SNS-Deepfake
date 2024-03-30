import { DataTypes } from 'sequelize';

import { postgre } from '#dbs';
import { logger } from '#utils';

export const Block = postgre.define('Block', {
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
  // Code here
  Block.sync({ alter: true }).then(() => logger.info("Table 'Block' synced!"));
})();
// Định nghĩa các mối quan hệ
// Block.belongsTo(User, {
//   foreignKey: 'targetId',
//   as: 'target',
//   onDelete: 'CASCADE'
// });
// Block.belongsTo(User, {
//   foreignKey: 'userId',
//   as: 'user',
//   onDelete: 'CASCADE'
// });
