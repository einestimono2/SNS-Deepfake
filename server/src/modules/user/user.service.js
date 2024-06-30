import bcryptjs from 'bcryptjs';

import { BlockServices } from '../block/block.service.js';
import { ConversationService } from '../chat/conversation/conversation.service.js';
import { BadRequestError, NotFoundError } from '../core/index.js';
import { FriendRequest } from '../friend/components/friend_request.model.js';
import { Friend } from '../friend/friend.model.js';
import { GroupService } from '../group/group/group.service.js';

import { DevToken } from './models/device_token.model.js';
import { PasswordHistory } from './models/password_history.model.js';
import { User } from './user.model.js';

import { AccountStatus, Message } from '#constants';
import { redis } from '#dbs';
// const catchAsyncError = require("../middleware/catchAsyncErrors");
import { SendMail, deleteFile, generateVerifyCode, setFileUsed, signToken } from '#utils';

export class userServices {
  static async myProfile(id) {
    const user = await User.findByPk(id);
    if (!user) {
      throw new NotFoundError(Message.USER_NOT_FOUND);
    }

    const groups = await GroupService.getMyGroups(user.id);

    return { user, groups };
  }

  // 1--Lấy mã xác thực
  static async getVerifyCode(email) {
    const user = await User.findOne({
      where: { email }
    });
    if (!user) {
      throw new BadRequestError(Message.USER_NOT_FOUND);
    }
    const code = generateVerifyCode(6);
    // Gửi mã code về mail
    //= = Lưu code ở redis
    await redis.set(`${user.id}_${code}`, code);
    await redis.expire(`${user.id}_${code}`, 120);
    await SendMail(email, code);
    return code;
  }

  static async checkEmaiExit(email) {
    const checkEmail = await User.findOne({ where: { email } });
    return checkEmail;
  }

  static async hashPassword(password) {
    const hashPassword = await bcryptjs.hash(password, 10);
    return hashPassword;
  }

  // 2--Tạo một tài khoản người dùng
  static async signup(phoneNumber, email, password, role, uuid) {
    // Kiểm tra email đã tồn tại chưa?
    if (await this.checkEmaiExit(email)) {
      throw new BadRequestError(Message.EMAIL_ALREADY_EXISTS);
    }
    // Kiểm tra sdt đã được đăng ký lần nào hay chưa?
    const exitPhoneNumber = await User.findOne({ where: { phoneNumber } });
    if (exitPhoneNumber) {
      throw new BadRequestError(Message.PHONE_NUMBER_IS_INVALID);
    }
    // Kiểm tra password có trùng email hay không?
    // if (password.indexOf(email) !== -1) {
    //   // Kiểm tra password có trùng email hay không?
    //   throw new BadRequestError(Message.USER_IS_INVALID);
    // }

    // Tạo tài khoản người dùng
    await User.create({
      password: await this.hashPassword(password),
      email,
      role,
      uuid,
      status: AccountStatus.Inactive,
      deletedAt: new Date(),
      coins: 100
    });

    // Thực hiện gửi mã xác thực về Email
    await this.getVerifyCode(email);
  }

  static async comparePassword(password, hashedPassword) {
    const comparePassword = bcryptjs.compare(password, hashedPassword);
    return comparePassword;
  }

  // 3-- Đăng nhập tài khoản
  static async login({ email, password, uuid, fcmToken }) {
    const user = await User.findOne({
      where: { email },
      // attributes: { exclude: ['password'] },
      withDeleted: true
    });
    if (!user) throw new NotFoundError(Message.EMAIL_NOT_EXISTS);

    if (!(await this.comparePassword(password, user.password)) || !user.status === AccountStatus.Active) {
      throw new BadRequestError(Message.WRONG_PASSWORD);
    }

    // if (!user.status === AccountStatus.Active) {
    //   throw new BadRequestError(Message.ACCOUNT_NOT_ACTIVATED);
    // }

    const [deviceToken, created] = await DevToken.findOrCreate({
      where: { userId: user.id },
      defaults: { userId: user.id, token: fcmToken }
    });

    if (!created) {
      await deviceToken.update({ token: fcmToken });
    }

    const token = signToken(user.id, uuid);
    user.token = token;

    await user.save();

    let groups = [];
    if (user.status === AccountStatus.Active) {
      groups = await GroupService.getMyGroups(user.id);
    }

    return {
      user,
      accessToken: token,
      groups
    };
  }

  static async verifyCode(email, code) {
    const user = await User.findOne({
      where: {
        email
      }
    });
    if (!user) {
      throw new NotFoundError(Message.USER_NOT_FOUND);
    }
    if (!redis.exists(`${user.id}_${code}`)) {
      throw new BadRequestError(Message.CODE_NOT_FOUND);
    }
    if (redis.ttl(`${user.id}_${code}`) < 0) {
      throw new BadRequestError(Message.CODE_IS_INVALID);
    }

    return user;
  }

  // 4--- Kiểm tra mã xác thực
  static async checkVerifyCode(code, email) {
    const user = await this.verifyCode(email, code);

    // Kiểm tra nếu role là bố mẹ thì tạo dữ liệu cho Bảng Family
    // if (user.role === Roles.Parent) {
    //   const family = await Group.create();
    //   user.family_id = family.id;
    //   await user.save();
    // }
    // Pending là trạng thái tk cần thêm avatar
    if (user.status === AccountStatus.Inactive) {
      user.status = user.username ? AccountStatus.Active : AccountStatus.Pending;
      await user.save();
    }

    return {
      id: user.id,
      status: user.status
    };
  }

  // 5--Đăng xuất tài khoản
  static async logout(user) {
    user.token = null;
    await user.save();
    await DevToken.destroy({ where: { userId: user.id } });
    return {};
  }

  // Profile
  // 6--Thay đổi thông tin sau khi đăng ký
  static async changeProfileAfterSignup({ email, username, avatar, coverImage, phoneNumber }) {
    const user = await User.findOne({ where: { email } });

    if (!user) {
      throw new NotFoundError(Message.USER_NOT_FOUND);
    }

    if (![AccountStatus.Pending, AccountStatus.Active].includes(user.status)) {
      throw new BadRequestError(Message.NO_CHANGE_PROFILE_AFTER_SIGNUP);
    }

    let _avatar = null;
    if (avatar) {
      _avatar = setFileUsed(avatar);
    }

    let _coverImage = null;
    if (coverImage) {
      _coverImage = setFileUsed(coverImage);
    }

    user.username = username;
    user.avatar = _avatar;
    user.coverImage = _coverImage;
    user.phoneNumber = phoneNumber;
    user.status = AccountStatus.Active;
    user.deletedAt = null;

    await user.save();

    // Xử lý việc pushsetting

    const groups = await GroupService.getMyGroups(user.id);

    return {
      user,
      groups
    };
  }

  // 7--Lấy thông tin người dùng
  static async getUserInfo(userId, user_id) {
    // Gán giá trị nếu user_id là null or undefined
    user_id ||= userId;
    let blockStatus = 0; // Normal

    // Mình block target
    if (await BlockServices.isBlock(userId, user_id)) {
      blockStatus = 1;
    }
    // Target block mình
    if (await BlockServices.isBlock(user_id, userId)) {
      blockStatus = 2;
    }

    // Kiểm tra userId có trong bảng User hay không
    const userInfo = await User.findOne({ where: { id: userId } });
    const _user = await User.findOne({ where: { id: user_id } });
    if (!userInfo || !_user) {
      throw new BadRequestError(Message.USER_NOT_FOUND);
    }

    // Trường hợp người ta block mình thì chỉ cần thông tin cơ bản
    if (blockStatus === 2) {
      return {
        id: _user.id,
        username: _user.username,
        email: _user.email,
        avatar: _user.avatar,
        phoneNumber: _user.phoneNumber,
        coverImage: _user.coverImage,
        createdAt: _user.createdAt,
        totalFriends: -1
      };
    }

    // Lấy số lượng bạn bè....
    const [totalFriends, friend, friendRequested, friendRequesting] = await Promise.all([
      Friend.count({ where: { userId: user_id || userId } }),
      Friend.findOne({ where: { userId, targetId: user_id } }), // Có là bạn bè hay k
      FriendRequest.findOne({ where: { userId, targetId: user_id } }), // Có gửi yêu cầu kết bạn tới target chưa
      FriendRequest.findOne({ where: { userId: user_id, targetId: userId } }) // Target có yêu cầu kết bạn tới mình k
    ]);

    let conversationId = -1;
    if (user_id !== userId) {
      conversationId = (await ConversationService.getSingleConversationByMembers({ userId, targetId: user_id })).id;
    }

    return {
      id: _user.id,
      username: _user.username,
      email: _user.email,
      avatar: _user.avatar,
      phoneNumber: _user.phoneNumber,
      coverImage: _user.coverImage,
      createdAt: _user.createdAt,
      totalFriends,
      // online: '1',
      // coins: _user.coins,
      friendStatus: this.mapFriendStatus(friend, friendRequested, friendRequesting),
      blockStatus,
      conversationId
    };
  }

  static mapFriendStatus = (friend, friendRequested, friendRequesting) => {
    if (friend) return 2;
    if (friendRequested) return 1;
    if (friendRequesting) return 3;
    return 0;
  };

  static async setUserInfo({ userId, username, avatar, coverImage, phoneNumber }) {
    const userInfo = await User.findOne({ where: { id: userId } });
    // if (!userInfo) {
    //   throw new BadRequestError(Message.USER_NOT_FOUND);
    // }

    userInfo.username = username || userInfo.username;
    if (avatar) {
      const _oldUrl = userInfo.avatar;
      userInfo.avatar = setFileUsed(avatar);
      deleteFile(_oldUrl);
    }
    userInfo.phoneNumber = phoneNumber || userInfo.phoneNumber;
    if (coverImage) {
      const _oldUrl = userInfo.coverImage;
      userInfo.coverImage = setFileUsed(coverImage);
      deleteFile(_oldUrl);
    }
    await userInfo.save();
    // if (body.username) user.username = body.username;
    // if (body.phonenumber) user.description = body.phonenumber;
    // if (body.address) Family.address = body.address;
    // if (body.name) Family.name = body.name;
    // if (avatar) {
    //   user.avatar = 'Đã thay đổi avatar';
    // }
    // if (coverImage) {
    //   user.coverImage = 'Đã thay đổi coverImage';
    // }
    // await this.User.save(user);
    // await this.Family.save();

    return userInfo;
  }

  static async checkOldPassword(user, password) {
    if (await this.comparePassword(password, user.password)) {
      throw new BadRequestError(Message.USED_PASSWORD);
    }
    const oldPasswords = await PasswordHistory.findAll({ where: { userId: user.id } });
    for (const oldPassword of oldPasswords) {
      if (await this.comparePassword(password, oldPassword.password)) {
        throw new BadRequestError(Message.USED_PASSWORD);
      }
    }
  }

  static async changePassword(userId, oldPassword, newPassword) {
    const user = await User.findByPk(userId);
    // if (await this.comparePassword(oldPassword, user.password)) throw new BadRequestError(Message.WRONG_PASSWORD);

    await this.checkOldPassword(user, newPassword);
    user.password = await this.hashPassword(newPassword);
    // user.token = signToken(user.id, generateVerifyCode(6));
    await user.save();

    await PasswordHistory.create({
      userId: user.id,
      password: oldPassword
    });

    console.log(user.token);
    return {
      token: user.token
    };
  }
}
