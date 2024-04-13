import { PostServices } from './post.service.js';

import { CatchAsyncError } from '#middlewares';

// 1--Đăng ký
export class PostControllers {
  static addPost = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const post = await PostServices.addPost(userId, req.body);
    res.created({
      data: post
    });
  });

  static getPost = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { postId } = req.params;
    console.log(userId);
    const post = await PostServices.getPost(userId, postId);

    res.ok({
      data: post
    });
  });

  static getListPosts = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    console.log('hi');
    const posts = await PostServices.getListPosts(userId, req.body);
    res.ok({
      data: posts
    });
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
    const { userId } = req.userPayload;
    const newPosts = await PostServices.getNewPosts(userId, req.body);
    res.ok({
      data: newPosts
    });
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
    const { userId } = req.userPayload;
    const data = await PostServices.getListVideos(userId, req.body);
    res.ok({
      data
    });
  });
}
