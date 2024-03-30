import { DataTypes } from 'sequelize';

import { postgre } from '#dbs';
import { logger } from '#utils';

export const Category = postgre.define('Category', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  name: {
    type: DataTypes.STRING,
    allowNull: true
  },
  hasName: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  }
});

(() => {
  // Code here
  Category.sync({ alter: true }).then(() => logger.info("Table 'Category' synced!"));
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
