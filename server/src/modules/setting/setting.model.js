import { DataTypes } from 'sequelize';

import { postgre } from '#dbs';
import { logger } from '#utils';

export const Setting = postgre.define('Setting', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  userId: {
    type: DataTypes.INTEGER
  },
  likeComment: {
    type: DataTypes.BOOLEAN,
    defaultValue: true
  },
  fromFriends: {
    type: DataTypes.BOOLEAN,
    defaultValue: true
  },
  friendRequests: {
    type: DataTypes.BOOLEAN,
    defaultValue: true
  },
  suggestedFriends: {
    type: DataTypes.BOOLEAN,
    defaultValue: true
  },
  birthdays: {
    type: DataTypes.BOOLEAN,
    defaultValue: true
  },
  videos: {
    type: DataTypes.BOOLEAN,
    defaultValue: true
  },
  reports: {
    type: DataTypes.BOOLEAN,
    defaultValue: true
  },
  soundOn: {
    type: DataTypes.BOOLEAN,
    defaultValue: true
  },
  notificationOn: {
    type: DataTypes.BOOLEAN,
    defaultValue: true
  },
  vibrationOn: {
    type: DataTypes.BOOLEAN,
    defaultValue: true
  },
  ledOn: {
    type: DataTypes.BOOLEAN,
    defaultValue: true
  }
});

(() => {
  Setting.sync({ alter: true }).then(() => logger.info("Table 'Setting' synced!"));
})();
