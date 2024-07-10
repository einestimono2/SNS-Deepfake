import { Op } from 'sequelize';

import { BadRequestError, ForbiddenError, NotFoundError, UnauthorizedError } from '../../core/error.response.js';
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
        message: {
          ...msg.dataValues,
          sender: users[0] // userId là mình tương ứng vị trí đầu tiên khi add list
        }
      });

      return {
        conversation: newConversation,
        members: users,
        message: {
          ...msg.dataValues,
          sender: users[0] // userId là mình tương ứng vị trí đầu tiên khi add list
        }
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

    let sendMessage = {
      ...msg.dataValues,
      sender: users[0] // userId là mình tương ứng vị trí đầu tiên khi add list
    };

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
          order: [['id', 'DESC']],
          limit: 1,
          include: [
            {
              association: 'sender',
              attributes: ['id', 'avatar', 'username', 'email', 'phoneNumber']
            }
          ]
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

  static deleteConversation = async ({ id, userId }) => {
    if (!id) throw BadRequestError(Message.ID_EMPTY);

    const conversation = await Conversation.findByPk(id, {
      include: {
        association: 'members',
        attributes: ['id', 'email'],
        through: { attributes: [] }
      }
    });
    if (!conversation) throw new NotFoundError(Message.CONVERSATION_NOT_FOUND);

    if (conversation.creatorId !== userId) throw new ForbiddenError(Message.USER_NOT_CONVERSATION_CREATOR);
    await conversation.destroy(); // Tự xóa các message vs thành viên do ràng buộc

    // Trigger Event -> Xóa conversation
    socket.triggerEvent(
      conversation.members.map((member) => member.id),
      SocketEvents.CONVERSATION_REMOVE,
      {
        conversationId: id
      }
    );
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

    const sender = await User.findByPk(userId);

    socket.triggerEvent(
      conversation.members.map((member) => member.id),
      SocketEvents.MESSAGE_NEW,
      {
        ...msg.dataValues,
        sender: sender.dataValues
      }
    );

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
        message: {
          ...msg.dataValues,
          sender: sender.dataValues
        }
      }
    );

    return conversation;
  };

  static addMembers = async ({ id, memberIds, userId }) => {
    if (!id) throw new BadRequestError(Message.ID_EMPTY);

    const existingMember = await ConversationParticipants.findOne({
      where: {
        conversationId: id,
        userId: memberIds
      }
    });
    if (existingMember) throw new NotFoundError(Message.MEMBER_EXISTS);

    // Them moi
    for (const _id of memberIds) {
      await ConversationParticipants.create({
        conversationId: id,
        userId: _id
      });
    }

    const conversation = await Conversation.findByPk(id, {
      include: {
        association: 'members',
        attributes: ['id', 'avatar', 'username', 'email', 'phoneNumber'],
        through: { attributes: [] }
      }
    });
    if (!conversation) throw new NotFoundError(Message.CONVERSATION_NOT_FOUND);

    // Tạo message system tương ứng với từng người đc thêm
    const addMessages = [];
    for (const _id of memberIds) {
      const msg = await MessageModel.create({
        message: 'ADD_MEMBER',
        conversationId: id,
        type: MessageType.System,
        senderId: _id, // Để sender để có thể lấy thông tin sau khi kick
        seenIds: [userId] // từ token
      });

      addMessages.push({
        ...msg.dataValues,
        sender: conversation.members.find((e) => e.id === _id)
      });
    }

    // Gửi tới những người trong phòng thông tin từng người đc thêm
    socket.triggerEvent(
      conversation.members.map((member) => member.id),
      SocketEvents.MESSAGE_NEWS,
      addMessages
    );

    // Cập nhật conversation table
    conversation.lastMessageAt = addMessages[addMessages.length - 1].createdAt;
    conversation.memberIds = conversation.members.map((member) => member.id);
    await conversation.save();

    socket.triggerEvent(
      conversation.members.map((member) => member.id),
      SocketEvents.CONVERSATION_ADD_MEMBER,
      {
        conversationId: conversation.id,
        conversation,
        memberIds,
        lastMessageAt: conversation.lastMessageAt,
        message: addMessages[addMessages.length - 1]
      }
    );

    return conversation.members.filter((member) => memberIds.includes(member.id));
  };

  static deleteMembers = async ({ id, memberId, userId, kick }) => {
    if (!id) throw new BadRequestError(Message.ID_EMPTY);

    const existingMember = await ConversationParticipants.findOne({
      where: {
        conversationId: id,
        userId: memberId
      }
    });
    if (!existingMember) throw new NotFoundError(Message.USER_NOT_FOUND);

    // Xóa member đó
    await existingMember.destroy();

    // !
    const conversation = await Conversation.findByPk(id, {
      include: {
        association: 'members',
        attributes: ['id', 'email'],
        through: { attributes: [] }
      }
    });
    if (!conversation) throw new NotFoundError(Message.CONVERSATION_NOT_FOUND);

    // Trigger event tới những người đang mở conversation
    const msg = await MessageModel.create({
      message: kick ? 'KICK_MEMBER' : 'LEAVE_MEMBER',
      conversationId: id,
      type: MessageType.System,
      senderId: memberId, // Để sender để có thể lấy thông tin sau khi kick
      seenIds: [userId] // từ token
    });
    const sender = await User.findByPk(memberId);
    socket.triggerEvent(
      kick
        ? [...conversation.members.map((member) => member.id), memberId]
        : conversation.members.map((member) => member.id),
      SocketEvents.MESSAGE_NEW,
      { ...msg.dataValues, sender: sender.dataValues }
    );

    conversation.lastMessageAt = msg.createdAt;
    conversation.memberIds = conversation.members.map((member) => member.id);
    await conversation.save();

    // Xóa conversation đó ở từng member
    socket.triggerEvent(
      [...conversation.members.map((member) => member.id), memberId],
      SocketEvents.CONVERSATION_LEAVE,
      {
        conversationId: conversation.id,
        memberId,
        lastMessageAt: conversation.lastMessageAt,
        message: { ...msg.dataValues, sender: sender.dataValues }
      }
    );
  };
}
