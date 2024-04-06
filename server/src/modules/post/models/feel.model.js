// models/reaction.model.js

import { DataTypes } from 'sequelize';

import { User } from '../../user/user.model.js';

import { postgre } from '#dbs';
import { logger } from '#utils';

export const Feel = postgre.define('Feel', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  postId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  type: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  editable: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  },
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false
  }
});

(() => {
  Feel.belongsTo(User, { onDelete: 'CASCADE', as: 'user' });
  // Code here
  Feel.sync({ alter: true }).then(() => logger.info("Table 'Feel' synced!"));
})();
