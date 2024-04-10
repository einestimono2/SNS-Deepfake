import { DataTypes } from 'sequelize';

import { User } from '../user/user.model.js';

import { Conversation } from './conversation/conversation.model.js';

import { postgre } from '#dbs';
import { logger } from '#utils';

export const ConversationParticipants = postgre.define(
  'ConversationParticipants',
  {
    id: {
      allowNull: false,
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    conversationId: {
      type: DataTypes.INTEGER,
      references: {
        model: Conversation, // 'Conversations' would also work
        key: 'id'
      }
    },
    userId: {
      type: DataTypes.INTEGER,
      references: {
        model: User, // 'Users' would also work
        key: 'id'
      }
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
  User.belongsToMany(Conversation, {
    through: ConversationParticipants,
    foreignKey: 'userId',
    as: 'my_conversations'
  });
  Conversation.belongsToMany(User, {
    through: ConversationParticipants,
    foreignKey: 'conversationId',
    as: 'members'
  });

  Conversation.hasMany(ConversationParticipants, { foreignKey: 'conversationId' });
  ConversationParticipants.belongsTo(Conversation, { foreignKey: 'conversationId' });

  User.hasMany(ConversationParticipants, { foreignKey: 'userId' });
  ConversationParticipants.belongsTo(User, { foreignKey: 'userId' });

  ConversationParticipants.sync({ alter: true }).then(() => logger.info("Table 'ConversationParticipants' synced!"));
})();
