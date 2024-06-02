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
    allowNull: true
  },
  coverPhoto: {
    type: DataTypes.STRING,
    allowNull: true
  },
  creatorId: {
    type: DataTypes.INTEGER,
    allowNull: false
  }
});

(() => {
  // Group ---sở hữu---*> Post

  // Group.hasMany(Post, { foreignKey: 'groupId', as: 'posts', onDelete: 'CASCADE' });
  // Post.belongsToMany(Group, {
  //   through: PostGroup,
  //   foreignKey: 'postId',
  //   as: 'groups'
  // });
  // Group.belongsToMany(Post, {
  //   through: PostGroup,
  //   foreignKey: 'groupId',
  //   as: 'posts'
  // });

  Group.hasMany(Post, { foreignKey: 'groupId', as: 'posts' });
  Post.belongsTo(Group, { foreignKey: 'groupId', as: 'group' });

  // Post.hasMany(PostGroup, { foreignKey: 'postId' });
  // PostGroup.belongsTo(Post, { foreignKey: 'postId' });

  Group.sync({ alter: true }).then(() => logger.info("Table 'Group' synced!"));
})();
