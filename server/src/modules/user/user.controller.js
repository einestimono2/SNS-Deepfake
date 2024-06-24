import { User } from './user.model.js';
import { userServices } from './user.service.js';

import { CatchAsyncError } from '#middlewares';

export class UserControllers {
  // 0-- Kiểm tra hạn
  static verifyToken = CatchAsyncError(async (req, res) => {
    const me = await userServices.myProfile(req.userPayload.userId);
    res.ok({
      data: me
    });
  });

  // 1--Đăng ký
  static register = CatchAsyncError(async (req, res) => {
    const { uuid, role, password, email } = req.body;
    await userServices.signup(email, password, role, uuid);
    res.created({
      message: 'Mã code đã được gửi về mail của bạn'
    });
  });

  // 2--Đăng nhập
  static login = CatchAsyncError(async (req, res) => {
    const user = await userServices.login(req.body);

    res.ok({ message: 'Đăng nhập thành công', data: user });
  });

  // 3--Lấy mã xác thực
  static getVerifyCode = CatchAsyncError(async (req, res) => {
    const { email } = req.body;
    const verifyCode = await userServices.getVerifyCode(email);
    res.ok({ message: 'Lấy mã thành công', data: verifyCode });
    console.log(res.data);
  });

  // 4--Kiểm tra mã xác thực
  static checkVerifyCode = CatchAsyncError(async (req, res) => {
    const { code, email } = req.body;
    const data = await userServices.checkVerifyCode(code, email);
    res.ok({ message: 'Mã hợp lệ', data });
  });

  // 4--Đăng xuất
  static logout = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const user = await User.findOne({ where: { id: userId } });
    await userServices.logout(user);
    res.ok({ message: 'Đăng xuất thành công' });
  });

  // 5--Thay đổi thông tin sau khi đăng ký
  static changeProfileAfterSignup = CatchAsyncError(async (req, res) => {
    const newProfile = await userServices.changeProfileAfterSignup(req.body);

    res.created({ message: 'Profile updated!', data: newProfile });
  });

  static getUserInfo = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const userInfo = await userServices.getUserInfo(userId, req.params.userId);
    res.ok({ data: userInfo });
  });

  static setUserInfo = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const newProfile = await userServices.setUserInfo({ userId, ...req.body });

    res.ok({ message: 'Profile updated!', data: newProfile });
  });

  static changePassword = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { newPassword, oldPassword } = req.body;
    const response = await userServices.changePassword(userId, oldPassword, newPassword);
    res.ok({ message: 'Password changed!', data: response });
  });
}
