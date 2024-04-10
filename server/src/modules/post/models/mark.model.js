import { DataTypes } from 'sequelize';

import { User } from '../../user/user.model.js';

import { postgre } from '#dbs';
import { logger } from '#utils';

export const Mark = postgre.define('Mark', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  postId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  content: {
    type: DataTypes.TEXT,
    allowNull: false
  },
  type: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  editable: {
    type: DataTypes.BOOLEAN,
    defaultValue: false // Giá trị mặc định cho trường editable là false
  },
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false
  }
});

(() => {
  // Mối quan hệ giữa Mark và User
  Mark.belongsTo(User, { onDelete: 'CASCADE', as: 'user' });

  // Sync
  Mark.sync({ alter: true }).then(() => logger.info("Table 'Mark' synced!"));
})();
