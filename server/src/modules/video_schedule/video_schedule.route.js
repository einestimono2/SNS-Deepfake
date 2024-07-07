import { Router } from 'express';

import { ScheduleController } from './video_schedule.controller.js';

import { isAuthenticated } from '#middlewares';

const router = Router();

// - [POST] Create a schedule
router.post('/create_schedule', isAuthenticated, ScheduleController.createSchedule);

// - [GET] List schedules
router.get('/get_list_schedule', isAuthenticated, ScheduleController.getListSchedule);

// // - [GET] Details a schedule
// router.get('/detail_schedule', isAuthenticated, GroupController.getGroupDetail);

// // - [UPDATE] Update schedule
// router.put('/update_group/:groupId', isAuthenticated, GroupController.updateGroup);

// // - [DELETE] Delete schedule
router.delete('/delete_schedule/:id', ScheduleController.deleteSchedule);

export const videoScheduleRouter = router;
