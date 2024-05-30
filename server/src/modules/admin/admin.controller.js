import { BadRequestError } from '../core/error.response.js';
import { User } from '../user/user.model.js';

import { adminService } from './admin.service.js';

import { Message } from '#constants';
import { CatchAsyncError } from '#middlewares';
import { signToken } from '#utils';

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

  static getOne = CatchAsyncError(async (req, res) => {
    const { id } = req.params;
    const model = adminService.getModel(req.params.modelName);
    const record = await adminService.getOne(model, id);
    res.json(record);
  });

  // static getMany = CatchAsyncError(async (req, res) => {

  // });

  static getList = CatchAsyncError(async (req, res) => {
    const model = adminService.getModel(req.params.modelName);

    const { limit, offset, filter, order } = adminService.parseQuery(req.query);
    const { rows, count } = await adminService.getList(model, limit, offset, filter, order);

    adminService.setGetListHeaders(res, offset, count, rows.length);
    res.json(rows);
  });

  // static getManyReference = CatchAsyncError(async (req, res) => {});
  static create = CatchAsyncError(async (req, res) => {
    const model = adminService.getModel(req.params.modelName);
    const record = await adminService.create(model, req.body);
    res.status(201).json(record);
  });

  static update = CatchAsyncError(async (req, res) => {
    const model = adminService.getModel(req.params.modelName);
    const { id } = req.params;
    const record = await adminService.getOne(model, id);

    if (!record) res.status(404).json({ error: 'Record not found' });

    const result = await adminService.update(model, id, req.body);
    res.json(result);
  });

  // static updateMany = CatchAsyncError(async (req, res) => {});
  static delete = CatchAsyncError(async (req, res) => {
    const model = adminService.getModel(req.params.modelName);
    const { id } = req.params;
    await adminService.delete(id);
    res.json({ id });
  });
  // static deleteMany = CatchAsyncError(async (req, res) => {});
}
