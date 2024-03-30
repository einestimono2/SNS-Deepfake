import { DataTypes } from 'sequelize';

import { postgre } from '#dbs';
import { logger } from '#utils';

export const PostImage = postgre.define('PostImage', {
  id: {
    allowNull: false,
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  postId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  url: {
    type: DataTypes.STRING,
    allowNull: false
  },
  order: {
    type: DataTypes.STRING,
    allowNull: true,
    defaultValue: 0
  }
});
(() => {
  // Code here
  PostImage.sync({ alter: true }).then(() => logger.info("Table 'PostImage' synced!"));
})();
