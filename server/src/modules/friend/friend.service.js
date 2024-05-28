import sequelize, { Op } from 'sequelize';

import { Block } from '../block/block.model.js';
import { BlockServices } from '../block/block.service.js';
import { BadRequestError } from '../core/error.response.js';
import { User } from '../user/user.model.js';

import { FriendRequest } from './components/friend_request.model.js';
import { Friend } from './friend.model.js';

import { AccountStatus, Message } from '#constants';
import { redis } from '#dbs';

export class FriendServices {
  // 1:Lấy danh sách các yêu cầu kết bạn(Đã test)
  static async getRequestedFriends({ userId, limit, offset }) {
    // Trả về danh sách các yêu cầu gửi tới bạn và tổng các yêu cầu
    // Trong bảng Friend userId là id của người gửi yêu cầu,còn targetId là người nhận yêu cầu
    const requestedFriends = await FriendRequest.findAndCountAll({
      where: { targetId: userId },
      include: [
        {
          model: User,
          as: 'user',
          required: true,
          attributes: [
            'id',
            'avatar',
            'username',
            'email',
            'createdAt',
            // Lấy ra số lượng bạn chung của 2 người
            [
              sequelize.literal(
                `(SELECT COUNT(*) FROM "Friends" AS "same_friend"
                                INNER JOIN "Friends" AS "target_friends" ON "same_friend"."targetId" = "target_friends"."targetId"
                                WHERE "same_friend"."userId"=${userId}  AND "target_friends"."userId" = "user"."id")`
              ),
              'friendsCount'
            ],
            [
              // Lấy thông tin bạn chung của 2 người
              // sequelize.literal(
              //   `(SELECT ARRAY_AGG("same_friend"."targetId") FROM "Friends" AS "same_friend"
              // INNER JOIN "Friends" AS "target_friends" ON "same_friend"."targetId" = "target_friends"."targetId"
              // WHERE "same_friend"."userId" = ${userId} AND "target_friends"."userId" = "user"."id")`
              // ),
              // 'commonUserIds'
              sequelize.literal(
                `(SELECT ARRAY_AGG("u"."avatar") FROM "Users" AS "u"
                WHERE "u"."id" IN (
                SELECT "same_friend"."targetId" FROM "Friends" AS "same_friend"
                INNER JOIN "Friends" AS "target_friends" ON "same_friend"."targetId" = "target_friends"."targetId"
                WHERE "same_friend"."userId" = ${userId} AND "target_friends"."userId" = "user"."id"
                 )
                LIMIT 5
                 )`
              ),
              'commonUserAvatars'
            ]
          ]
        }
      ],
      order: [['id', 'DESC']],
      limit,
      offset
    });

    return {
      rows: requestedFriends.rows.map((requestedFriend) => ({
        id: requestedFriend.user.id,
        username: requestedFriend.user.username || requestedFriend.user.email,
        avatar: requestedFriend.user.avatar,
        same_friends: requestedFriend.user.getDataValue('friendsCount') ?? 0,
        commonUserAvatars: requestedFriend.user.getDataValue('commonUserAvatars'),
        created: requestedFriend.createdAt
      })),
      count: requestedFriends.count
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
      where: {
        [Op.or]: [
          { userId, targetId },
          { userId: targetId, targetId: userId }
        ]
      }
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
    const { targetId } = { ...body };
    // Kiểm tra có yêu cầu gửi kết bạn tới bạn hay không
    // Đối với 1 người gửi request friend tới mình thì userId lưu trữ id của người đó,còn targetId sẽ là id của mình
    const request = await FriendRequest.findOne({
      where: {
        userId: targetId,
        targetId: userId
      }
    });

    // Nếu không tìm thấy yêu cầu
    if (!request) {
      throw new BadRequestError(Message.FRIEND_REQUEST_NOT_FOUND);
    }

    // Tạo mối quan hệ bạn mới và cùng lúc
    await Promise.all([
      Friend.create({
        targetId,
        userId
      }),
      Friend.create({
        targetId: userId,
        userId: targetId
      })
    ]);

    await FriendRequest.destroy({ where: { id: request.id } });
    // Tạo thông báo cho người gửi yêu cầu
    // await this.notificationService.createNotification({
    //   type: NotificationType.FriendAccepted,
    //   userId: request.userId,
    //   target: user
    // });
  }

  // 4.Lấy danh sách bạn bè(Đã test nhưng vẫn cần xem lại)
  static async getUserFriends({ userId, limit, offset }) {
    // Tìm tất cả bạn của người dùng và số lượng

    const friends = await Friend.findAndCountAll({
      where: { userId },
      include: [
        {
          model: User,
          as: 'target',
          attributes: [
            'id',
            'avatar',
            'username',
            'email',
            'createdAt',
            [
              sequelize.literal(
                `(SELECT COUNT(*) FROM "Friends" AS "same_friend"
                              INNER JOIN "Friends" AS "target_friends" ON "same_friend"."targetId" = "target_friends"."targetId"
                              WHERE "same_friend"."userId"=${userId}  AND "target_friends"."userId" = "target"."id")`
              ),
              'friendsCount'
            ],
            [
              // Lấy thông tin bạn chung của 2 người
              sequelize.literal(
                `(SELECT "same_friend"."targetId" FROM "Friends" AS "same_friend"
                              INNER JOIN "Friends" AS "target_friends" ON "same_friend"."targetId" = "target_friends"."targetId"
                              WHERE "same_friend"."userId"=${userId}  AND "target_friends"."userId" ="target"."id")`
              ),
              'commonUserIds'
            ]
          ]
        }
      ],
      order: [['id', 'DESC']],
      offset,
      limit
    });

    // Trả về danh sách bạn của người dùng và tổng số lượng bạn
    return {
      rows: friends.rows.map((friend) => ({
        id: friend.target.id,
        username: friend.target.username || friend.target.email,
        avatar: friend.target.avatar,
        same_friends: friend.target.getDataValue('friendsCount') ?? 0,
        commonUserIds: friend.target.getDataValue('commonUserIds'),
        created: friend.target.createdAt
      })),
      count: friends.count
    };
    // {
    //   friends: friends.map((friend) => ({
    //     id: String(friend.target.id),
    //     username: friend.target.username || '',
    //     avatar: friend.target.avatar,
    //     same_friends: String(friend.target.friendsCount),
    //     created: friend.target.createdAt
    //   }))
    // };
  }

  // 5.Lấy danh sách gợi ý là bạn bè
  // Chỉ lọc ra danh sách những người có bạn chung với bạn
  static async getSuggestedFriends({ userId, limit, offset }) {
    const usersIdBlocked = await Block.findAll({
      where: { userId },
      attributes: ['targetId']
    });

    const usersIdBlocking = await Block.findAll({
      where: { targetId: userId },
      attributes: ['userId']
    });
    // Lấy ra những người có bạn chung với userId
    const mutualFriendsSubquery = sequelize.literal(
      `(SELECT "target_friends"."targetId" 
      FROM "Friends" AS "same_friend"
      INNER JOIN "Friends" AS "target_friends" 
      ON "same_friend"."targetId" = "target_friends"."userId"
      WHERE "same_friend"."userId" = ${userId}
      AND "target_friends"."userId" != ${userId})`
    );
    // Danh sách các người bạn gợi ý bị gỡ
    const removedSuggestions = await redis.smembers(`removed_suggestions:${userId}`);
    const remainUsers = await User.findAndCountAll({
      where: {
        status: { [Op.not]: AccountStatus.Inactive },
        id: {
          [Op.not]: userId,
          [Op.notIn]: [
            ...usersIdBlocked.map((block) => block.targetId),
            ...usersIdBlocking.map((block) => block.userId),
            ...removedSuggestions
          ],
          [Op.in]: mutualFriendsSubquery
        }
      },
      attributes: [
        'id',
        'avatar',
        'username',
        'email',
        'createdAt',
        // Lấy ra số lượng bạn chung của 2 người
        [
          sequelize.literal(
            `(SELECT COUNT(*) FROM "Friends" AS "same_friend"
                                INNER JOIN "Friends" AS "target_friends" ON "same_friend"."targetId" = "target_friends"."targetId"
                                WHERE "same_friend"."userId"=${userId}  AND "target_friends"."userId" = "User"."id")`
          ),
          'commondfriendsCount'
        ]
        // ,
        // [
        //   // Lấy thông tin bạn chung của 2 người
        //   sequelize.literal(
        //     `(SELECT "same_friend"."targetId" FROM "Friends" AS "same_friend"
        //                         INNER JOIN "Friends" AS "target_friends" ON "same_friend"."targetId" = "target_friends"."targetId"
        //                         WHERE "same_friend"."userId"=${userId}  AND "target_friends"."userId" ="User"."id")`
        //   ),
        //   'commonUserIds'
        // ]
      ],
      include: [
        {
          model: Friend,
          as: 'friends',
          include: [
            {
              model: User,
              as: 'target',
              attributes: ['id', 'username', 'avatar']
            }
          ],
          attributes: [],
          required: false
        }
      ],
      order: [
        // ['lastActive', 'DESC'],
        ['id', 'ASC']
      ],
      offset,
      limit
    });

    return {
      rows: remainUsers.rows.map((friend) => ({
        id: friend.id,
        username: friend.username || friend.email,
        avatar: friend.avatar,
        created: friend.createdAt,
        same_friends: friend.getDataValue('commondfriendsCount') ?? 0,
        commonUserIds: friend.getDataValue('commonUserIds')
      })),
      count: remainUsers.count
    };
    // remainUsers.map((remainUser) => ({
    //   id: String(remainUser.id),
    //   username: remainUser.username || '',
    //   avatar: remainUser.avatar,
    //   created: remainUser.createdAt,
    //   same_friends: String(remainUser.friendsCount)
    // }));
  }

  // 6.Unfriend(Đã test)
  static async setUnfriend(userId, targetId) {
    const user = await User.findOne({ where: { id: targetId } });
    if (!user) {
      throw new BadRequestError(Message.USER_IS_INVALID);
    }
    await Friend.destroy({ where: { userId, targetId } });
    await Friend.destroy({ where: { userId: targetId, targetId: userId } });
  }

  // 7.Xóa 1 lời mời(Đã test)
  static async delRequestFriend(userId, targetId) {
    const user = await User.findOne({ where: { id: targetId } });
    if (!user) {
      throw new BadRequestError(Message.USER_IS_INVALID);
    }
    await FriendRequest.destroy({ where: { userId, targetId } });
  }

  // 8. Tìm kiếm bạn bè
  static async searchFriends({ userId, limit, offset }, body) {
    const { searchTerm } = { ...body };
    const friends = await Friend.findAndCountAll({
      where: { userId },
      include: [
        {
          model: User,
          as: 'target',
          required: true,
          where: {
            id: { [Op.not]: userId },
            [Op.or]: [{ username: { [Op.iLike]: `${searchTerm}%` } }, { email: { [Op.iLike]: `${searchTerm}%` } }]
          },
          attributes: ['id', 'avatar', 'email', 'username', 'phoneNumber']
        }
      ],
      offset,
      limit
    });

    return friends;
    // friends.map((friend) => ({
    //   id: friend.id,
    //   username: friend.username,
    //   email: friend.email
    // }));
  }

  // 9. Xóa một gợi ý bạn bè
  static async removeSuggestedFriend(userId, suggestedfriendId) {
    // Lưu thông tin gợi ý đã bị gỡ vào Redis hash
    redis.sadd(`removed_suggestions:${userId}`, suggestedfriendId);

    // Lấy danh sách các gợi ý kết bạn cập nhật
    const suggestedFriends = await this.getSuggestedFriends({ userId, limit: 10, offset: 0 });

    // Trả về danh sách các gợi ý kết bạn ngoài trừ friendId
    // Lấy danh sách các friendId đã bị gỡ từ Redis
    const removedSuggestions = await redis.smembers(`removed_suggestions:${userId}`);

    // Lọc bỏ các gợi ý đã bị gỡ
    const updatedSuggestedFriends = suggestedFriends.filter(
      (friend) => !removedSuggestions.includes(String(friend.id))
    );
    return updatedSuggestedFriends;
  }
}
