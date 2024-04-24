import { BadRequestError } from '../core/error.response.js';
import { User } from '../user/user.model.js';

import { AdminServices } from './admin.service.js';

import { Message } from '#constants';
import { CatchAsyncError } from '#middlewares';
import { getPaginationAttributes, getPaginationSummary, signToken } from '#utils';

export class AdminControllers {
  // 2--Đăng nhập
  static async login(req, res) {
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
  }

  static getAllPosts = CatchAsyncError(async (req, res) => {
    const data = await AdminServices.getAllPosts(...getPaginationAttributes(req.query));
    res.ok(
      getPaginationSummary({
        ...req.query,
        data
      })
    );
  });

  static ratePost = CatchAsyncError(async (req, res) => {
    await AdminServices.ratePost(req.body);
    res.ok({
      Message: ' Đánh giá thành công'
    });
  });

  static getAllUser = CatchAsyncError(async (req, res) => {
    const data = await AdminServices.getAllUser(...getPaginationAttributes(req.query));
    res.ok(
      getPaginationSummary({
        ...req.query,
        data
      })
    );
  });

  static getAllGroup = CatchAsyncError(async (req, res) => {
    const data = await AdminServices.getAllGroup(...getPaginationAttributes(req.query));
    res.ok(
      getPaginationSummary({
        ...req.query,
        data
      })
    );
  });

  static getAllPost = CatchAsyncError(async (req, res) => {
    const data = await AdminServices.getAllPosts(req.body);
    res.ok({
      data
    });
  });
}
