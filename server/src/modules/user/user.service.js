import bcryptjs from 'bcryptjs';
import jwt from 'jsonwebtoken';

import { BlockServices } from '../block/block.service.js';
import { BadRequestError, NotFoundError } from '../core/index.js';
import { FriendRequest } from '../friend/components/friend_request.model.js';
import { Friend } from '../friend/friend.model.js';
// import { Group } from '../group/group/group.model.js';

import { DevToken } from './models/device_token.model.js';
import { PasswordHistory } from './models/password_history.model.js';
import { User } from './user.model.js';

import { AccountStatus, Message } from '#constants';
import { redis } from '#dbs';
// const catchAsyncError = require("../middleware/catchAsyncErrors");
import { generateVerifyCode, SendMail, setFileUsed, signToken } from '#utils';

export class userServices {
  static async myProfile(id) {
    const user = await User.findByPk(id);
    if (!user) {
      throw new NotFoundError(Message.USER_NOT_FOUND);
    }

    return user;
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
    if (password.indexOf(email) !== -1) {
      // Kiểm tra password có trùng email hay không?
      throw new BadRequestError(Message.USER_IS_INVALID);
    }

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
  static async login(email, password, uuid) {
    const user = await User.findOne({
      where: { email },
      // attributes: { exclude: ['password'] },
      withDeleted: true
    });
    if (!user) throw new NotFoundError(Message.EMAIL_NOT_EXISTS);

    if (!(await this.comparePassword(password, user.password)) || !user.status === AccountStatus.Active) {
      throw new BadRequestError(Message.WRONG_PASSWORD);
    }
    // TODO: Có thể lỗi logic về dấu !
    if (!user.status === AccountStatus.Active) {
      throw new BadRequestError(Message.ACCOUNT_NOT_ACTIVATED);
    }

    const [deviceToken] = await DevToken.findOrCreate({
      where: { userId: user.id },
      defaults: { userId: user.id }
    });

    const token = signToken(user.id, uuid);
    user.token = token;
    deviceToken.token = token;

    await user.save();
    return {
      user,
      accessToken: token
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

    return user;
  }

  // 7--Lấy thông tin người dùng
  static async getUserInfo(userId, user_id) {
    if (await BlockServices.isBlock(userId, user_id)) {
      throw new BadRequestError(Message.CAN_NOT_BLOCK);
    }

    // Kiểm tra userId có trong bảng User hay không
    const userInfo = await User.findOne({ where: { id: userId } });
    if (!userInfo) {
      throw new BadRequestError(Message.USER_NOT_FOUND);
    }

    // Lấy số lượng bạn bè....
    const [totalFriends, friend, friendRequested, friendRequesting] = await Promise.all([
      Friend.count({ userId }),
      Friend.findOne({ userId, targetId: user_id }),
      FriendRequest.findOne({ userId, targetId: user_id }),
      FriendRequest.findOne({ userId: user_id, targetId: userId })
    ]);

    return {
      id: userInfo.id,
      role: userInfo.role,
      username: userInfo.username,
      avatar: userInfo.avatar,
      phoneNumber: userInfo.phoneNumber,
      coverImage: userInfo.coverImage,
      // adress: FamilyInfo.address,
      // name: FamilyInfo.name,
      // Danh sách bạn bè
      listing: String(totalFriends),
      // is_friend: getIsFriend(friend, friendRequested, friendRequesting),
      online: '1',
      coins: userInfo.coins
    };
  }

  static async setUserInfo(userId, username, avatar, coverImage) {
    const userInfo = await User.findOne({ where: { id: userId } });
    // if (!userInfo) {
    //   throw new BadRequestError(Message.USER_NOT_FOUND);
    // }

    userInfo.username = username || userInfo.username;
    userInfo.avatar = avatar || userInfo.avatar;
    // userInfo.phoneNumber = phoneNumber || userInfo.phoneNumber;
    userInfo.coverImage = coverImage || userInfo.coverImage;
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

    return {
      id: userId,
      username,
      // phoneNumber,I
      avatar,
      coverImage
    };
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

  static async changePassword(userId, newPassword) {
    const user = await User.findOne({ where: { userId } });

    await this.checkOldPassword(user, newPassword);

    const oldPassword = user.password;
    user.password = await this.hashPassword(newPassword);
    user.token = signToken(user.id, generateVerifyCode(6));
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
