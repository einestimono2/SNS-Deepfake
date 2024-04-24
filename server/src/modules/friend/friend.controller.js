import { FriendServices } from './friend.service.js';

import { CatchAsyncError } from '#middlewares';
import { getPaginationAttributes, getPaginationSummary } from '#utils';

export class FriendControllers {
  static getRequestedFriends = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const listRequestedFriends = await FriendServices.getRequestedFriends(
      userId,
      ...getPaginationAttributes(req.query)
    );
    res.ok(
      getPaginationSummary({
        ...req.query,
        listRequestedFriends
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
    const { userId } = req.userPayload;
    const data = await FriendServices.getUserFriends(userId, ...getPaginationAttributes(req.query));
    res.ok(
      getPaginationSummary({
        ...req.query,
        data
      })
    );
  });

  static getSuggestedFriends = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { targetId } = req.params;
    const remainUsers = await FriendServices.getSuggestedFriends(userId, ...getPaginationAttributes(req.query));
    res.ok(
      getPaginationSummary({
        ...req.query,
        remainUsers
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
}
