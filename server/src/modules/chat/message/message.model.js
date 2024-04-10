import { DataTypes } from 'sequelize';

import { User } from '../../user/user.model.js';

import { MessageType } from '#constants';
import { postgre } from '#dbs';
import { logger } from '#utils';

export const Message = postgre.define(
  'Message',
  {
    id: {
      allowNull: false,
      type: DataTypes.BIGINT,
      primaryKey: true,
      autoIncrement: true
    },
    message: {
      type: DataTypes.STRING
    },
    // File | Video | ...
    attachments: {
      type: DataTypes.ARRAY(DataTypes.STRING),
      defaultValue: []
    },
    type: {
      type: DataTypes.ENUM,
      values: Object.values(MessageType),
      defaultValue: MessageType.Text
    },
    // ref - message
    replyId: {
      type: DataTypes.INTEGER
    },
    // ref - user
    seenIds: {
      type: DataTypes.ARRAY(DataTypes.INTEGER),
      defaultValue: []
    },
    // ref - user
    senderId: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    // ref - conversation
    conversationId: {
      type: DataTypes.INTEGER
    }
  },
  { deletedAt: 'deletedAt' }
);

(() => {
  // - Associations
  User.hasMany(Message, {
    foreignKey: 'senderId',
    as: 'owner',
    onDelete: 'SET NULL' // Khi user bị xóa thì 'senderId' thành null (không xóa)
  });
  Message.belongsTo(User, { foreignKey: 'senderId', as: 'sender' });

  Message.hasOne(Message, { foreignKey: 'replyId' });
  Message.belongsTo(Message, { foreignKey: 'replyId', as: 'reply' });

  Message.sync({ alter: true }).then(() => logger.info("Table 'Message' synced!"));
})();
