import { Op } from 'sequelize';

import { BadRequestError } from '../core/error.response.js';
import { FriendRequest } from '../friend/components/friend_request.model.js';
import { Friend } from '../friend/friend.model.js';
import { User } from '../user/user.model.js';

import { Block } from './block.model.js';

import { Message } from '#constants';

export class BlockServices {
  // 1:Lấy danh sách các user mà bị block bởi người dùng hiện tại
  // userId:người sở hữu block
  // targetId:người bị user này block
  static async getListBlocks(userId, body) {
    const { index, count } = { ...body };
    const blocks = await Block.findAll({
      where: { userId },
      include: [
        {
          model: User,
          as: 'target'
        }
      ],
      order: [['id', 'ASC']],
      offset: index,
      limit: count
    });
    // blocks sẽ chứa thông tin bảng user và object target tương ứng(ví dụ)
    //               {
    //                   "id": 5,
    //                   "targetId": 21,
    //                   "userId": 25,
    //                   "createdAt": "2024-04-15T08:03:34.000Z",
    //                   "updatedAt": "2024-04-15T08:03:37.000Z",
    //                   "target": {
    //                       "id": 21,
    //                       "role": null,
    //                       "avatar": "https://cloudflare-ipfs.com/avatar/978.jpg",
    //                       "coverImage": null,
    //                       "phoneNumber": null,
    //                       "email": "HoangViet90@gmail.com",
    //                       "password": "$2a$10$HKgQ8SKcbNBPr7LcQExX8OetnuDkpXPxK89tArx3/5xHcE5jdcAra",
    //                       "token": null,
    //                       "username": "Dương Khánh Ngô",
    //                       "status": 1,
    //                       "coins": 83,
    //                       "lastActive": null,
    //                       "deletedAt": null,
    //                       "createdAt": "2024-04-06T15:34:46.798Z",
    //                       "updatedAt": "2024-04-06T15:34:46.798Z"
    //                   }
    //               },
    return blocks.map((block) => ({
      blocks,
      id: String(block.target.id),
      name: block.target.username || '',
      avatar: block.target.avatar
    }));
  }

  // 2:Set Block 1 user
  static async setBlock(userId, targetId) {
    if (targetId === userId) {
      throw new BadRequestError(Message.CAN_NOT_BLOCK);
    }
    const userTarget = await User.findOne({
      where: { id: targetId }
    });
    if (!userTarget) {
      throw new BadRequestError(Message.USER_IS_INVALID);
    }
    if (await this.isBlock(userId, targetId)) {
      throw new BadRequestError(Message.CAN_NOT_BLOCK);
    }
    // Tạo mới một block
    const block = await Block.create({
      targetId,
      userId
    });
    // Xóa các mối quan hệ bạn bè và các yêu cầu kết bạn giữa hai người
    await Promise.all([
      Friend.destroy({
        where: {
          userId,
          targetId
        }
      }),
      Friend.destroy({
        where: {
          userId: targetId,
          targetId: userId
        }
      }),
      FriendRequest.destroy({
        where: {
          userId,
          targetId
        }
      }),
      FriendRequest.destroy({
        where: {
          userId: targetId,
          targetId: userId
        }
      })
    ]);

    return { block };
  }

  // 3:Kiểm tra 1 cặp người dùng có block lẫn nhau hay không hay không
  static async isBlock(userId, targetId) {
    const block = await Block.findOne({
      where: {
        [Op.or]: [
          { userId, targetId },
          { userId: targetId, targetId: userId }
        ]
      }
    });
    return Boolean(block);
  }

  // 4.Unblock
  static async unBlock(userId, targetId) {
    // Tìm một block theo userId và targetId
    const block = await Block.findOne({
      where: {
        targetId,
        userId
      }
    });
    // Nếu block tồn tại, xóa nó
    if (block) {
      await block.destroy();
    }
    return {};
  }
}
