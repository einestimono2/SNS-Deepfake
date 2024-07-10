import { DataTypes } from 'sequelize';

import { User } from '../user/user.model.js';

import { postgre } from '#dbs';
import { logger } from '#utils';

export const DeepfakeVideo = postgre.define('DeepfakeVideo', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  url: {
    type: DataTypes.STRING,
    allowNull: false
  },
  title: {
    type: DataTypes.STRING,
    allowNull: false
  },
  status: {
    type: DataTypes.INTEGER,
    allowNull: false,
    defaultValue: 0
  },
  userId: {
    type: DataTypes.INTEGER,
    allowNull: true
  }
});

(() => {
  // Định nghĩa các mối quan hệ
  // User ---sở hữu---*> Media(quan hệ 1-n)
  User.hasMany(DeepfakeVideo, { foreignKey: 'userId', as: 'deepfakevideosofuser', onDelete: 'CASCADE' });
  DeepfakeVideo.belongsTo(User, { foreignKey: 'userId', as: 'user', onDelete: 'CASCADE' });

  DeepfakeVideo.sync({ alter: true }).then(() => logger.info("Table 'DeepfakeVideo' synced!"));
})();
