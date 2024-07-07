import { ScheduleService } from './video_schedule.service.js';

import { CatchAsyncError } from '#middlewares';
import { getPaginationAttributes, getPaginationSummary } from '#utils';

export class ScheduleController {
  static createSchedule = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const result = await ScheduleService.createSchedule(userId, req.body);
    res.created({
      message: 'Tạo mới một lịch chiếu thành công'
    });
  });

  static getListSchedule = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const result = await ScheduleService.getListSchedule({ userId, ...getPaginationAttributes(req.query) });
    res.ok(
      getPaginationSummary({
        ...req.query,
        result
      })
    );
  });

  static deleteSchedule = CatchAsyncError(async (req, res) => {
    const { id } = req.params;
    await ScheduleService.deleteScheduleTime(id);
    res.ok({ message: 'Xóa lịch thành công' });
  });
}
