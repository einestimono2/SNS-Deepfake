import bcryptjs from 'bcryptjs';
import dayjs from 'dayjs';
import { Op } from 'sequelize';

// import { BadRequestError, Family } from '#modules';
import { BadRequestError } from '../core/index.js';
import { Family } from '../family/family.model.js';

import { DevToken } from './dev_token/index.js';
import { VerifyCode } from './verify_code/index.js';

import { User } from './index.js';

import { accountStatus, Message } from '#constants';
// const catchAsyncError = require("../middleware/catchAsyncErrors");
import { generateVerifyCode, signToken } from '#utils';

export class userServices {
  // 1--Lấy mã xác thực
  static async getVerifyCode(email) {
    const user = await User.findOne({
      where: { email }
    });
    if (!user) {
      throw new BadRequestError(Message.USER_NOT_FOUND);
    }
    const code = generateVerifyCode(6);
    // Thêm dữ liệu vào bảng VerifyCode
    const verifyCode = await VerifyCode.create({
      userID: user.id,
      code,
      expiredAt: dayjs().add(30, 'minutes').toDate()
    });
    verifyCode.status = accountStatus.Inactive;
    await verifyCode.save();
    // Gửi mã code về mail
    // await sendMail(email, code);
    return verifyCode;
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
  static async signup(email, password) {
    // Kiểm tra email đã tồn tại chưa?
    if (await this.checkEmaiExit(email)) {
      throw new BadRequestError(Message.EMAIL_ALREADY_EXISTS);
    }
    // Kiểm tra password có trùng email hay không?
    if (password.indexOf(email) !== -1) {
      throw new BadRequestError(Message.USER_IS_INVALID);
    }
    // Tạo tài khoản người dùng
    await User.create({
      password: await this.hashPassword(password),
      email,
      status: accountStatus.Inactive,
      coins: 50
    });
    // Thực hiện gửi mã xác thực về Email
    await this.getVerifyCode(email);
  }

  static async comparePassword(user, password) {
    const comparePassword = bcryptjs.compare(password, user.password);
    return comparePassword;
  }

  // 3-- Đăng nhập tài khoản
  static async login(email, password, uuid) {
    const user = await User.findOne({
      where: { email },
      withDeleted: true
    });
    if (!user || !(await this.comparePassword(user, password))) {
      throw new BadRequestError(Message.USER_NOT_FOUND);
    }
    user.token = signToken(user.id, uuid);
    await user.save();
    return {
      user
    };
  }

  static async verifyCode(email, code) {
    const user = await User.findOne({
      where: {
        email
      }
    });
    // Kiểm tra mã code với thời gian hết hạn phải sau thời gian hiện tại
    const verifyCode = await VerifyCode.findOne({
      where: {
        status: accountStatus.Inactive,
        userID: user.id,
        code,
        expiredAt: { [Op.gt]: dayjs() }
      }
    });
    // console.log(verifyCode);
    if (!verifyCode) {
      throw new BadRequestError(Message.CODE_NOT_FOUND);
    }
    verifyCode.status = accountStatus.Inactive;
    await verifyCode.save();
    return verifyCode;
  }

  // 4--- Kiểm tra mã xác thực
  static async checkVerifyCode(code, email) {
    const verifyCode = await this.verifyCode(email, code);
    const user = await User.findOne({
      where: {
        id: verifyCode.userID
      }
    });
    // Kiểm tra nếu role là bố mẹ thì tạo dữ liệu cho Bảng Family
    if (user.role === 'parent') {
      const family = await Family.create();
      user.family_id = family.id;
      await user.save();
    }
    if (user.status === accountStatus.Inactive) {
      user.status = user.username ? accountStatus.Inactive : accountStatus.Pending;
      await user.save();
    }
    return {
      id: user.id,
      active: user.status
    };
  }

  // 5--Đăng xuất tài khoản
  static async logout(user) {
    user.token = null;
    await user.save();
    await DevToken.destroy({ userId: user.id });
    // Xóa 1 bản ghi ở Dev Token
    // await Device.destroy({ id: user.id });
    // res.status(200).json({ error: 'Đăng xuất thành công' });
    return {};
  }

  // Profile
  // 6--Thay đổi thông tin sau khi đăng ký
  //   static async changeProfileAfterSignup(user, username, avatar) {
  //     if (!['pending', 'active'].includes(user.status)) {
  //       throw new BadRequestError(Message.NO_CHANGE_PROFILE_AFTER_SIGNUP);
  //     }
  //     user.username = username;
  //     if (avatar) {
  //       user.avatar = 'Đã thay đổi avatar';
  //     }
  //     user.status = 'active';
  //     await User.save(user);
  //     // Xử lý việc pushsetting
  //     return {
  //       id: user.id,
  //       username: user.username,
  //       email: user.email,
  //       avatar: user.avatar
  //     };
  //   }

  //   // 7--Lấy thông tin người dùng
  //   static async getUserInfo(user, userId) {
  //     userId ||= user.id;
  //     // Kiểm tra User có bị block hay không
  //     // Kiểm tra userId có trong bảng User hay không
  //     const userInfo = await User.findOne({
  //       where: {
  //         id: userId
  //       }
  //     });
  //     const FamilyInfo = await Family.findOne({
  //       where: {
  //         id: userInfo.family_id
  //       }
  //     });
  //     if (!user) {
  //       throw new BadRequestError(Message.USER_NOT_FOUND);
  //     }
  //     // Lấy số lượng bạn bè....
  //     return {
  //       id: user.id,
  //       username: user.username,
  //       avatar: user.avatar,
  //       coverImage: user.coverImage,
  //       adress: FamilyInfo.address,
  //       name: FamilyInfo.name,
  //       // Danh sách bạn bè
  //       online: '1',
  //       coins: user.coins
  //     };
  //   }

  //   static async setUserInfo(user, body, avatar, coverImage) {
  //     const userInfo = await User.findOne({
  //       where: {
  //         id: user.id
  //       }
  //     });
  //     if (!userInfo) {
  //       throw new BadRequestError(Message.USER_NOT_FOUND);
  //     }
  //     if (body.username) user.username = body.username;
  //     if (body.phonenumber) user.description = body.phonenumber;
  //     if (body.address) Family.address = body.address;
  //     if (body.name) Family.name = body.name;
  //     if (avatar) {
  //       user.avatar = 'Đã thay đổi avatar';
  //     }
  //     if (coverImage) {
  //       user.coverImage = 'Đã thay đổi coverImage';
  //     }
  //     await this.User.save(user);
  //     await this.Family.save();
  //     return {
  //       avatar: user.avatar,
  //       coverimage: user.coverImage,
  //       address: Family.address,
  //       name: Family.name,
  //       phoneNumber: user.phoneNumber
  //     };
  //   }
  //
}
