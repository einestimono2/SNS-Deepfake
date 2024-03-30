import { User } from '../user/user.model.js';

import { Message } from '#constants';
import { CatchAsyncError } from '#middlewares';
import { BadRequestError } from '#modules';
import { signToken } from '#utils';

export class AdminControllers {
  // 2--Đăng nhập
  static login = CatchAsyncError(async (req, res) => {
    const { username, password } = req.body;
    if (!username && !password) {
      throw new BadRequestError(Message.USER_IS_INVALID);
    }
    const admin = await User.findOne({
      where: {
        username,
        password
      }
    });

    if (!admin) {
      throw new BadRequestError(Message.USER_NOT_FOUND);
    }
    const token = signToken(username, password);
    console.log(token);
    res.ok({ message: 'Đăng nhập với admin thành công', data: token });
  });
}
