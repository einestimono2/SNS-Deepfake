import { DataTypes } from 'sequelize';

import { DeepfakeVideo } from '../deepfake_video/deepfake_video.model.js';
import { User } from '../user/user.model.js';

import { postgre } from '#dbs';
import { logger } from '#utils';

export const VideoSchedule = postgre.define('VideoSchedule', {
  id: {
    allowNull: false,
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  videoId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  targetId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  time: {
    type: DataTypes.DATE,
    allowNull: false
  }
});

(() => {
  // PostVideo.hasMany(VideoSchedule, { foreignKey: 'videoId' });
  VideoSchedule.belongsTo(DeepfakeVideo, { foreignKey: 'videoId', as: 'video' });
  VideoSchedule.belongsTo(User, { foreignKey: 'userId', as: 'sender' });
  VideoSchedule.belongsTo(User, { foreignKey: 'targetId', as: 'receiver' });
  VideoSchedule.sync({ alter: true }).then(() => logger.info("Table 'VideoSchedule' synced!"));
})();
