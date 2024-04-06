import { SettingServices } from './setting.service.js';

import { CatchAsyncError } from '#middlewares';

export class SettingControllers {
  static setDevToken = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    await SettingServices.setDevToken(userId, req.body);
    res.created({
      message: 'Đã đặt Device token thành công!'
    });
  });

  static buyCoins = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const coins = await SettingServices.buyCoins(userId, req.body);
    res.ok({
      data: coins
    });
  });

  static setPushSettings = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    await SettingServices.setPushSettings(userId, req.body);
    res.created({
      message: 'Setting thành công!'
    });
  });

  static getUserPushSettings = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const data = await SettingServices.getUserPushSettings(userId);
    res.ok({
      data
    });
  });

  static getPushSettings = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const data = await SettingServices.getPushSettings(userId);
    res.ok({
      data
    });
  });
}
