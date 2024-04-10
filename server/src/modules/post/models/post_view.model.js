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
    unique: true
  },
  postId: {
    type: DataTypes.INTEGER,
    unique: true
  },
  count: {
    type: DataTypes.STRING
  }
});

(() => {
  PostView.sync({ alter: true }).then(() => logger.info("Table 'PostView' synced!"));
})();
