import { DataTypes } from 'sequelize';

import { Feel } from '../post/models/feel.model.js';
import { Mark } from '../post/models/mark.model.js';
import { Post } from '../post/post.model.js';
import { User } from '../user/user.model.js';

import { postgre } from '#dbs';
import { logger } from '#utils';

export const Notification = postgre.define('Notification', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  targetId: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  postId: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  markId: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  feelId: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  coins: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  type: {
    type: DataTypes.INTEGER
  },
  read: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  },
  action: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  },
  userId: {
    type: DataTypes.INTEGER
  }
});
(() => {
  // Định nghĩa mối quan hệ
  Notification.belongsTo(User, { foreignKey: 'userId', as: 'user', onDelete: 'CASCADE' });
  Notification.belongsTo(User, { foreignKey: 'targetId', as: 'target', onDelete: 'CASCADE' });
  Notification.belongsTo(Post, { foreignKey: 'postId', as: 'post', onDelete: 'CASCADE' });
  Notification.belongsTo(Mark, { foreignKey: 'markId', as: 'mark', onDelete: 'CASCADE' });
  Notification.belongsTo(Feel, { foreignKey: 'feelId', as: 'feel', onDelete: 'CASCADE' });
  Notification.sync({ alter: true }).then(() => logger.info("Table 'Notification' synced!"));
})();
