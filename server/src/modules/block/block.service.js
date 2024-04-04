import { Op } from 'sequelize';

import { BadRequestError } from '../core/error.response.js';
import { FriendRequest } from '../friend/components/friend_request.model.js';
import { Friend } from '../friend/friend.model.js';
import { User } from '../user/user.model.js';

import { Block } from './block.model.js';

import { Message } from '#constants';

export class BlockServices {
  // 1:Lấy danh sách các blocks của 1 user
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
    return blocks.map((block) => ({
      id: String(block.target.id),
      name: block.target.username || '',
      avatar: block.target.avatar
    }));
  }

  // 2:Set Block 1 user
  static async setBlock(userId, targetId) {
    if (targetId === userId) {
      throw new BadRequestError(Message.CAN_NOT_BLOCK_);
    }
    // await this.authService.getUserById(targetId);
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

  // 3:Kiểm tra có được Block hay không
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
