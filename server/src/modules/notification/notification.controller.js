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

  static sendMessage = CatchAsyncError(async (req, res) => {
    await NotificationServices.sendMessage(req.body);

    res.ok();
  });
}
