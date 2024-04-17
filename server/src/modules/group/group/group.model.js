import { DataTypes } from 'sequelize';

import { Post } from '../../post/post.model.js';

import { postgre } from '#dbs';
import { logger } from '#utils';

export const Group = postgre.define('Group', {
  id: {
    allowNull: false,
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  groupName: {
    type: DataTypes.STRING,
    allowNull: false
  },
  description: {
    type: DataTypes.STRING,
    allowNull: false
  },
  coverPhoto: {
    type: DataTypes.STRING,
    allowNull: false
  },
  creatorId: {
    type: DataTypes.INTEGER,
    allowNull: false
  }
});

(() => {
  // User ---sở hữu---*> Group
  // User.hasMany(Group, { foreignKey: 'creatorId', as: 'own_group' });
  // Group.belongsTo(User, { foreignKey: 'creatorId', as: 'group_owner' });
  Group.hasMany(Post, { foreignKey: 'groupId', as: 'posts', onDelete: 'CASCADE' });
  // Post.belongsTo(Group, { foreignKey: 'groupId', as: 'group' });
  Group.sync({ alter: true }).then(() => logger.info("Table 'Group' synced!"));
})();
