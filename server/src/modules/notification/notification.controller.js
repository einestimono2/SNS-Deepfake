import { CommentServices } from './comment.service.js';

import { CatchAsyncError } from '#middlewares';
// 1--Đăng ký
export class CommentControllers {
  static getMarkComment = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { postId } = req.params;
    const data = await CommentServices.getMarkComment(userId, postId, req.body);
    res.created({
      data
    });
  });
}
