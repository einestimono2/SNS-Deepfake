import { DeepfakeVideoService } from './deepfale_video.service.js';

import { CatchAsyncError } from '#middlewares';
import { getPaginationAttributes, getPaginationSummary } from '#utils';

export class DeepfakeVideoControllers {
  static createDeepfakeVideo = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const data = await DeepfakeVideoService.createDeepfakeVideo(userId, req.body);
    res.created({
      data
    });
  });

  static getListDeepfakeVideo = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const result = await DeepfakeVideoService.getListDeepfakeVideo(userId, ...getPaginationAttributes(req.query));
    res.ok(
      getPaginationSummary({
        ...req.query,
        result
      })
    );
  });

  static deleteDeepfakeVideo = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    await DeepfakeVideoService.deleteDeepfakeVideo(userId, req.body);
    res.ok({
      Message: 'Xóa thành công!'
    });
  });
}
