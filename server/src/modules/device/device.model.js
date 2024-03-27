// models/reaction.model.js

import { DataTypes } from 'sequelize';

import { postgre } from '#dbs';
import { logger } from '#utils';

export const Device = postgre.define('Device', {
  id: {
    allowNull: false,
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  user_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: 'Users',
      key: 'id'
    }
  },
  device_uuid: {
    type: DataTypes.STRING,
    allowNull: false
  },
  device_name: {
    type: DataTypes.STRING,
    allowNull: false
  },
  createdAt: {
    type: DataTypes.DATE,
    allowNull: false
  },
  updatedAt: {
    type: DataTypes.DATE
  }
});
(() => {
  // Code here
  Device.sync().then(() => logger.info("Table 'Devices' synced!"));
})();
