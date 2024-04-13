import { GroupService } from './group.service.js';

import { CatchAsyncError } from '#middlewares';
import { getPaginationSummary } from '#utils';

export class GroupController {
  static createGroup = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const group = await GroupService.createGroup(userId, req.body);
    res.created({
      data: group
    });
  });

  static getMyGroups = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const result = await GroupService.getMyGroups(userId, req.body);
    res.ok(
      getPaginationSummary({
        ...req.query,
        result
      })
    );
  });

  static getGroupDetail = CatchAsyncError(async (req, res) => {
    const { groupId } = req.params;
    console.log(groupId);
    const group = await GroupService.getGroupDetail(groupId);
    res.ok({
      data: group
    });
  });

  static updateGroup = CatchAsyncError(async (req, res) => {
    const group = await GroupService.updateGroup(req.userPayload.userId, req.params.groupId, req.body);
    res.ok({ data: group });
  });

  static deleteGroup = CatchAsyncError(async (req, res) => {
    await GroupService.deleteGroup(req.userPayload.userId, req.params.groupId);
    res.ok({ message: 'Đã xóa thành viên khỏi nhóm!' });
  });

  static addMembers = CatchAsyncError(async (req, res) => {
    await GroupService.addMember(req.userPayload.userId, req.body, req.params.groupId);
    res.ok({ message: 'Thêm thành viên thành công !' });
  });

  static deleteMembers = CatchAsyncError(async (req, res) => {
    await GroupService.deleteMembers(req.userPayload.userId, req.body, req.params.groupId);
    res.ok({ message: 'Đã xóa thành viên khỏi nhóm!' });
  });
}
