import { Op, Sequelize, where } from 'sequelize';

import { BadRequestError, NotFoundError, UnauthorizedError } from '../../core/error.response.js';
import { socket } from '../../socket/socket.js';
import { MessageService } from '../message/message.service.js';
import { ConversationParticipants } from '../participant.model.js';

import { Conversation } from './conversation.model.js';

import { ConversationType, Message, SocketEvents } from '#constants';

export class ConversationService {
  static findConversationByMemberIds = (...members) => {
    return new Promise((resolve, reject) => {
      ConversationParticipants.findOne({
        attributes: ['Conversation.id'],
        group: ['Conversation.id'],
        having: [where(Sequelize.fn('array_agg', Sequelize.col('userId')), Op.contained, members)],
        include: [
          {
            // association: 'users',
            model: Conversation
          }
        ]
      })
        .then((conversation) => resolve(conversation))
        .catch((error) => reject(error));
    });
  };

  static createConversation = async ({ userId, memberIds, name }) => {
    if (!userId) throw new UnauthorizedError(Message.USER_NOT_FOUND);
    if (!memberIds) throw new BadRequestError(Message.CONVERSATION_MEMBERS_INVALID);

    /* ========== TH1: Group chat ========== */
    if (Array.isArray(memberIds) && memberIds.length > 1) {
      const _members = [userId, ...memberIds];

      const newConversation = await Conversation.create({
        name,
        creatorId: userId,
        type: ConversationType.Group
      }).then((conversation) => conversation.setUsers(_members));

      socket.triggerEvent(_members, SocketEvents.CONVERSATION_NEW, newConversation);

      return newConversation;
    }

    /* ========== TH2: Chat riêng 1-1 ========== */
    // -> Đã có
    const _members = [userId, memberIds[0] ?? memberIds];

    const existingConversation = await ConversationService.findConversationByMemberIds(_members);

    if (existingConversation) {
      return existingConversation.Conversation;
    }

    // -> Lần đầu chat -> tạo mới
    const newConversation = await Conversation.create({
      creatorId: userId,
      type: ConversationType.Single
    }).then((conversation) => conversation.setUsers(_members));

    socket.triggerEvent(_members, SocketEvents.CONVERSATION_NEW, newConversation);

    return newConversation;
  };

  static getMyConversations = async ({ userId, limit, offset }) => {
    if (!userId) {
      throw new UnauthorizedError(Message.USER_NOT_FOUND);
    }

    const result = await Conversation.findAndCountAll({
      order: [
        // order: [[Conversation, 'lastMessageAt', 'DESC']], // Nếu muốn order theo bảng được nối
        ['lastMessageAt', 'DESC'],
        ['updatedAt', 'DESC']
      ],
      limit,
      offset,
      include: [
        {
          model: ConversationParticipants,
          attributes: [],
          where: {
            userId
          }
        },
        {
          association: 'members',
          attributes: ['id', 'avatar', 'username', 'email', 'phoneNumber', 'lastActive'],
          through: { attributes: [] }
        },
        {
          association: 'messages',
          attributes: ['id', 'senderId', 'seenIds', 'createdAt', 'message', 'type', 'replyId'],
          order: [['createdAt', 'DESC']],
          limit: 10
        }
      ]
    });

    return result;
  };

  static getConversationDetails = async ({ id }) => {
    if (!id) throw new BadRequestError(Message.ID_EMPTY);

    const conversation = await Conversation.findByPk(id, {
      include: [
        {
          association: 'members',
          attributes: ['id', 'avatar', 'username', 'email', 'phoneNumber'],
          through: { attributes: [] }
        }
      ]
    });

    if (!conversation) throw new NotFoundError(Message.CONVERSATION_NOT_FOUND);

    return conversation;
  };

  static seenConversation = async ({ id, userId }) => {
    if (!id) throw new BadRequestError(Message.ID_EMPTY);

    const newMessage = await MessageService.seenLastestMessage({
      conversationId: id,
      targetId: userId
    });

    return newMessage;
  };

  static updateLastMessageTimestamp = async ({ conversationId, messageTime }) => {
    if (!conversationId) throw new BadRequestError(Message.ID_EMPTY);

    const conversation = await Conversation.findByPk(conversationId, {
      include: {
        association: 'members',
        attributes: ['id', 'email'],
        through: { attributes: [] }
      }
    });

    conversation.lastMessageAt = messageTime ?? Date.now();

    await conversation.save();

    return conversation;
  };

  static deleteConversation = async ({ id }) => {
    if (!id) throw BadRequestError(Message.ID_EMPTY);

    // TODO: Delete conversation

    // Trigger Event -> Xóa conversation
  };
}
