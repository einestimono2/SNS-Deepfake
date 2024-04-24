import { CommentServices } from './comment.service.js';

import { CatchAsyncError } from '#middlewares';
import { getPaginationAttributes, getPaginationSummary } from '#utils';

export class CommentControllers {
  static getMarkComment = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { postId } = req.params;
    const data = await CommentServices.getMarkComment(userId, postId, ...getPaginationAttributes(req.query));
    res.ok(
      getPaginationSummary({
        ...req.query,
        data
      })
    );
  });

  static setMarkComment = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { postId } = req.params;
    const data = await CommentServices.setMarkComment(userId, postId, req.body);
    res.created({
      data
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
    const { userId } = req.userPayload;
    const { postId } = req.params;
    const data = await CommentServices.getListFeels(userId, postId, ...getPaginationAttributes(req.query));
    res.ok(
      getPaginationSummary({
        ...req.query,
        data
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
