import { NotificationServices } from './notification.service.js';

import { CatchAsyncError } from '#middlewares';
import { getPaginationAttributes, getPaginationSummary } from '#utils';

export class NotificationControllers {
  static createNotification = CatchAsyncError(async (req, res) => {
    await NotificationServices.createNotification(req.body);
    // res.created({
    //   data
    // });
  });

  static getListNotifications = CatchAsyncError(async (req, res) => {
    const result = await NotificationServices.getListNotifications({
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

  static checkNewItems = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { lastId, categoryId } = { ...req.body };
    const data = await NotificationServices.checkNewItems(userId, lastId, categoryId);
    res.ok({
      data
    });
  });

  static notifyAddPost = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { postId } = req.query;
    await NotificationServices.notifyAddPost(postId, userId);
    res.ok({
      message: 'Notify Add Post Successfully'
    });
  });

  static notifyEditPost = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { postId } = req.query;
    console.log(postId);
    await NotificationServices.notifyEditPost(postId, userId);
    res.ok({
      message: 'Notify Edit Post Successfully'
    });
  });

  static notifyCreateVideo = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { videoId } = req.query;
    await NotificationServices.notifyCreateVideo(userId, videoId);
    res.ok({
      message: 'Notify Create Video Successfully'
    });
  });

  static notifyPlayVideo = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { targetId, videoId } = req.query;
    await NotificationServices.notifyPlayVideo(userId, targetId, videoId);
    res.ok({
      message: 'Notify Play Video Successfully'
    });
  });

  static sendMessage = CatchAsyncError(async (req, res) => {
    await NotificationServices.sendMessage(req.body);

    res.ok();
  });
}
