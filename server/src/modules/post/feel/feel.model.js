// models/reaction.model.js

import { DataTypes } from 'sequelize';

import { postgre } from '#dbs';
import { logger } from '#utils';

export const Feel = postgre.define('Feel', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  postId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  type: {
    type: DataTypes.SMALLINT,
    allowNull: false
  },
  editable: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  },
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false
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
  Feel.sync({ alter: true }).then(() => logger.info("Table 'Feel' synced!"));
})();
