import { DevToken } from '../user/models/device_token.model.js';
import { User } from '../user/user.model.js';

import { Setting } from './setting.model.js';

export class SettingServices {
  static async setDevToken(userId, body) {
    const existingDevToken = await DevToken.findOne({ where: { userId } });
    // Nếu có thì thay mới
    if (existingDevToken) {
      existingDevToken.type = body.devtype;
      existingDevToken.token = body.devtoken;
      await existingDevToken.save();
    } else {
      const newDevToken = await DevToken.create({
        userId,
        type: body.devtype,
        token: body.devtoken
      });
      await newDevToken.save();
    }
    return {};
  }

  // Mua coins
  static async buyCoins(userId, body) {
    const user = await User.findOne({ where: { id: userId } });
    const { coins } = { ...body };
    const totalCoins = Number(coins) + Number(user.coins);
    user.coins = totalCoins.toString();
    await user.save();
    return { coins: user.coins };
  }

  static async setPushSettings(userId, body) {
    let pushSettings = await Setting.findOne({ userId });
    // Nếu không có thì tạo mới
    if (!pushSettings) {
      pushSettings = await Setting.create({ where: { userId } });
    }
    pushSettings.likeComment = body.like_comment;
    pushSettings.fromFriends = body.from_friends;
    pushSettings.friendRequests = body.requested_friend;
    pushSettings.suggestedFriends = body.suggested_friend;
    pushSettings.birthdays = body.birthday;
    pushSettings.videos = body.video;
    pushSettings.reports = body.report;
    pushSettings.soundOn = body.sound_on;
    pushSettings.notificationOn = body.notification_on;
    pushSettings.vibrationOn = body.vibrant_on;
    pushSettings.ledOn = body.led_on;
    await pushSettings.save();
    return {};
  }

  //
  static async getUserPushSettings(user) {
    let pushSettings = await Setting.findOne({ where: { userId: user.id } });
    if (!pushSettings) {
      pushSettings = await Setting.create({ userId: user.id });
      await pushSettings.save();
    }
    return pushSettings;
  }

  static async getPushSettings(userId) {
    let pushSettings = await Setting.findOne({ where: { userId } });
    if (!pushSettings) {
      pushSettings = await Setting.create({ userId });
      await pushSettings.save();
    }
    return {
      like_comment: pushSettings.likeComment ? '1' : '0',
      from_friends: pushSettings.fromFriends ? '1' : '0',
      requested_friend: pushSettings.friendRequests ? '1' : '0',
      suggested_friend: pushSettings.suggestedFriends ? '1' : '0',
      birthday: pushSettings.birthdays ? '1' : '0',
      video: pushSettings.videos ? '1' : '0',
      report: pushSettings.reports ? '1' : '0',
      sound_on: pushSettings.soundOn ? '1' : '0',
      notification_on: pushSettings.notificationOn ? '1' : '0',
      vibrant_on: pushSettings.vibrationOn ? '1' : '0',
      led_on: pushSettings.ledOn ? '1' : '0'
    };
  }
}
