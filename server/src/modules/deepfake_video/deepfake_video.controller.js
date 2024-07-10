import { DeepfakeVideoService } from './deepfake_video.service.js';

import { CatchAsyncError } from '#middlewares';
import { getPaginationAttributes, getPaginationSummary } from '#utils';

export class DeepfakeVideoControllers {
  static createDeepfakeVideo = CatchAsyncError(async (req, res) => {
    const data = await DeepfakeVideoService.createDeepfakeVideo({ ...req.body, userId: req.userPayload.userId });
    res.created({
      data
    });
  });

  static finishDeepfakeVideo = CatchAsyncError(async (req, res) => {
    await DeepfakeVideoService.finishDeepfakeVideo({ ...req.body, videoName: req.file.filename });

    res.ok();
  });

  static getListDeepfakeVideo = CatchAsyncError(async (req, res) => {
    const result = await DeepfakeVideoService.getListDeepfakeVideo({
      userId: req.userPayload.userId,
      ...getPaginationAttributes(req.query),
      type: req.query.type
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
    const { id } = req.params;

    await DeepfakeVideoService.deleteDeepfakeVideo(userId, id);

    res.ok({
      message: 'Xóa videodeepfake thành công!'
    });
  });
}
