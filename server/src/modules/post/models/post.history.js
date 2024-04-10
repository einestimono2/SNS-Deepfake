import { DataTypes } from 'sequelize';

import { postgre } from '#dbs';
import { logger } from '#utils';

export const PostHistory = postgre.define('PostHistory', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  postId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  oldPostId: {
    type: DataTypes.INTEGER,
    allowNull: false
  }
});

(() => {
  PostHistory.sync({ alter: true }).then(() => logger.info("Table 'PostHistory' synced!"));
})();
