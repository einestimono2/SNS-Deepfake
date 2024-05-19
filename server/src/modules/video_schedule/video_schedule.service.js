import cron from 'node-cron';
import sequelize from 'sequelize';

import { UnauthorizedError } from '../core/error.response.js';
import { PostVideo } from '../post/models/post_video.model.js';
import { User } from '../user/user.model.js';

import { VideoSchedule } from './video_schedule.model.js';

import { Message } from '#constants';

export class ScheduleService {
  // Tạo lịch phát video
  static async createSchedule(userId, body) {
    const { videoId, targetId, startTime, endTime } = { ...body };
    if (!userId) throw new UnauthorizedError(Message.USER_IS_INVALID);
    // Danh sách các thành viên
    const newSchedule = await VideoSchedule.create({
      videoId,
      userId,
      targetId,
      startTime,
      endTime
    });
    return newSchedule;
  }

  // Lấy danh sách lịch phát video của một user
  static async getListSchedule(userId, body) {
    const { index, count } = { ...body };
    if (!userId) throw new UnauthorizedError(Message.USER_IS_INVALID);
    // Danh sách các thành viên
    const listSchedule = await VideoSchedule.findAll({
      where: { userId },
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
        { model: PostVideo, as: 'video' }
      ],
      order: [['id', 'DESC']],
      offset: index,
      limit: count
    });
    const schedulers = [];
    for (const e of listSchedule) {
      const schedules = e.toJSON();
      schedulers.push(schedules);
    }
    console.log(schedulers);
    return {
      schedulers: schedulers.map((scheduler) => ({
        id: String(scheduler.id),
        sender: {
          id: String(scheduler.sender.id),
          name: scheduler.sender.username || '',
          avatar: scheduler.sender.avatar
        },
        receiver: {
          id: String(scheduler.receiver.id),
          name: scheduler.receiver.username || '',
          avatar: scheduler.receiver.avatar
        },
        video: {
          id: String(scheduler.video.id),
          url: scheduler.video.url || ''
        },
        startTime: scheduler.startTime,
        endTime: scheduler.endTime,
        status: scheduler.status || ''
      }))
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
        },
        { model: PostVideo, as: 'video' }
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
        },
        { model: PostVideo, as: 'video' }
      ]
    });
    console.log(schedule.toJSON);
    schedule = schedule.toJSON;
  }

  // Thực hiện việc hẹn phát video
  // static async ScheduleTime() {
  //   const schedules = await VideoSchedule.findAll({
  //     where: {
  //       startTime: { [sequelize.Op.gte]: new Date(), status: '1' }
  //     },
  //     include: [
  //       { Model: User, as: 'sender' },
  //       { Model: User, as: 'receiver' },
  //       { Model: PostVideo, as: 'video' }
  //     ] // Bao gồm thông tin về User và Video
  //   });
  //   // Duyệt qua từng schedules và lập lịch phát video
  //   schedules.forEach((schedule) => {
  //     // Lập lịch để phát video
  //     const second = schedule.startTime.getSeconds();
  //     const minute = schedule.startTime.getMinutes();
  //     const hour = schedule.startTime.getHours();
  //     const day = schedule.startTime.getDate();
  //     const month = schedule.startTime.getMonth() + 1;
  //     const year = schedule.startTime.getFullYear();

  //     const cronExpression = `${second} ${minute} ${hour} ${day} ${month} ${year}`;
  //     cron.schedule(
  //       cronExpression,
  //       () => {
  //         // Thực hiện logic để client có thể phát video đúng startTime
  //       },
  //       {
  //         scheduled: true,
  //         timezone: 'Asian/Singapore'
  //       }
  //     );
  //   });
  // }
}
