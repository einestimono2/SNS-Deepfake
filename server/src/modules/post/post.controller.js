import { PostServices } from './post.service.js';

import { CatchAsyncError } from '#middlewares';
import { getPaginationAttributes, getPaginationSummary } from '#utils';

// 1--Đăng ký
export class PostControllers {
  static addPost = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const data = await PostServices.addPost(userId, req.body);
    res.created({
      message: 'Thêm mới thành công',
      data
    });
  });

  static detailsPost = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { postId } = req.params;
    const post = await PostServices.detailsPost(userId, postId);
    res.ok({
      data: post
    });
  });

  static getListPosts = CatchAsyncError(async (req, res) => {
    const { groupId } = req.params;
    const result = await PostServices.getListPosts(
      {
        userId: req.userPayload.userId,
        ...getPaginationAttributes(req.query)
      },
      groupId
    );

    res.ok(
      getPaginationSummary({
        ...req.query,
        result
      })
    );
  });

  static editPost = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { postId } = req.params;
    const post = await PostServices.editPost(userId, postId, req.body);
    res.ok({
      data: post
    });
  });

  // static getListVideo = CatchAsyncError(async (req, res) => {});

  static deletePost = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { postId } = req.params;
    const coins = await PostServices.deletePost(userId, postId);

    res.ok({
      data: coins
    });
  });

  static reportPost = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { postId } = req.params;
    const report = await PostServices.reportPost(userId, postId, req.body);
    res.ok({
      data: report
    });
  });

  static getNewPosts = CatchAsyncError(async (req, res) => {
    const result = await PostServices.getNewPosts({
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

  static setViewedPost = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { postId } = req.params;
    const viewed = await PostServices.setViewedPost(userId, postId);
    res.ok({
      data: viewed
    });
  });

  static getListVideos = CatchAsyncError(async (req, res) => {
    const { groupId } = req.params;
    const result = await PostServices.getListVideos(
      {
        userId: req.userPayload.userId,
        ...getPaginationAttributes(req.query)
      },
      groupId
    );
    console.log(result);
    res.ok(
      getPaginationSummary({
        ...req.query,
        result
      })
    );
  });
}
