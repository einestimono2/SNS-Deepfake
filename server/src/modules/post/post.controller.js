import { User } from '../user/user.model.js';

import { PostServices } from './post.service.js';

import { CatchAsyncError } from '#middlewares';
// 1--Đăng ký
export class PostControllers {
  static addPost = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    console.log(req.userPayload);
    const user = await User.findOne({
      where: { id: userId }
    });
    const post = await PostServices.addPost(user, req.body);

    res.created({
      data: post
    });
  });

  static getPost = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { postId } = req.params;
    const user = await User.findOne({
      where: { id: userId }
    });
    const post = await PostServices.getPost(user, postId);

    res.created({
      data: post
    });
  });

  static getListPosts = CatchAsyncError(async (req, res) => {});

  static editPost = CatchAsyncError(async (req, res) => {});

  static getListVideo = CatchAsyncError(async (req, res) => {});

  static deletePost = CatchAsyncError(async (req, res) => {});

  static reportPost = CatchAsyncError(async (req, res) => {});
}
