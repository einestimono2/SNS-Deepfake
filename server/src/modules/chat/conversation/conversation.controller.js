import { ConversationService } from './conversation.service.js';

import { CatchAsyncError } from '#middlewares';
import { getPaginationAttributes, getPaginationSummary } from '#utils';

export class ConversationController {
  static createConversation = CatchAsyncError(async (req, res) => {
    const conversation = await ConversationService.createConversation({
      ...req.body,
      userId: req.userPayload.userId
    });

    res.created({
      data: conversation
    });
  });

  static getSingleConversationByMembers = CatchAsyncError(async (req, res) => {
    const id = await ConversationService.getSingleConversationByMembers({
      ...req.body,
      userId: req.userPayload.userId
    });

    res.ok({
      data: id
    });
  });

  static getMyConversations = CatchAsyncError(async (req, res) => {
    const result = await ConversationService.getMyConversations({
      userId: req.userPayload.userId,
      ...getPaginationAttributes(req.query)
    });

    res.ok(
      getPaginationSummary({
        ...req.query,
        result
      })
    );
  });

  static getConversationDetails = CatchAsyncError(async (req, res) => {
    const conversation = await ConversationService.getConversationDetails({
      id: req.params.id
    });

    res.ok({
      data: conversation
    });
  });

  static seenConversation = CatchAsyncError(async (req, res) => {
    await ConversationService.seenConversation({
      id: req.params.id,
      userId: req.userPayload.userId
    });

    res.ok();
  });

  static deleteConversation = CatchAsyncError(async (req, res) => {
    await ConversationService.deleteConversation({
      id: req.params.id
    });

    res.ok();
  });

  static updateConversationInfo = CatchAsyncError(async (req, res) => {
    const conversation = await ConversationService.updateConversationInfo({
      ...req.body,
      userId: req.userPayload.userId,
      id: req.params.id
    });

    res.ok({
      data: conversation
    });
  });
}
