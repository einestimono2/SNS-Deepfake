import { DataTypes } from 'sequelize';

import { Block } from '../block/index.js';
import { FriendRequest } from '../friend/friend_request/index.js';
import { Friend } from '../friend/index.js';
import { PushSetting } from '../push_setting/index.js';

import { Roles, accountStatus } from '##/constants/enum.constant';
import { postgre } from '#dbs';
import { logger } from '#utils';

export const User = postgre.define('User', {
  id: {
    allowNull: false,
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  role: {
    type: DataTypes.STRING,
    allowNull: false,
    default: Roles.Parent
  },
  avatar: {
    type: DataTypes.STRING
  },
  phone_number: {
    type: DataTypes.STRING,
    allowNull: false
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false
  },
  password: {
    type: DataTypes.STRING,
    allowNull: false
  },
  token: {
    type: DataTypes.STRING,
    allowNull: true
  },
  username: {
    type: DataTypes.STRING
  },
  status: {
    type: DataTypes.INTEGER,
    default: accountStatus.Pending
  },
  coins: {
    type: DataTypes.STRING
  }
  // family_id: {
  //   type: DataTypes.INTEGER,
  //   references: {
  //     model: 'Families',
  //     key: 'id'
  //   },
  //   default: '0'
  // }
});

(() => {
  // Code here
  User.sync({ alter: true }).then(() => logger.info("Table 'User' synced!"));
})();
// Định nghĩa các mối quan hệ
User.hasMany(Block, { foreignKey: 'targetId', as: 'blocked' });
User.hasMany(Block, { foreignKey: 'userId', as: 'blocking' });
User.hasMany(FriendRequest, { foreignKey: 'targetId', as: 'friendRequested' });
User.hasMany(FriendRequest, { foreignKey: 'userId', as: 'friendRequesting' });
User.hasMany(Friend, { foreignKey: 'userId', as: 'friends' });
User.hasOne(PushSetting, { foreignKey: 'userId', as: 'pushSettings' });
