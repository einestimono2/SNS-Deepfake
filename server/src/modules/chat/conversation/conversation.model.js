import { DataTypes } from 'sequelize';

import { User } from '../../user/user.model.js';
import { Message } from '../message/message.model.js';

import { ConversationType } from '#constants';
import { postgre } from '#dbs';
import { logger } from '#utils';

export const Conversation = postgre.define(
  'Conversation',
  {
    id: {
      allowNull: false,
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    name: {
      type: DataTypes.STRING,
      default: null
    },
    type: {
      type: DataTypes.ENUM,
      values: Object.values(ConversationType),
      defaultValue: ConversationType.Single
    },
    // ref - user
    creatorId: {
      allowNull: false,
      type: DataTypes.INTEGER
    },
    lastMessageAt: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW
    },
    memberIds: {
      type: DataTypes.ARRAY(DataTypes.INTEGER),
      defaultValue: []
    }
  },
  {
    deletedAt: 'deletedAt'
  }
);

(() => {
  // User ---sở hữu---*> Conversation
  User.hasMany(Conversation, { foreignKey: 'creatorId', as: 'own_conversations' });
  Conversation.belongsTo(User, { foreignKey: 'creatorId', as: 'conversation_owner' });

  // Conversation ---có---*> Message
  Conversation.hasMany(Message, { foreignKey: 'conversationId', as: 'messages' });
  Message.belongsTo(Conversation, { foreignKey: 'conversationId', as: 'conversation_messages' });

  // Sync
  Conversation.sync({ alter: true }).then(() => logger.info("Table 'Conversation' synced!"));
})();
