import { DataTypes } from 'sequelize';

import { postgre } from '#dbs';
import { logger } from '#utils';

export const Call = postgre.define('Call', {
  id: {
    allowNull: false,
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  // ref - user
  members: {
    type: DataTypes.ARRAY(DataTypes.INTEGER),
    defaultValue: []
  },
  // ref - user
  senderId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  type: {
    type: DataTypes.ENUM({
      values: ['Audio', 'Video']
    }),
    allowNull: false
  },
  verdict: {
    type: DataTypes.ENUM({
      values: ['Accepted', 'Denied', 'Missed', 'Busy']
    }),
    allowNull: false
  },
  status: {
    type: DataTypes.ENUM({
      values: ['Ongoing', 'Ended']
    }),
    allowNull: false
  },
  startedAt: {
    type: DataTypes.DATE,
    default: DataTypes.NOW
  },
  endedAt: {
    type: DataTypes.DATE
  }
});

(() => {
  Call.sync({ alter: true }).then(() => logger.info("Table 'Call' synced!"));
})();
