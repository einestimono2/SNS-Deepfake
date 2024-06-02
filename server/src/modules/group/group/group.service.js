import { BadRequestError, NotFoundError, UnauthorizedError } from '../../core/error.response.js';
import { User } from '../../user/user.model.js';
import { GroupUser } from '../groupuser.model.js';

import { Group } from './group.model.js';

import { Message } from '#constants';
import { deleteFile, setFileUsed } from '#utils';

export class GroupService {
  // Tạo nhóm gia đình
  static async createGroup(userId, body) {
    const { name, memberIds, description, coverPhoto } = { ...body };
    if (!userId) throw new UnauthorizedError(Message.USER_IS_INVALID);

    // Danh sách các thành viên
    const members = [userId, ...memberIds];
    let photo = null;
    if (coverPhoto) {
      photo = setFileUsed(coverPhoto);
    }

    const newGroup = await Group.create({
      groupName: name,
      description,
      creatorId: userId,
      coverPhoto: photo
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
  static async getMyGroups(userId) {
    if (!userId) {
      throw new UnauthorizedError(Message.USER_IS_INVALID);
    }

    const result = await Group.findAll({
      order: [['updatedAt', 'DESC']],
      include: [
        // {
        //   model: GroupUser,
        //   as: 'userofgroup',
        //   attributes: [],
        //   where: {
        //     userId
        //   }
        // },
        {
          model: User,
          as: 'members',
          attributes: ['id', 'avatar', 'username', 'email', 'phoneNumber'],
          through: { attributes: [] }
        }
      ]
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
    if (!groupId) throw new BadRequestError(Message.ID_EMPTY);

    const group = await Group.findByPk(groupId);
    if (userId !== group.creatorId) throw new BadRequestError(Message.NOT_AllOWED);

    if (body.name) group.groupName = body.name;
    if (body.description) group.description = body.description;
    if (body.coverImage) {
      const oldPhoto = group.coverImage;
      group.coverPhoto = setFileUsed(body.coverImage);

      deleteFile(oldPhoto);
    }

    await group.save();

    return group;
  }

  // Xóa nhóm (chỉ chủ nhóm)
  static async deleteGroup(userId, groupId) {
    if (!groupId) throw new BadRequestError(Message.ID_EMPTY);

    const group = await Group.findByPk(groupId);
    if (userId !== group.creatorId) throw new BadRequestError(Message.NOT_AllOWED);

    await group.destroy();
    await GroupUser.destroy({ where: { groupId } });

    deleteFile(group.coverPhoto);
    return {};
  }

  // Thêm thành viên vào nhóm
  static async addMember(userId, { memberIds }, groupId) {
    if (!groupId) throw new BadRequestError(Message.ID_EMPTY);

    for (const targetId of memberIds) {
      if (userId === targetId) throw new BadRequestError(Message.USER_IS_INVALID);
      // User đã tồn tại trong nhóm
      const existingMembership = await GroupUser.findOne({
        where: { userId: targetId, groupId }
      });

      if (existingMembership) throw new BadRequestError(Message.USER_IS_INVALID);
      await GroupUser.create({
        groupId,
        userId: targetId
      });
    }
  }

  // Xóa thành viên khỏi nhóm
  static async deleteMembers(userId, { memberIds }, groupId) {
    if (!groupId) throw new BadRequestError(Message.ID_EMPTY);
    const group = await Group.findByPk(groupId);
    if (userId !== group.creatorId) throw new BadRequestError(Message.USER_IS_INVALID);

    for (const targetId of memberIds) {
      await GroupUser.destroy({
        where: {
          groupId,
          userId: targetId
        }
      });
    }
    return {};
  }

  // Rời khỏi nhóm
  static async leaveGroup(userId, groupId) {
    if (!groupId) throw new BadRequestError(Message.ID_EMPTY);

    await GroupUser.destroy({
      where: {
        groupId,
        userId
      }
    });
  }

  // Lấy ra tất cả nhóm trên hệ thống
  static async getAllGroups({ limit, offset }) {
    const result = await Group.findAndCountAll({
      limit,
      offset
    });
    return result;
  }
}
