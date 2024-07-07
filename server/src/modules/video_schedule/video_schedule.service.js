import cron from 'node-cron';

import { UnauthorizedError } from '../core/error.response.js';
// import { PostVideo } from '../post/models/post_video.model.js';
import { DeepfakeVideo } from '../deepfake_video/deepfake_video.model.js';
import { User } from '../user/user.model.js';

import { VideoSchedule } from './video_schedule.model.js';

import { Message } from '#constants';

const jobs = new Map();
export class ScheduleService {
  // Tạo lịch phát video
  static async createSchedule(userId, body) {
    // const { videoId, targetId, time, frequency } = { ...body };
    // if (!userId) throw new UnauthorizedError(Message.USER_IS_INVALID);
    // // // Danh sách các thành viên
    // // const newSchedule = await VideoSchedule.create({
    // //   videoId,
    // //   userId: targetId,
    // //   targetId: userId,
    // //   time,
    // //   frequency
    // // });
    // const schedule = {
    //   id: '4',
    //   name: 'Nam',
    //   time: '0 2 * * * *'
    // };
    // // const second = time.getSeconds();
    // // const minute = time.getMinutes();
    // // const hour = time.getHours();
    // // const day = time.getDate();
    // // const month = time.getMonth() + 1;
    // // const year = time.getFullYear();

    // const job = cron.schedule(
    //   schedule.time,
    //   () => {
    //     // Thực hiện gửi noti
    //     // await NotificationServices.createNotification({
    //     //   type: newSchedule ? NotificationType.VideoAdded : NotificationType.PostAdded,
    //     //   userId,
    //     //   targetId,
    //     //   videoId
    //     // });
    //     console.log(schedule);
    //   },
    //   {
    //     scheduled: true,
    //     timezone: 'Asia/Ho_Chi_Minh'
    //   }
    // );
    // job.start();
    // jobs.set(schedule.id, job);
    // console.log(jobs);
    // return schedule;

    const { receiverId, videoId, time } = { ...body };

    // Create new schedule
    const newSchedule = await VideoSchedule.create({
      targetId: userId,
      userId: receiverId,
      videoId,
      time: new Date(time)
    });

    const schedule = await VideoSchedule.findOne({
      where: { id: newSchedule.id },
      include: [
        { model: User, as: 'sender' },
        { model: User, as: 'receiver' },
        { model: DeepfakeVideo, as: 'video' }
      ]
    });

    // Add new schedule to the cron jobs
    await this.addSchedule(schedule.toJSON());
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

  static async getScheduleById(req) {
    const { id } = req.params;
    // Danh sách các thành viên
    let schedule = await VideoSchedule.findAll({
      where: { id },
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
        }
      ]
    });
    console.log(schedule.toJSON);
    schedule = schedule.toJSON;
    return {
      scheduler: {
        id: String(schedule.id),
        sender: {
          id: String(schedule.sender.id),
          name: schedule.sender.username || '',
          avatar: schedule.sender.avatar
        },
        receiver: {
          id: String(schedule.receiver.id),
          name: schedule.receiver.username || '',
          avatar: schedule.receiver.avatar
        },
        video: {
          id: String(schedule.video.id),
          url: schedule.video.url || ''
        },
        startTime: schedule.startTime,
        endTime: schedule.endTime,
        status: schedule.status || ''
      }
    };
  }

  static async updateScheduleTime(req, body) {
    const { id } = req.params;
    const { startTime, endTime } = { ...body };
    // Danh sách các thành viên
    let schedule = await VideoSchedule.findAll({
      where: { id },
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
        }
      ]
    });
    console.log(schedule.toJSON);
    schedule = schedule.toJSON;
  }

  static async deleteScheduleTime(id) {
    // Danh sách các thành viên
    // const schedule = await VideoSchedule.findByPk(id);

    // await VideoSchedule.destroy({ where: { id } });
    // Cancel the cron job
    const job = jobs.get(id);
    if (job) {
      job.stop();
      jobs.delete(id);
      console.log(jobs);
    }
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
    const schedules = schedulesTotal.map((schedule) => schedule.toJSON());

    // Duyệt qua từng schedules và lập lịch phát video
    schedules.forEach((schedule) => {
      this.addSchedule(schedule);
    });
  }

  static async addSchedule(schedule) {
    const second = new Date(schedule.time).getSeconds();
    const minute = new Date(schedule.time).getMinutes();
    const hour = new Date(schedule.time).getHours();
    const day = new Date(schedule.time).getDate();
    const month = new Date(schedule.time).getMonth() + 1;

    console.log(second);
    console.log(minute);
    console.log(hour);
    const cronExpression = `${second} ${minute} ${hour} ${day} ${month} `;
    const job = cron.schedule(
      cronExpression,
      async () => {
        // Thực hiện logic để gửi notification
        // await NotificationServices.notifyPlayVideo(schedule.receiver, schedule.sender, schedule.video.id);
        console.log(schedule);
        job.stop();
        jobs.delete(schedule.id);
      },
      {
        scheduled: true,
        timezone: 'Asia/Ho_Chi_Minh'
      }
    );
    jobs.set(schedule.id, job);
    console.log(jobs);
  }
}
