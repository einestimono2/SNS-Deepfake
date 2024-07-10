import schedule from 'node-schedule';

import { UnauthorizedError } from '../core/error.response.js';
// import { PostVideo } from '../post/models/post_video.model.js';
import { DeepfakeVideo } from '../deepfake_video/deepfake_video.model.js';
import { User } from '../user/user.model.js';

import { VideoSchedule } from './video_schedule.model.js';

import { NotificationServices } from '##/modules/notification/notification.service';
import { Message } from '#constants';

const jobs = new Map();

export class ScheduleService {
  // Tạo lịch phát video
  static async createSchedule(userId, body) {
    const { receiverId, videoId, time, repeat } = { ...body };

    // Create new schedule
    const newSchedule = await VideoSchedule.create({
      targetId: userId,
      userId: receiverId,
      videoId,
      time: new Date(time),
      repeat
    });

    const _schedule = await VideoSchedule.findOne({
      where: { id: newSchedule.id },
      include: [
        { model: User, as: 'sender' },
        { model: User, as: 'receiver' },
        { model: DeepfakeVideo, as: 'video' }
      ]
    });

    // Add new schedule to the cron jobs
    await this.addSchedule(_schedule.toJSON());
  }

  // Lấy danh sách lịch phát video của một user
  static async getListSchedule({ userId, limit, offset }) {
    if (!userId) throw new UnauthorizedError(Message.USER_IS_INVALID);
    // Danh sách các thành viên
    const listSchedule = await VideoSchedule.findAndCountAll({
      where: { targetId: userId },
      include: [
        // Thông tin người gửi
        {
          model: User,
          as: 'sender'
        },
        // Thông tin người nhận
        {
          model: User,
          as: 'receiver'
        },
        {
          model: DeepfakeVideo,
          as: 'video'
        }
      ],
      order: [['id', 'DESC']],
      offset,
      limit
    });
    console.log(listSchedule.rows[0].video);
    return {
      rows: listSchedule.rows.map((scheduler) => ({
        id: String(scheduler.id),
        user: {
          id: String(scheduler.sender.id),
          name: scheduler.sender.username || '',
          avatar: scheduler.sender.avatar
        },
        target: {
          id: String(scheduler.receiver.id),
          name: scheduler.receiver.username || '',
          avatar: scheduler.receiver.avatar
        },
        video: {
          id: String(scheduler.video.id),
          url: scheduler.video.url || ''
        },
        time: scheduler.time
      })),
      count: listSchedule.count
    };
  }

  static async deleteScheduleTime(userId, videoId) {
    const _schedule = await VideoSchedule.findOne({ where: { targetId: userId, videoId } });

    await VideoSchedule.destroy({ where: { id: schedule.id } });
    // Cancel the cron job
    schedule.scheduledJobs[_schedule.id.toString()].cancel();
  }

  // Thực hiện việc hẹn phát video
  static async ScheduleTime() {
    // Lấy tất cả các lịch chiếu trong csdl
    const schedulesTotal = await VideoSchedule.findAll({
      include: [
        { model: User, as: 'sender' },
        { model: User, as: 'receiver' },
        { model: DeepfakeVideo, as: 'video' }
      ]
    });
    const schedules = schedulesTotal.map((_schedule) => schedule.toJSON());

    // Duyệt qua từng schedules và lập lịch phát video
    schedules.forEach((_schedule) => {
      this.addSchedule(schedule);
    });
  }

  static async addSchedule(_schedule) {
    const minute = new Date(_schedule.time).getMinutes();
    const hour = new Date(_schedule.time).getHours();
    const day = new Date(_schedule.time).getDate();
    const month = new Date(_schedule.time).getMonth() + 1;

    // const cronExpression = `${second} ${minute} ${hour} ${day} ${month} * `;
    let cronExpression;
    if (_schedule.repeat === 0) cronExpression = `0 ${minute} ${hour} ${day} ${month} * `;
    else cronExpression = `0 ${minute} ${hour} * * * `;

    const job = schedule.scheduleJob(_schedule.id.toString(), cronExpression, async function () {
      // TODO:" NOtification"
      await NotificationServices.notifyPlayVideo(_schedule.targetId, _schedule.userId, _schedule.videoId);
      console.log(_schedule.id);

      if (_schedule.repeat === 0) job.cancel();
    });

    // schedule.scheduledJobs[_schedule.id.toString()].cancel();
    // schedule.scheduledJobs.get(id)

    // console.log(job.);
  }
}
