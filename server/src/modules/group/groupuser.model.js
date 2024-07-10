import { DataTypes } from 'sequelize';

import { User } from '../user/user.model.js';

import { Group } from './group/group.model.js';

import { postgre } from '#dbs';
import { logger } from '#utils';

export const GroupUser = postgre.define(
  'GroupUser',
  {
    id: {
      allowNull: false,
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    groupId: {
      type: DataTypes.INTEGER
    },
    userId: {
      type: DataTypes.INTEGER
    },
    // Biệt danh của member
    nickname: {
      type: DataTypes.STRING,
      defaultValue: null
    }
  },
  {
    deletedAt: true
  }
);

(() => {
  User.belongsToMany(Group, {
    through: GroupUser,
    foreignKey: 'userId',
    as: 'my_group'
  });
  Group.belongsToMany(User, {
    through: GroupUser,
    foreignKey: 'groupId',
    as: 'members'
  });

  Group.hasMany(GroupUser, { foreignKey: 'groupId', as: 'userofgroup' });
  GroupUser.belongsTo(Group, { foreignKey: 'groupId', as: 'groupofuser' });

  User.hasMany(GroupUser, { foreignKey: 'userId' });
  GroupUser.belongsTo(User, { foreignKey: 'userId', as: 'user' });
  // GroupUser.belongsTo(Group, { foreignKey: 'groupId' });
  GroupUser.sync({ alter: true }).then(() => logger.info("Table 'GroupUser' synced!"));
})();
