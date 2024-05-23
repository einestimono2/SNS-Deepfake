import { GroupService } from './group.service.js';

import { CatchAsyncError } from '#middlewares';
import { getPaginationAttributes, getPaginationSummary } from '#utils';

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
    const result = await GroupService.getMyGroups(userId);
    res.ok({
      data: result
    });
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
    res.ok({ message: 'Đã xóa nhóm thành công!' });
  });

  static addMembers = CatchAsyncError(async (req, res) => {
    await GroupService.addMember(req.userPayload.userId, req.body, req.params.groupId);
    res.ok({ message: 'Thêm thành viên thành công !' });
  });

  static deleteMembers = CatchAsyncError(async (req, res) => {
    await GroupService.deleteMembers(req.userPayload.userId, req.body, req.params.groupId);
    res.ok({ message: 'Đã xóa thành viên khỏi nhóm!' });
  });

  static getAllGroup = CatchAsyncError(async (req, res) => {
    const result = await GroupService.getAllGroups({
      ...getPaginationAttributes(req.query)
    });
    res.ok(
      getPaginationSummary({
        ...req.query,
        result
      })
    );
  });
}
