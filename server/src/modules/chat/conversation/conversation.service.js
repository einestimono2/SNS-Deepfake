import { Op } from 'sequelize';

import { BadRequestError, NotFoundError, UnauthorizedError } from '../../core/error.response.js';
import { socket } from '../../socket/socket.js';
import { User } from '../../user/user.model.js';
import { Message as MessageModel } from '../message/message.model.js';
import { MessageService } from '../message/message.service.js';
import { ConversationParticipants } from '../participant.model.js';

import { Conversation } from './conversation.model.js';

import { ConversationType, Message, MessageType, SocketEvents } from '#constants';
import { setFileUsed } from '#utils';

export class ConversationService {
  static createConversation = async ({ userId, memberIds, name, message }) => {
    if (!userId) throw new UnauthorizedError(Message.USER_NOT_FOUND);
    if (!memberIds) throw new BadRequestError(Message.CONVERSATION_MEMBERS_INVALID);

    /* ========== TH1: Group chat ========== */
    if (Array.isArray(memberIds) && memberIds.length > 1) {
      const _members = [userId, ...memberIds];

      const newConversation = await Conversation.create({
        name,
        creatorId: userId,
        type: ConversationType.Group,
        memberIds: _members
      });

      await newConversation.setMembers(_members);

      const users = [];
      for (let i = 0; i < _members.length; i++) {
        const _user = await User.findByPk(_members[i]);
        users.push(_user);
      }

      const msg = await MessageModel.create({
        message: 'CREATED',
        conversationId: newConversation.id,
        type: MessageType.System,
        senderId: userId, // Từ token
        seenIds: [userId] // từ token
      });

      socket.triggerEvent(_members, SocketEvents.CONVERSATION_NEW, {
        conversation: newConversation,
        members: users,
        message: msg
      });

      return {
        conversation: newConversation,
        members: users,
        message: msg
      };
    }

    /* ========== TH2: Chat riêng 1-1 ========== */
    // -> Đã có
    const _members = [userId, memberIds[0] ?? memberIds];

    const existingConversation = await Conversation.findOne({
      where: {
        type: ConversationType.Single,
        memberIds: { [Op.contains]: _members }
      }
    });

    if (existingConversation) {
      return existingConversation;
    }

    // -> Lần đầu chat -> tạo mới
    const newConversation = await Conversation.create({
      creatorId: userId,
      type: ConversationType.Single,
      memberIds: _members
    });

    await newConversation.setMembers(_members);

    const users = [];
    for (let i = 0; i < _members.length; i++) {
      const _user = await User.findByPk(_members[i]);
      users.push(_user);
    }

    const attachments = [];
    for (const url of message.attachments) {
      attachments.push(setFileUsed(url));
    }

    const msg = await MessageModel.create({
      message: message.message,
      replyId: message.replyId,
      conversationId: newConversation.id,
      type: message.type,
      attachments,
      senderId: userId, // Từ token
      seenIds: [userId] // từ token
    });

    let sendMessage = msg.dataValues;

    if (message.replyId) {
      const reply = await MessageModel.findByPk(message.replyId);
      sendMessage = {
        ...sendMessage,
        reply: reply.dataValues
      };
    }

    socket.triggerEvent(_members, SocketEvents.CONVERSATION_NEW, {
      conversation: newConversation,
      members: users,
      message: sendMessage
    });

    return {
      conversation: newConversation,
      members: users,
      message: sendMessage
    };
  };

  static getSingleConversationByMembers = async ({ userId, targetId }) => {
    const res = await Conversation.findOne({
      where: {
        type: ConversationType.Single,
        memberIds: { [Op.contains]: [targetId, userId] }
      }
    });

    return {
      id: res?.id ?? -1
    };
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
      distinct: true,
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

  static updateConversationInfo = async ({ id, name, userId }) => {
    if (!id) throw new BadRequestError(Message.ID_EMPTY);

    const conversation = await Conversation.findByPk(id, {
      include: {
        association: 'members',
        attributes: ['id', 'email'],
        through: { attributes: [] }
      }
    });
    if (!conversation) throw new NotFoundError(Message.CONVERSATION_NOT_FOUND);

    const msg = await MessageModel.create({
      message: 'RENAME_CONVERSATION',
      conversationId: conversation.id,
      type: MessageType.System,
      senderId: userId, // Từ token
      seenIds: [userId] // từ token
    });

    socket.triggerEvent(conversation.id, SocketEvents.MESSAGE_NEW, msg);

    conversation.name = name;
    conversation.lastMessageAt = msg.createdAt;

    await conversation.save();

    socket.triggerEvent(
      conversation.members.map((member) => member.id),
      SocketEvents.CONVERSATION_UPDATE,
      {
        conversationId: conversation.id,
        lastMessageAt: conversation.lastMessageAt,
        name: conversation.name,
        message: msg
      }
    );

    return conversation;
  };
}
