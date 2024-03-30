import { PostServices } from './post.service.js';

import { CatchAsyncError } from '#middlewares';
// 1--Đăng ký
export class PostControllers {
  static addPost = CatchAsyncError(async (req, res) => {
    const post = await PostServices.addPost(req);

    res.created({
      data: post
    });
  });

  // static getPost = CatchAsyncError(async (req, res) => {});

  // static getListPosts = CatchAsyncError(async (req, res) => {});

  // static editPost = CatchAsyncError(async (req, res) => {});

  // static getListVideo = CatchAsyncError(async (req, res) => {});

  // static deletePost = CatchAsyncError(async (req, res) => {});

  // static reportPost = CatchAsyncError(async (req, res) => {});
}
