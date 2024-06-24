import { CommentServices } from './comment.service.js';

import { CatchAsyncError } from '#middlewares';
import { getPaginationAttributes, getPaginationSummary } from '#utils';

export class CommentControllers {
  static getMarkComment = CatchAsyncError(async (req, res) => {
    const { postId } = req.params;
    const result = await CommentServices.getMarkComment(
      {
        userId: req.userPayload.userId,
        ...getPaginationAttributes(req.query)
      },
      postId
    );
    res.ok(
      getPaginationSummary({
        ...req.query,
        result
      })
    );
  });

  static setMarkComment = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { postId } = req.params;
    const data = await CommentServices.setMarkComment(userId, postId, {
      ...req.body,
      ...getPaginationAttributes(req.query)
    });

    const paginationData = getPaginationSummary({
      ...req.query,
      result: data.data
    });

    res.created({
      data: {
        data: paginationData.data,
        coins: data.coins
      },
      extra: paginationData.extra
    });
  });

  static feel = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { postId } = req.params;
    const { type } = req.body;
    const data = await CommentServices.feel(userId, postId, type);
    res.created({
      data
    });
  });

  static getListFeels = CatchAsyncError(async (req, res) => {
    const { postId } = req.params;
    const result = await CommentServices.getListFeels(
      {
        userId: req.userPayload.userId,
        ...getPaginationAttributes(req.query)
      },
      postId
    );
    res.ok(
      getPaginationSummary({
        ...req.query,
        result
      })
    );
  });

  static deleteFeel = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { postId } = req.params;
    const data = await CommentServices.deleteFeel(userId, postId);
    res.ok({
      data
    });
  });
}
