import { userServices } from './user.service.js';

import { CatchAsyncError } from '#middlewares';

export class UserControllers {
  // 1--Đăng ký
  static register = CatchAsyncError(async (req, res) => {
    const { phoneNumber, uuid, role, password, email } = req.body;
    await userServices.signup(phoneNumber, email, password, role, uuid);
    res.created({
      message: 'Mã code đã được gửi về mail của bạn'
    });
  });

  // 2--Đăng nhập
  static login = CatchAsyncError(async (req, res) => {
    const { email, password, uuid } = req.body;
    const user = await userServices.login(email, password, uuid);
    console.log(user);
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

    res.ok({ data });
  });

  // 4--Đăng xuất
  static logout = CatchAsyncError(async (req, res) => {
    await userServices.logout({ ...req.body });
    res.ok({ message: 'Đăng xuất thành công' });
  });

  // 5--Thay đổi thông tin sau khi đăng ký
  static changeProfileAfterSignup = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { username, avatar, coverImage } = req.body;
    const newProfile = await userServices.changeProfileAfterSignup(userId, username, avatar, coverImage);
    res.ok({ message: 'Profile updated!', data: newProfile });
  });

  static getUserInfo = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const userInfo = await userServices.getUserInfo(userId);
    res.ok({ data: userInfo });
  });

  static setUserInfo = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { username, avatar, coverImage } = req.body;
    const newProfile = await userServices.setUserInfo(userId, username, avatar, coverImage);
    console.log(newProfile);

    res.ok({ message: 'Profile updated!', data: newProfile });
  });

  static changePassword = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { newPassword } = req.body;
    const response = await userServices.changePassword(userId, newPassword);
    res.ok({ message: 'Password changed!', data: response });
  });
}
