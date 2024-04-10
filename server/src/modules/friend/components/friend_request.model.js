import { DataTypes } from 'sequelize';

import { postgre } from '#dbs';
import { logger } from '#utils';

export const FriendRequest = postgre.define('FriendRequest', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  targetId: {
    type: DataTypes.INTEGER
  },
  userId: {
    type: DataTypes.INTEGER
  },
  read: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  }
});

(() => {
  FriendRequest.sync({ alter: true }).then(() => logger.info("Table 'FriendRequest' synced!"));
})();
