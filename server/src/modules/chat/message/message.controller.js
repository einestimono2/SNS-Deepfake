import { MessageService } from './message.service.js';

import { CatchAsyncError } from '#middlewares';
import { getPaginationAttributes, getPaginationSummary } from '#utils';

export class MessageController {
  static createMessage = CatchAsyncError(async (req, res) => {
    const message = await MessageService.createMessage({
      ...req.body,
      senderId: req.userPayload.userId
    });

    res.created({
      data: message
    });
  });

  static updateMessage = CatchAsyncError(async (req, res) => {
    const newMessage = await MessageService.updateMessage({
      ...req.body,
      id: req.params.id
    });

    res.created({
      data: newMessage
    });
  });

  static getConversationMessages = CatchAsyncError(async (req, res) => {
    const result = await MessageService.getConversationMessages({
      conversationId: req.params.conversationId,
      ...getPaginationAttributes(req.query)
    });

    res.ok(
      getPaginationSummary({
        ...req.query,
        result
      })
    );
  });
}
