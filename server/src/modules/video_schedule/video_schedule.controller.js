import { ScheduleService } from './video_schedule.service.js';

import { CatchAsyncError } from '#middlewares';
import { getPaginationAttributes, getPaginationSummary } from '#utils';

export class ScheduleController {
  static createSchedule = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const schedule = await ScheduleService.createSchedule(userId, req.body);
    res.created({
      data: schedule
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
}
