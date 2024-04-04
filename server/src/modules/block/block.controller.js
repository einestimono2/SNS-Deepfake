import { BlockServices } from './block.service.js';

import { CatchAsyncError } from '#middlewares';
// 1--Đăng ký
export class BlockControllers {
  static getListBlocks = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const listBlocks = await BlockServices.getListBlocks(userId, req.body);
    res.ok({
      data: listBlocks
    });
  });

  static setBlock = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { targetId } = req.params;
    const block = await BlockServices.setBlock(userId, targetId);
    res.ok({
      data: block
    });
  });

  static unBlock = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { targetId } = req.params;
    await BlockServices.unBlock(userId, targetId);
    res.ok({
      message: 'Đã un block thành công'
    });
  });
}
