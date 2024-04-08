import pkg from 'firebase-admin';
import { Op } from 'sequelize';

import { Block } from '../block/block.model.js';
import { FriendRequest } from '../friend/components/friend_request.model.js';
import { Friend } from '../friend/friend.model.js';
import { Feel } from '../post/models/feel.model.js';
import { Mark } from '../post/models/mark.model.js';
import { PostVideo } from '../post/models/post_video.model.js';
import { Post } from '../post/post.model.js';
import { SettingServices } from '../setting/setting.service.js';
import { User } from '../user/user.model.js';

import { Notification } from './notification.model.js';

import { DevToken } from '##/modules/user/models/device_token.model';
import { CategoryType, NotificationType } from '#constants';

const { messaging } = pkg;

export class NotificationServices {
  // Lặp qua 1 notification để trả về thông tin chi tiết của 1 thông báo
  static async mapNotification(notification) {
    const { id, type, read, target, post, mark, feel, createdAt } = notification;
    return {
      type: String(type),
      object_id: String(post?.id || target?.id || 0),
      title: 'Notification',
      notification_id: String(id),
      created: createdAt,
      avatar: target?.avatar,
      group: post || target ? '1' : '0',
      read: read ? '1' : '0',
      user: target && {
        id: String(target.id),
        username: target.username || '',
        avatar: target.avatar
      },
      post: post && {
        id: String(post.id),
        described: post.description || '',
        status: post.status || ''
      },
      mark: mark && {
        mark_id: String(mark.id),
        type_of_mark: String(mark.type),
        mark_content: mark.content
      },
      feel: feel && {
        feel_id: String(feel.id),
        type: String(feel.type)
      }
    };
  }

  // Thực hiện việc kiểm tra xem một tab của trang chủ có phần tử mới không?
  static async checkNewItems(userId, lastId, categoryId) {
    let newItems = 0;
    switch (categoryId) {
      case CategoryType.Posts:
        newItems = await Post.count({
          // Lấy id lớn hơn lastId
          where: {
            id: { [Op.gt]: lastId }
          },
          include: [
            {
              model: User,
              as: 'author',
              include: [
                {
                  model: Block,
                  as: 'blocked',
                  where: { userId },
                  required: false
                },
                {
                  model: Block,
                  as: 'blocking',
                  where: { targetId: userId },
                  required: false
                }
              ]
            }
          ]
        });
        break;
      case CategoryType.Friends:
        newItems = await FriendRequest.count({ userId, read: false });
        break;
      case CategoryType.Videos:
        newItems = await Post.count({
          where: {
            id: { [Op.gt]: lastId }
          },
          include: [
            {
              model: User,
              as: 'author',
              include: [
                {
                  model: Block,
                  as: 'blocked',
                  where: { userId },
                  required: false
                },
                {
                  model: Block,
                  as: 'blocking',
                  where: { targetId: userId },
                  required: false
                }
              ]
            },
            {
              model: PostVideo,
              as: 'video'
            }
          ]
        });
        break;
      case CategoryType.Notifications:
        newItems = await this.notificationRepo.countBy({ userId, read: false });
    }
    return { new_items: String(newItems) };
  }

  static async createNotification(data) {
    const { type, userId, targetId, postId, markId, feelId, coins } = data;
    let { user, target, post, mark, feel } = data;
    if (userId === targetId) {
      return;
    }
    // Nếu userId là null or underfined thì đc đc gán,ngược lại thì không được gán
    user ??= await User.findOne({ where: { id: userId } });
    target ??= targetId ? await User.findOne({ where: { id: targetId } }) : undefined;
    post ??= postId ? await Post.findOne({ where: { id: postId } }) : undefined;
    mark ??= markId ? await Mark.findOne({ where: { id: markId } }) : undefined;
    feel ??= feelId ? await Feel.findOne({ where: { id: feelId } }) : undefined;
    // Không tạo giá trị của trường thông qua biến tham chiếu
    const notification = await Notification.create({
      type,
      userId,
      targetId,
      postId,
      markId,
      feelId,
      coins,
      user,
      target,
      post,
      mark,
      feel
    });
    // return notification;
    // Sử dụng Firebase cloud messaging để thực hiện gửi thông báo tới thiết bị
    const pushSettings = await SettingServices.getUserPushSettings(userId);
    if (pushSettings.notificationOn) {
      const devToken = await DevToken.findOne({ where: { userId: user.id } });
      const token = devToken?.token;
      if (token) {
        messaging().send({
          token,
          data: {
            json: JSON.stringify(this.mapNotification(notification))
          },
          notification: {
            title: 'Deepfake notification',
            body: 'You have a new notification'
          }
        });
      }
    }
  }

  // Lấy tất cả những thông báo
  static async getListNotifications(userId, body) {
    const { index, count } = { ...body };
    const noti = await Notification.findAll({ where: { userId } });
    console.log(noti);
    // Lấy tất cả các thông báo liên quan,chứa cả thông tin người dùng,bài viết,cảm xúc liên quan
    const { rows: notifications, count: total } = await Notification.findAndCountAll({
      where: { userId },
      include: [
        {
          model: User,
          as: 'target',
          required: false,
          include: [
            {
              model: Block,
              as: 'blocked',
              where: { userId },
              required: false
            },
            {
              model: Block,
              as: 'blocking',
              where: { targetId: userId },
              required: false
            }
          ]
        },
        { model: Post, as: 'post', required: false },
        { model: Mark, as: 'mark', required: false },
        { model: Feel, as: 'feel', required: false }
      ],
      order: [['id', 'DESC']],
      limit: count,
      offset: index,
      subQuery: false
    });
    setTimeout(() => {
      for (const notification of notifications) {
        notification.read = true;
        notification.save();
      }
    }, 1);
    return {
      // data: notifications.map(this.mapNotification),
      data: notifications.map(this.mapNotification),
      // data: '1',
      last_update: new Date(),
      // Số lượng thông báo chưa đọc
      badge: String(total - notifications.length)
    };
  }

  // Thông báo tới bạn bè khi có thêm mới một bài post
  static async notifyAddPost(postId, authorId) {
    const post = await Post.findOne({ where: { id: postId } });
    // Tìm kiếm trong bảng Friend và trả về danh sách bạn bè của tác giả
    const friends = await Friend.findAll({
      where: { userId: authorId },
      include: [{ model: User, as: 'target' }]
    });

    for (const { target } of friends) {
      // Lấy push setting từ csdl
      const pushSettings = await SettingServices.getUserPushSettings(target);
      const receiveNotification = pushSettings.fromFriends;
      // Nếu bạn bè để setting nhận thông báo
      if (receiveNotification) {
        await Notification.create({
          type: post.video ? NotificationType.VideoAdded : NotificationType.PostAdded,
          userId: target.id,
          targetId: authorId,
          postId: post.id
        });
      }
    }
  }

  // Thông báo liên quan tới việc chỉnh sửa bài viết
  static async notifyEditPost(postId, authorId) {
    const post = await Post.findOne({ where: { postId } });
    const marks = await Mark.findAll({ where: { postId } });
    for (const mark of marks) {
      if (mark.userId === authorId) {
        return;
      }
      await Notification.create({
        type: NotificationType.PostUpdated,
        userId: mark.userId,
        targetId: authorId,
        post,
        mark
      });
    }
  }
}
