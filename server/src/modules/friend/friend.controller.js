import { FriendServices } from './friend.service.js';

import { CatchAsyncError } from '#middlewares';
import { getPaginationAttributes, getPaginationSummary } from '#utils';

export class FriendControllers {
  static getRequestedFriends = CatchAsyncError(async (req, res) => {
    const result = await FriendServices.getRequestedFriends({
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

  static setRequestFriend = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { targetId } = req.params;
    const requestedFriends = await FriendServices.setRequestFriend(userId, targetId);

    res.ok({
      data: requestedFriends
    });
  });

  static setAcceptFriend = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    await FriendServices.setAcceptFriend(userId, req.body);
    res.ok({
      message: 'Đã chấp nhận là bạn bè'
    });
  });

  static getUserFriends = CatchAsyncError(async (req, res) => {
    const result = await FriendServices.getUserFriends({
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

  static getSuggestedFriends = CatchAsyncError(async (req, res) => {
    // const { limit, offset } = { ...getPaginationAttributes(req.query) };
    const result = await FriendServices.getSuggestedFriends({
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

  static setUnfriend = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { targetId } = req.params;
    await FriendServices.setUnfriend(userId, targetId);
    res.ok({
      message: 'Đã hủy bạn bè với người dùng này'
    });
  });

  static delRequestFriend = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { targetId } = req.params;
    await FriendServices.delRequestFriend(userId, targetId);
    res.ok({
      message: 'Đã xóa yêu cầu kết bạn thành công'
    });
  });

  static searchFriends = CatchAsyncError(async (req, res) => {
    const result = await FriendServices.searchFriends(
      {
        userId: req.userPayload.userId,
        ...getPaginationAttributes(req.query)
      },
      req.body
    );
    res.ok(
      getPaginationSummary({
        ...req.query,
        result
      })
    );
  });
}
