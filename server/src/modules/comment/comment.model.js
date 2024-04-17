import { DataTypes } from 'sequelize';

import { Mark } from '../post/models/mark.model.js';
import { User } from '../user/user.model.js';

import { postgre } from '#dbs';
import { logger } from '#utils';

export const Comment = postgre.define('Comment', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  markId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  content: {
    type: DataTypes.TEXT,
    allowNull: false
  },
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false
  }
});

(() => {
  Comment.sync({ alter: true }).then(() => logger.info("Table 'Comment' synced!"));
})();
// Comment.belongsTo(Mark, { foreignKey: 'markId', onDelete: 'CASCADE' });
// Comment.belongsTo(User, { foreignKey: 'userId', onDelete: 'CASCADE' });
