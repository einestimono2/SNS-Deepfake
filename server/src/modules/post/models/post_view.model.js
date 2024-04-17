import { DataTypes } from 'sequelize';

import { postgre } from '#dbs';
import { logger } from '#utils';

export const PostView = postgre.define('PostView', {
  id: {
    allowNull: false,
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  postId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  count: {
    type: DataTypes.INTEGER
  }
});

(() => {
  PostView.sync({ alter: true }).then(() => logger.info("Table 'PostView' synced!"));
})();
