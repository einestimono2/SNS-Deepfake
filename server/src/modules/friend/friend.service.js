import sequelize, { Op } from 'sequelize';

import { Block } from '../block/block.model.js';
import { BlockServices } from '../block/block.service.js';
import { BadRequestError } from '../core/error.response.js';
import { User } from '../user/user.model.js';

import { FriendRequest } from './components/friend_request.model.js';
import { Friend } from './friend.model.js';

import { AccountStatus, Message } from '#constants';

export class FriendServices {
  // 1:Lấy danh sách các yêu cầu kết bạn(Đã test)
  static async getRequestedFriends(userId, body) {
    const { index, count } = { ...body };
    // Trả về danh sách các yêu cầu gửi tới bạn và tổng các yêu cầu
    const { rows: requestedFriends, count: total } = await FriendRequest.findAndCountAll({
      where: { targetId: userId },
      include: [
        {
          model: User,
          as: 'user',
          required: true,
          attributes: {
            include: [
              [
                // Lấy ra số lượng bạn chung
                sequelize.literal(
                  `(SELECT COUNT(*) FROM "Friends" AS "same_friend"
                                INNER JOIN "Friends" AS "target_friends" ON "same_friend"."targetId" = "target_friends"."userId"
                                WHERE "user"."id" = "target_friends"."targetId" AND "target_friends"."userId" = ${userId})`
                ),
                'friendsCount'
              ]
            ]
          }
        }
      ],
      order: [['id', 'DESC']],
      offset: index,
      limit: count
    });
    for (const friendRequest of requestedFriends) {
      friendRequest.read = true;
      await friendRequest.save();
    }
    return {
      requests: requestedFriends.map((requestedFriend) => ({
        id: String(requestedFriend.user.id),
        username: requestedFriend.user.username || '',
        avatar: requestedFriend.user.avatar,
        same_friends: String(requestedFriend.user.friendsCount),
        created: requestedFriend.createdAt
      })),
      total: String(total)
    };
  }

  // 2:Gửi 1 lời mời(Đã test)
  static async setRequestFriend(userId, targetId) {
    // Kiểm tra xem người dùng có bị chặn không
    if (await BlockServices.isBlock(userId, targetId)) {
      throw new BadRequestError(Message.CAN_NOT_BLOCK);
    }
    // Kiểm tra xem userId có trùng với targetId không
    if (userId === targetId) {
      throw new BadRequestError(Message.USER_IS_INVALID);
    }
    // Kiểm tra xem đã có yêu cầu kết bạn từ hai người dùng này chưa
    const existedRequest = await FriendRequest.findOne({
      where: [
        { userId, targetId },
        { userId: targetId, targetId: userId }
      ]
    });
    if (existedRequest) {
      throw new BadRequestError(Message.UNABLE_TO_SENT_FRIEND_REQUEST);
    }
    // Tạo yêu cầu kết bạn mới
    await FriendRequest.create({ userId, targetId });
    // Đếm số lượng yêu cầu kết bạn mà user đã gửi
    const requestedFriends = await FriendRequest.count({
      where: { userId }
    });
    // Lấy thông tin của người nhận yêu cầu
    // const target = await User.findOne({ where: { id: targetId } });
    // Tạo thông báo cho người nhận yêu cầu
    // await this.notificationService.createNotification({
    //   type: NotificationType.FriendRequest,
    //   user: target,
    //   target: user
    // });
    return {
      requested_friends: String(requestedFriends)
    };
  }

  // 3:Chấp nhận lời mời kết bạn(Cần xem lại sau)
  static async setAcceptFriend(userId, body) {
    // Tìm yêu cầu kết bạn
    const { targetId, isAccept } = { ...body };
    // Kiểm tra có yêu cầu gửi kết bạn tới bạn hay không
    // Đối với 1 người gửi request friend tới mình thì userId lưu trữ id của người đó,còn targetId sẽ là id của mình
    const request = await FriendRequest.findOne({
      where: {
        userId: targetId,
        targetId: userId
      }
    });
    console.log(request);
    // Nếu không tìm thấy yêu cầu
    if (!request) {
      throw new BadRequestError(Message.FRIEND_REQUEST_NOT_FOUND);
    }
    // Nếu yêu cầu được chấp nhận
    if (isAccept === '1') {
      // Tạo mối quan hệ bạn mới và cùng lúc
      await Friend.bulkCreate([
        { targetId, userId },
        { targetId: userId, userId: targetId }
      ]);
      await FriendRequest.destroy({ where: { id: request.id } });
      // Tạo thông báo cho người gửi yêu cầu
      // await this.notificationService.createNotification({
      //   type: NotificationType.FriendAccepted,
      //   userId: request.userId,
      //   target: user
      // });
    }
    return {};
    // Xóa yêu cầu kết bạn
  }

  // 4.Lấy danh sách bạn bè(Đã test nhưng vẫn cần xem lại)
  static async getUserFriends(userId, body) {
    const { index, count } = { ...body };
    // Tìm tất cả bạn của người dùng và số lượng
    const { rows: friends, count: total } = await Friend.findAndCountAll({
      where: { userId },
      include: [
        {
          model: User,
          as: 'target',
          attributes: {
            include: [
              [
                sequelize.literal(
                  `(SELECT COUNT(*) FROM "Friends" AS "same_friend"
                                INNER JOIN "Friends" AS "target_friends" ON "same_friend"."targetId" = "target_friends"."userId"
                                WHERE "target"."id" = "target_friends"."targetId" AND "target_friends"."userId" = ${userId})`
                ),
                'friendsCount'
              ]
            ]
          }
        }
      ],
      // order: [['id', 'DESC']],
      offset: index,
      limit: count
    });
    console.log(friends);
    // Trả về danh sách bạn của người dùng và tổng số lượng bạn
    return {
      friends: friends.map((friend) => ({
        id: String(friend.target.id),
        username: friend.target.username || '',
        avatar: friend.target.avatar,
        same_friends: String(friend.target.friendsCount),
        created: friend.target.createdAt
      })),
      total: String(total)
    };
  }

  // 5.Lấy danh sách bạn bè gợi ý(Đã test)
  static async getSuggestedFriends(userId, body) {
    // Tìm tất cả người dùng không bị block,không gửi yêu cầu,không phải là bạn bè
    const { index, count } = { ...body };
    const remainUsers = await User.findAll({
      where: {
        id: { [Op.not]: userId }, // Không bao gồm người dùng hiện tại
        status: { [Op.not]: AccountStatus.Inactive } // Không bao gồm tài khoản bị vô hiệu hóa
      },
      include: [
        {
          model: Block,
          as: 'blocked',
          where: { userId },
          required: false // Tham gia bảng 'blocked' với điều kiện có thể là null
        },
        {
          model: Block,
          as: 'blocking',
          where: { targetId: userId },
          required: false // Tham gia bảng 'blocking' với điều kiện có thể là null
        },
        {
          model: Friend,
          as: 'friends',
          where: { targetId: userId },
          required: false // Tham gia bảng 'friends' với điều kiện có thể là null
        },
        {
          model: FriendRequest,
          as: 'friendRequested',
          where: { userId },
          required: false // Tham gia bảng 'friendRequested' với điều kiện có thể là null
        },
        {
          model: FriendRequest,
          as: 'friendRequesting',
          where: { userId },
          required: false // Tham gia bảng 'friendRequesting' với điều kiện có thể là null
        }
      ],
      attributes: {
        include: [
          [
            sequelize.literal(
              `(SELECT COUNT(*) FROM "Friends" AS "same_friend"
                        INNER JOIN "Friends" AS "target_friends" ON "same_friend"."targetId" = "target_friends"."userId"
                        WHERE "User"."id" = "target_friends"."targetId" AND "target_friends"."userId" = ${userId})`
            ),
            'friendsCount'
          ]
        ]
      },
      order: [
        ['lastActive', 'DESC'],
        ['id', 'ASC']
      ], // Sắp xếp theo lastActive giảm dần, id tăng dần
      offset: index,
      limit: count
    });
    // Trả về danh sách người dùng còn lại đã được chọn
    return remainUsers.map((remainUser) => ({
      id: String(remainUser.id),
      username: remainUser.username || '',
      avatar: remainUser.avatar,
      created: remainUser.createdAt,
      same_friends: String(remainUser.friendsCount)
    }));
  }

  // 6.Unfriend(Đã test)
  static async setUnfriend(userId, targetId) {
    const user = await User.findOne({ where: { id: targetId } });
    if (!user) {
      throw new BadRequestError(Message.USER_IS_INVALID);
    }
    await Friend.destroy({ where: { userId, targetId } });
    await Friend.destroy({ where: { userId: targetId, targetId: userId } });
    return {};
  }

  // 7.Xóa 1 lời mời(Đã test)
  static async delRequestFriend(userId, targetId) {
    const user = await User.findOne({ where: { id: targetId } });
    if (!user) {
      throw new BadRequestError(Message.USER_IS_INVALID);
    }
    await FriendRequest.destroy({ where: { userId, targetId } });
    return {};
  }
}
