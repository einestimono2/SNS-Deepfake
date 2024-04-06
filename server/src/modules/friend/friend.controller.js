import { FriendServices } from './friend.service.js';

import { CatchAsyncError } from '#middlewares';
// 1--Đăng ký
export class FriendControllers {
  static getRequestedFriends = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const listRequestedFriends = await FriendServices.getRequestedFriends(userId, req.body);
    res.ok({
      data: listRequestedFriends
    });
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
    const { targetId } = req.params;
    const data = await FriendServices.getUserFriends(userId, targetId);
    res.ok({
      data
    });
  });

  static getSuggestedFriends = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { targetId } = req.params;
    const remainUsers = await FriendServices.getSuggestedFriends(userId, targetId);
    res.ok({
      data: remainUsers
    });
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
