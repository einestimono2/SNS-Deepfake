import { Op } from 'sequelize';

import { Block } from '../block/block.model.js';
import { FriendRequest } from '../friend/components/friend_request.model.js';
import { Friend } from '../friend/friend.model.js';
import { Feel } from '../post/models/feel.model.js';
import { Mark } from '../post/models/mark.model.js';
import { PostVideo } from '../post/models/post_video.model.js';
import { Post } from '../post/post.model.js';
import { User } from '../user/user.model.js';

import { Notification } from './notification.model.js';

import { CategoryType, NotificationType } from '#constants';

export class NotificationServices {
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

  static async checkNewItems(userId, lastId, categoryId) {
    let newItems = 0;
    switch (categoryId) {
      case CategoryType.Posts:
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
    const { type, userId = 0, targetId, postId, markId, feelId, coins } = data;
    let { user, target, post, mark, feel } = data;

    if ((user?.id || userId) === (target?.id || targetId || -1)) {
      return;
    }
    user ??= await this.authService.getUserById(userId);
    target ??= targetId ? await User.findOne({ where: { id: targetId } }) : undefined;
    post ??= postId ? await Post.findOne({ where: { id: postId } }) : undefined;
    mark ??= markId ? await Mark.findOne({ where: { id: markId } }) : undefined;
    feel ??= feelId ? await Feel.findOne({ where: { id: feelId } }) : undefined;
    const notification = await Notification.create({
      type,
      user,
      target,
      post,
      mark,
      feel,
      coins: coins ?? undefined
    });
    // const pushSettings = await this.settingService.getUserPushSettings(user);
    // if (pushSettings.notificationOn) {
    //   const devToken = await this.devTokenRepo.findOneBy({ userId: user.id });
    //   const token = devToken?.token;
    //   if (token) {
    //     messaging().send({
    //       token,
    //       data: {
    //         json: JSON.stringify(this.mapNotification(notification))
    //       },
    //       notification: {
    //         title: 'Anti-Fakebook notification',
    //         body: 'You have a new notification'
    //       }
    //     });
    //   }
    // }
  }

  static async getListNotification(userId, body) {
    const { index, count } = { ...body };
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
      offset: index
    });
    setTimeout(() => {
      for (const notification of notifications) {
        notification.read = true;
      }
      notifications.save();
    }, 1);
    return {
      data: notifications.map(this.mapNotification),
      last_update: new Date(),
      badge: String(total - notifications.length)
    };
  }

  // Thông báo liên quan tới việc thêm bài viết mới
  static async notifyAddPost(postId, authorId) {
    const post = await Post.findOne({ where: { id: postId } });
    // Tìm kiếm trong bảng Friend và trả về danh sách bạn bè của tác giả
    const friends = await Friend.findAll({
      where: { userId: authorId },
      include: [{ model: User, as: 'target' }]
    });

    for (const { target } of friends) {
      const pushSettings = await this.settingService.getUserPushSettings(target);
      const receiveNotification = pushSettings.fromFriends;
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

  // Thông báo liên quan tới việc chỉ sửa bài viết
  static async notifyEditPost(postId, authorId) {
    const marks = await Mark.findAll({ where: { postId } });

    for (const mark of marks) {
      if (mark.userId === authorId) {
        return;
      }
      await this.notificationModel.create({
        type: NotificationType.PostUpdated,
        userId: mark.userId,
        targetId: authorId,
        postId,
        markId: mark.id
      });
    }
  }
}
