import { BadRequestError, NotFoundError, UnauthorizedError } from '../../core/error.response.js';
import { User } from '../../user/user.model.js';
import { GroupUser } from '../groupuser.model.js';

import { Group } from './group.model.js';

import { Message } from '#constants';

export class GroupService {
  // Tạo nhóm gia đình
  static async createGroup(userId, body) {
    const { name, memberIds, description, coverPhoto } = { ...body };
    if (!userId) throw new UnauthorizedError(Message.USER_IS_INVALID);
    // Danh sách các thành viên
    const members = [userId, ...memberIds];
    const newGroup = await Group.create({
      groupName: name,
      description,
      creatorId: userId,
      coverPhoto
    });
    for (const member of members) {
      await GroupUser.create({
        groupId: newGroup.id,
        userId: member
      });
    }
    return newGroup;
  }

  // Danh sách các nhóm
  static async getMyGroups({ userId, limit, offset }) {
    if (!userId) {
      throw new UnauthorizedError(Message.USER_IS_INVALID);
    }
    const result = await GroupUser.findAndCountAll({
      where: { userId },
      include: [
        {
          model: Group,
          as: 'groupofuser'
        }
      ],
      limit,
      offset
    });
    return result;
  }

  // Chi tiết nhóm
  static async getGroupDetail(groupId) {
    if (!groupId) throw new BadRequestError(Message.ID_EMPTY);
    const group = await Group.findByPk(groupId, {
      include: [
        {
          model: User,
          as: 'members',
          attributes: ['id', 'avatar', 'username', 'email', 'phoneNumber'],
          through: { attributes: [] }
        }
      ]
    });
    if (!group) throw new NotFoundError(Message.GROUP_NOT_FOUND);
    return group;
  }

  // Chỉnh sửa thông tin nhóm(chỉ chủ nhóm)
  static async updateGroup(userId, groupId, body) {
    console.log(groupId);
    if (!groupId) throw new BadRequestError(Message.ID_EMPTY);
    const group = await Group.findByPk(groupId);
    if (userId !== group.creatorId) throw new BadRequestError(Message.NOT_AllOWED);
    if (body.name) group.groupName = body.name;
    if (body.description) group.description = body.description;
    if (body.coverImage) group.coverImage = body.coverImage;
    await group.save();
    return group;
  }

  // Xóa nhóm (chỉ chủ nhóm)
  static async deleteGroup(userId, groupId) {
    if (!groupId) throw new BadRequestError(Message.ID_EMPTY);
    const group = await Group.findByPk({ where: { id: groupId } });
    if (userId !== group.creatorId) throw new BadRequestError(Message.NOT_AllOWED);
    await Group.destroy({ where: { id: groupId } });
    await GroupUser.destroy({ where: { groupId } });
    return {};
  }

  // Thêm thành viên vào nhóm
  static async addMember(userId, memberIds, groupId) {
    if (!groupId) throw new BadRequestError(Message.ID_EMPTY);
    console.log(memberIds);
    for (const targetId of memberIds) {
      if (userId === targetId) throw new BadRequestError(Message.USER_IS_INVALID);
      // User đã tồn tại trong nhóm
      const existingMembership = await GroupUser.findOne({
        where: { userId: targetId, groupId }
      });
      console.log(existingMembership);
      if (existingMembership) throw new BadRequestError(Message.USER_IS_INVALID);
      await GroupUser.create({
        groupId,
        userId: targetId
      });
    }
  }

  // Xóa thành viên khỏi nhóm
  static async deleteMembers(userId, membersId, groupId) {
    if (!groupId) throw new BadRequestError(Message.ID_EMPTY);
    const group = await Group.findByPk(groupId);
    for (const targetId of membersId) {
      if (userId !== group.creatorId) throw new BadRequestError(Message.USER_IS_INVALID);
      await GroupUser.destroy({
        where: {
          groupId,
          userId: targetId
        }
      });
    }
    return {};
  }
}
