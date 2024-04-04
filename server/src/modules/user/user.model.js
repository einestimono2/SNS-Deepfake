import { DataTypes } from 'sequelize';

import { Block } from '../block/block.model.js';
import { FriendRequest } from '../friend/components/friend_request.model.js';
import { Friend } from '../friend/friend.model.js';
import { PushSetting } from '../push_setting/push_setting.model.js';

import { Roles, accountStatus } from '#constants';
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
    default: Roles.Parent
  },
  avatar: {
    type: DataTypes.STRING
  },
  phone_number: {
    type: DataTypes.STRING
    // allowNull: false
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
  },
  lastActive: {
    type: DataTypes.DATE,
    allowNull: true
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
// blocked:danh sách người dùng chặn bạn
User.hasMany(Block, { foreignKey: 'targetId', as: 'blocked' });
// blocking:danh sách người dùng bị chặn bởi bạn
User.hasMany(Block, { foreignKey: 'userId', as: 'blocking' });
// friendRequested:danh sách người dùng gửi yêu cầu kết bạn tới bạn
User.hasMany(FriendRequest, { foreignKey: 'targetId', as: 'friendRequested' });
// friendRequesting :danh sách người dùng gửi yêu cầu kết bạn tới bạn
User.hasMany(FriendRequest, { foreignKey: 'userId', as: 'friendRequesting' });
User.hasMany(Friend, { foreignKey: 'userId', as: 'friends' });
User.hasOne(PushSetting, { foreignKey: 'userId', as: 'pushSettings' });

// Quan hệ giữa Block và User
Block.belongsTo(User, { foreignKey: 'userId', as: 'user' });
Block.belongsTo(User, { foreignKey: 'targetId', as: 'target' });
