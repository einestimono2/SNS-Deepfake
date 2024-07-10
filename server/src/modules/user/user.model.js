import { DataTypes } from 'sequelize';

import { Block } from '../block/block.model.js';
import { Comment } from '../comment/comment.model.js';
import { FriendRequest } from '../friend/components/friend_request.model.js';
import { Friend } from '../friend/friend.model.js';
import { Feel } from '../post/models/feel.model.js';
import { Mark } from '../post/models/mark.model.js';
import { PostView } from '../post/models/post_view.model.js';
import { Setting } from '../setting/setting.model.js';

import { AccountStatus, Roles } from '#constants';
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
    type: DataTypes.INTEGER,
    default: Roles.Parent
  },
  avatar: {
    type: DataTypes.STRING
  },
  coverImage: {
    type: DataTypes.STRING
  },
  phoneNumber: {
    type: DataTypes.STRING
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
    default: AccountStatus.Pending
  },
  coins: {
    type: DataTypes.INTEGER
  },
  lastActive: {
    type: DataTypes.DATE,
    allowNull: true
  },
  deletedAt: {
    type: DataTypes.DATE,
    allowNull: true
  },
  parentId: {
    type: DataTypes.INTEGER,
    allowNull: true
  }
});

(() => {
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
  User.hasMany(Friend, { foreignKey: 'targetId', as: 'friends1' });
  User.hasOne(Setting, { foreignKey: 'userId', as: 'pushSettings' });

  // Quan hệ giữa Block và User
  Block.belongsTo(User, { foreignKey: 'userId', as: 'user' });
  Block.belongsTo(User, { foreignKey: 'targetId', as: 'target' });

  // Quan hệ giữa Mark và User
  // User.hasMany(Mark, { foreignKey: 'userId', onDelete: 'CASCADE', as: 'user' });
  Mark.belongsTo(User, { foreignKey: 'userId', onDelete: 'CASCADE', as: 'user' });
  // Quan hệ giữa FriendRequest và User
  FriendRequest.belongsTo(User, { foreignKey: 'userId', as: 'user', onDelete: 'CASCADE' });

  // Quan hệ giữa Friend và User
  Friend.belongsTo(User, { foreignKey: 'targetId', onDelete: 'CASCADE', as: 'target' });
  Friend.belongsTo(User, { foreignKey: 'userId', onDelete: 'CASCADE', as: 'user' });

  // Quan hệ giữa User và PostView
  User.hasMany(PostView, { foreignKey: 'userId', onDelete: 'CASCADE', as: 'user' });
  // User.belongsTo(Group, { foreignKey: 'groupId', onDelete: 'CASCADE', as: 'group' });
  // Group.hasMany(User, { foreignKey: 'userId', onDelete: 'CASCADE', as: 'user' });
  Comment.belongsTo(User, { foreignKey: 'userId', onDelete: 'CASCADE', as: 'user' });

  Feel.belongsTo(User, { foreignKey: 'userId', onDelete: 'CASCADE', as: 'user' });
  User.sync({ alter: true }).then(() => logger.info("Table 'User' synced!"));
})();
