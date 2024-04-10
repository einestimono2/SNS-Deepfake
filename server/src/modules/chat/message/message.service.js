import { Sequelize } from 'sequelize';

import { BadRequestError, UnauthorizedError } from '../../core/error.response.js';
import { socket } from '../../socket/socket.js';
import { ConversationService } from '../conversation/conversation.service.js';

import { Message } from './message.model.js';

import { Message as MessageConst, SocketEvents } from '#constants';

export class MessageService {
  static createMessage = async (body) => {
    if (!body.senderId) throw new UnauthorizedError(MessageConst.USER_NOT_FOUND);
    if (!body.conversationId) throw new BadRequestError(MessageConst.CONVERSATION_NOT_FOUND);

    const newMessage = await Message.create({
      message: body.message,
      replyId: body.replyId,
      conversationId: body.conversationId,
      type: body.type,
      attachments: body.attachments,
      senderId: body.senderId, // Từ token
      seenIds: [body.senderId] // từ token
    });

    // Trigger Event: tới room đó (thành viên không trong room thì k cần thiết phải nhận)
    socket.triggerEvent(body.conversationId, SocketEvents.MESSAGE_NEW, newMessage);

    // Cập nhật lastMessageTimestamp
    const conversation = await ConversationService.updateLastMessageTimestamp({
      conversationId: body.conversationId
    });

    /**
     * Trigger Event
     * Trường hợp thành viên không trong cuộc trò chuyện mà ở ngoài danh sách cuộc trò chuyện
     * --> Cần cập nhật tin nhắn mới nhất của cuộc trò chuyện
     * --> Gửi tới từng thành viên ( != tới room )
     */
    socket.triggerEvent(
      conversation.members.map((member) => member.id),
      SocketEvents.CONVERSATION_LASTEST,
      {
        id: body.conversationId,
        messages: [newMessage]
      }
    );

    return newMessage;
  };

  static updateMessage = async ({ id, ...body }) => {
    if (!id) throw new BadRequestError(MessageConst.ID_EMPTY);

    const newMessage = await Message.update(
      {
        ...body
      },
      {
        where: { id }
      }
    );

    return newMessage;
  };

  static getConversationMessages = async ({ conversationId, limit, offset }) => {
    if (!conversationId) throw new BadRequestError(MessageConst.ID_EMPTY);

    const result = await Message.findAndCountAll({
      where: { conversationId },
      order: [[Sequelize.col('createdAt'), 'ASC']],
      // include: [
      //   {
      //     association: 'sender',
      //     attributes: ['id', 'avatar', 'username', 'email', 'phoneNumber']
      //   }
      // ],
      limit,
      offset
    });

    return result;
  };
}
