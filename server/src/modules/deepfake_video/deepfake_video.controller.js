import { DeepfakeVideoService } from './deepfake_video.service.js';

import { CatchAsyncError } from '#middlewares';
import { getPaginationAttributes, getPaginationSummary } from '#utils';

export class DeepfakeVideoControllers {
  static createDeepfakeVideo = CatchAsyncError(async (req, res) => {
    const data = await DeepfakeVideoService.createDeepfakeVideo(req.body);
    res.created({
      data
    });
  });

  static getListDeepfakeVideo = CatchAsyncError(async (req, res) => {
    const result = await DeepfakeVideoService.getListDeepfakeVideo({
      userId: req.userPayload.userId,
      ...getPaginationAttributes(req.query)
    });
    res.ok(
      getPaginationSummary({
        ...req.query,
        result
      })
    );
  });

  static deleteDeepfakeVideo = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const { videoId } = req.params;
    await DeepfakeVideoService.deleteDeepfakeVideo(userId, videoId);
    res.ok({
      message: 'Xóa videodeepfake thành công!'
    });
  });
}
