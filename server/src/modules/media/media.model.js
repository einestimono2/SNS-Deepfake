import { DataTypes } from 'sequelize';

import { User } from '../user/user.model.js';

import { postgre } from '#dbs';
import { logger } from '#utils';

export const Media = postgre.define('Media', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  fileName: {
    type: DataTypes.INTEGER
  },
  url: {
    type: DataTypes.STRING,
    allowNull: true
  },
  size: {
    type: DataTypes.STRING,
    allowNull: true
  },
  fileType: {
    type: DataTypes.INTEGER,
    defaultValue: 0
  },
  userId: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  thumbnailUrl: {
    type: DataTypes.INTEGER
  },
  description: {
    type: DataTypes.INTEGER,
    allowNull: true
  }
});

(() => {
  // Định nghĩa các mối quan hệ
  // User ---sở hữu---*> Media(quan hệ 1-n)
  User.hasMany(Media, { foreignKey: 'userId', as: 'media', onDelete: 'CASCADE' });
  Media.belongsTo(User, { foreignKey: 'userId', as: 'user', onDelete: 'CASCADE' });
  Media.sync({ alter: true }).then(() => logger.info("Table 'Media' synced!"));
})();
