import { getMessaging } from 'firebase-admin/messaging';
import { Op } from 'sequelize';

// import pkg from 'firebase-admin';
// const { messaging } = pkg;
import { Block } from '../block/block.model.js';
import { DeepfakeVideo } from '../deepfake_video/deepfake_video.model.js';
import { Friend } from '../friend/friend.model.js';
import { Feel } from '../post/models/feel.model.js';
import { Mark } from '../post/models/mark.model.js';
import { Post } from '../post/post.model.js';
import { SettingServices } from '../setting/setting.service.js';
import { User } from '../user/user.model.js';

import { Notification } from './notification.model.js';

import { DevToken } from '##/modules/user/models/device_token.model';
import { VideoSchedule } from '##/modules/video_schedule/video_schedule.model';
import { NotificationType } from '#constants';

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
  // static async checkNewItems(userId, lastId, categoryId) {
  //   let newItems = 0;
  //   switch (categoryId) {
  //     case CategoryType.Posts:
  //       newItems = await Post.count({
  //         // Lấy id lớn hơn lastId
  //         where: {
  //           id: { [Op.gt]: lastId }
  //         },
  //         include: [
  //           {
  //             model: User,
  //             as: 'author',
  //             include: [
  //               {
  //                 model: Block,
  //                 as: 'blocked',
  //                 where: { userId },
  //                 required: false
  //               },
  //               {
  //                 model: Block,
  //                 as: 'blocking',
  //                 where: { targetId: userId },
  //                 required: false
  //               }
  //             ]
  //           }
  //         ]
  //       });
  //       break;
  //     case CategoryType.Friends:
  //       newItems = await FriendRequest.count({ userId, read: false });
  //       break;
  //     case CategoryType.Videos:
  //       newItems = await Post.count({
  //         where: {
  //           id: { [Op.gt]: lastId }
  //         },
  //         include: [
  //           {
  //             model: User,
  //             as: 'author',
  //             include: [
  //               {
  //                 model: Block,
  //                 as: 'blocked',
  //                 where: { userId },
  //                 required: false
  //               },
  //               {
  //                 model: Block,
  //                 as: 'blocking',
  //                 where: { targetId: userId },
  //                 required: false
  //               }
  //             ]
  //           },
  //           {
  //             model: PostVideo,
  //             as: 'video'
  //           }
  //         ]
  //       });
  //       break;
  //     case CategoryType.Notifications:
  //       newItems = await this.notificationRepo.countBy({ userId, read: false });
  //   }
  //   return { new_items: String(newItems) };
  // }

  static async createNotification(data) {
    const { type, userId, targetId, postId, markId, feelId, videoId, videoDeepfakeId } = data;
    let { user, target, post, mark, feel, video, videodeepfake } = data;
    // if ((user?.id || userId) === (target?.id || targetId || -1)) {
    //   return;
    // }
    // Nếu user là null or underfined thì đc đc gán,ngược lại thì không được gán
    user ??= userId ? (await User.findOne({ where: { id: userId } })).toJSON() : undefined;
    target ??= targetId ? (await User.findOne({ where: { id: targetId } })).toJSON() : undefined;
    post ??= postId ? await Post.findOne({ where: { id: postId } }).toJSON() : undefined;
    mark ??= markId ? (await Mark.findOne({ where: { id: markId } })).toJSON() : undefined;
    feel ??= feelId ? (await Feel.findOne({ where: { id: feelId } })).toJSON() : undefined;
    video ??= videoId ? (await VideoSchedule.findOne({ where: { id: videoId } })).toJSON() : undefined;
    videodeepfake ??= videoDeepfakeId
      ? (await DeepfakeVideo.findOne({ where: { id: videoDeepfakeId } })).toJSON()
      : undefined;

    // Không tạo giá trị của trường thông qua biến tham chiếu
    const notification = await Notification.create({
      type,
      userId: user.id,
      targetId: target?.id,
      postId: post?.id,
      markId: mark?.id,
      feelId: feel?.id,
      videoId: video?.id,
      videoDeepfakeId: videodeepfake?.id
      // coins: coins ?? null
    });
    // return notification;
    // Sử dụng Firebase cloud messaging để thực hiện gửi thông báo tới thiết bị

    // Lấy pushSetting của người nhận thông báo
    const pushSettings = await SettingServices.getUserPushSettings(user);
    if (pushSettings.notificationOn) {
      const devToken = await DevToken.findOne({ where: { userId: user.id } });
      const token = devToken?.token;
      if (token) {
        await getMessaging().send({
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
  static async getListNotifications({ userId, limit, offset }) {
    const usersIdBlocked = await Block.findAll({
      where: { userId },
      attributes: ['targetId']
    });
    const usersIdBlocking = await Block.findAll({
      where: { targetId: userId },
      attributes: ['userId']
    });
    // Lấy tất cả các thông báo liên quan,chứa cả thông tin người dùng,bài viết,cảm xúc liên quan
    const notifications = await Notification.findAndCountAll({
      where: { targetId: userId },
      distinct: true,
      include: [
        {
          model: User,
          as: 'target',
          required: false,
          where: {
            id: {
              // [Op.notIn]: usersIdBlocked.targetId
              [Op.notIn]: [
                ...usersIdBlocked.map((block) => block.targetId),
                ...usersIdBlocking.map((block) => block.userId)
              ]
            }
          }
        },
        { model: Post, as: 'post', required: false },
        { model: Mark, as: 'mark', required: false },
        { model: Feel, as: 'feel', required: false }
      ],
      order: [['id', 'DESC']],
      limit,
      offset,
      subQuery: false
    });
    setTimeout(() => {
      for (const notification of notifications.rows) {
        notification.read = true;
        notification.save();
      }
    }, 1);
    return {
      rows: await Promise.all(
        notifications.rows.map(async (notification) => ({
          data: await this.mapNotification(notification)
        }))
      ),
      count: notifications.count
    };
  }

  // Thông báo tới bạn bè khi có thêm mới một bài post
  // static async notifyAddPost(postId, authorId) {
  //   const post = await Post.findOne({ where: { id: postId } });
  //   const author = await User.findOne({ where: { id: authorId } });
  //   // Thông báo tới thành viên trong nhóm
  //   // Tìm kiếm trong bảng Friend và trả về danh sách bạn bè của tác giả
  //   if (post.groupId === null) {
  //     const friends = await Friend.findAll({
  //       where: { userId: authorId },
  //       include: [{ model: User, as: 'target' }]
  //     });
  //     console.log(friends);
  //     const friendsJson = friends.map((friend) => friend.toJSON());
  //     console.log(friendsJson);
  //     for (const target of friendsJson) {
  //       // Lấy push setting từ csdl
  //       const pushSettings = (await SettingServices.getUserPushSettings(target.targetId)).toJSON();
  //       console.log(pushSettings);
  //       const receiveNotification = pushSettings.fromFriends;
  //       // Nếu bạn bè để setting nhận thông báo
  //       if (receiveNotification) {
  //         await this.createNotification({
  //           type: post.video ? NotificationType.VideoAdded : NotificationType.PostAdded,
  //           user: target,
  //           target: author,
  //           post
  //         });
  //       }
  //     }
  //   } else {
  //     const memberIds = await GroupUser.findAll({
  //       where: { groupId: post.groupId },
  //       attributes: ['userId']
  //     });
  //     const filteredMemberIds = memberIds.filter((member) => member !== authorId);

  //     const users = await User.findAll({
  //       where: { id: { [Op.in]: memberIds } }
  //     });
  //     const friendsJson = users.map((user) => user.toJSON());
  //     console.log(friendsJson);
  //     for (const target of friendsJson) {
  //       // Lấy push setting từ csdl
  //       const pushSettings = (await SettingServices.getUserPushSettings(target.targetId)).toJSON();
  //       console.log(pushSettings);
  //       const receiveNotification = pushSettings.fromFriends;
  //       // Nếu bạn bè để setting nhận thông báo
  //       if (receiveNotification) {
  //         await this.createNotification({
  //           type: post.video ? NotificationType.VideoAdded : NotificationType.PostAdded,
  //           user: target,
  //           target: author,
  //           post
  //         });
  //       }
  //     }
  //   }
  // }
  static async notifyAddPost(postId, authorId) {
    const post = await Post.findOne({ where: { id: postId } });
    const author = await User.findOne({ where: { id: authorId } });
    // Tìm kiếm trong bảng Friend và trả về danh sách bạn bè của tác giả
    const friends = await Friend.findAll({
      where: { userId: authorId },
      include: [{ model: User, as: 'target' }]
    });
    const friendsJson = friends.map((friend) => friend.toJSON());
    for (const target of friendsJson) {
      // Lấy push setting từ csdl
      const pushSettings = await SettingServices.getUserPushSettings(target);
      const receiveNotification = pushSettings.fromFriends;
      // Nếu bạn bè để setting nhận thông báo
      if (receiveNotification) {
        await this.createNotification({
          type: post.video ? NotificationType.VideoAdded : NotificationType.PostAdded,
          user: target.target,
          target: author.toJSON(),
          post: post.toJSON()
        });
      }
    }
  }

  // Thông báo liên quan tới việc chỉnh sửa bài viết tới các những người bình luận cấp 1 trừ(tác giả)
  static async notifyEditPost(postId, authorId) {
    const post = await Post.findOne({ where: { id: postId } });
    const author = await User.findOne({ where: { id: authorId } });
    const marks = await Mark.findAll({ where: { postId } });
    console.log(marks);
    for (const mark of marks) {
      if (mark.userId === authorId) {
        return;
      }
      await this.createNotification({
        type: NotificationType.PostUpdated,
        userId: mark.toJSON().userId,
        target: author.toJSON(),
        post: post.toJSON(),
        mark: mark.toJSON()
      });
    }
  }

  static async notifyPlayVideo(targetId, userId, videoId) {
    const user = await User.findOne({ where: { id: userId } });
    const target = await User.findOne({ where: { id: targetId } });
    // Lấy push setting từ csdl
    console.log(userId);
    const pushSettings = await SettingServices.getUserPushSettings(user);
    const receiveNotification = pushSettings.fromFriends;

    // Nếu bạn bè để setting nhận thông báo
    if (receiveNotification) {
      await this.createNotification({
        type: NotificationType.ScheduledVideo,
        user: user.toJSON(),
        target: target.toJSON(),
        videoId
      });
    }
  }

  static async notifyCreateVideo(userId, videoId) {
    const user = await User.findOne({ where: { id: userId } });
    // Lấy push setting từ csdl
    const pushSettings = await SettingServices.getUserPushSettings(user);
    const receiveNotification = pushSettings.fromFriends;
    // Nếu bạn bè để setting nhận thông báo
    if (receiveNotification) {
      await this.createNotification({
        type: NotificationType.CreateVideo,
        user: user.toJSON(),
        target: user.toJSON(),
        videoDeepfakeId: videoId
      });
    }
  }

  static async sendMessage({ fcmToken, title }) {
    await getMessaging().send({
      token: fcmToken,
      // data: {
      //   json: JSON.stringify({ user: 1 })
      // },
      notification: {
        title: 'Deepfake notification',
        body: 'You have a new notification'
      }
    });
  }
}
