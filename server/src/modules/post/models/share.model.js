import { DataTypes } from 'sequelize';

import { User } from '../../user/user.model.js';

import { postgre } from '#dbs';
import { logger } from '#utils';

export const Share = postgre.define('Share', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  postId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  targetId: {
    type: DataTypes.INTEGER,
    defaultValue: false
  }
});

(() => {
  // Feel.belongsTo(User, { onDelete: 'CASCADE', as: 'user' });

  Share.sync({ alter: true }).then(() => logger.info("Table 'Share' synced!"));
})();
