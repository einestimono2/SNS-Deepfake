import fs from 'fs';

import axios from 'axios';
import FormData from 'form-data';

import { BadRequestError, ForbiddenError, UnauthorizedError } from '../core/error.response.js';
import { NotificationServices } from '../notification/notification.service.js';
import { User } from '../user/user.model.js';

import { DeepfakeVideo } from './deepfake_video.model.js';

import { Message } from '#constants';
import { deleteFile, getMediaFromPath, setFileUnused, setFileUsed } from '#utils';

const ServerAI = 'https://crisp-labrador-clever.ngrok-free.app/convertfile/convertvideodeepfake_background/';

export class DeepfakeVideoService {
  // Tạo danh sách các đầu vào
  static async createDeepfakeVideo({ title, image, video, audios, userId }) {
    if (!title || !image || !video) {
      throw new BadRequestError(Message.NOT_ENOUGH_DEEPFAKE_DATA);
    }

    const user = await User.findByPk(userId);
    // Trẻ - role == 0
    if (user.role === 0) {
      throw new ForbiddenError(Message.INSUFFICIENT_ACCESS_RIGHTS);
    }

    const usedVideo = setFileUsed(video);

    const imageStream = fs.createReadStream(getMediaFromPath(image));
    const videoStream = fs.createReadStream(getMediaFromPath(usedVideo));

    const form = new FormData();
    form.append('images', imageStream);
    form.append('video', videoStream);
    if (audios && audios.length) {
      audios.map((audio) => form.append('audios', fs.createReadStream(getMediaFromPath(audio))));
    }

    const deepfakeVideo = await DeepfakeVideo.create({
      title,
      url: usedVideo,
      status: 0,
      userId
    });

    try {
      const response = await axios.post(ServerAI, form, {
        headers: {
          'Content-Type': 'multipart/form-data'
        },
        params: {
          user_id: userId,
          user_name: user.username ?? user.email,
          role_id: user.role,
          video_id: deepfakeVideo.id
        }
      });

      console.log(response.data);

      return deepfakeVideo;
    } catch (error) {
      await deepfakeVideo.destroy();
      setFileUnused(usedVideo);
      throw error;
    }
  }

  static async finishDeepfakeVideo({ videoId, videoName }) {
    console.log(`${videoId} - ${videoName}`);

    const video = await DeepfakeVideo.findByPk(videoId);
    if (!video) return;

    const oldVideo = video.url;

    video.url = setFileUsed(`/media/videos/${videoName}`);
    video.status = 1;

    await video.save();

    deleteFile(oldVideo);

    await NotificationServices.notifyCreateVideo(video.userId, video.id);
  }

  // Lấy danh sách các media liên quan tới người dùng
  static async getListDeepfakeVideo({ userId, offset, limit, type = 1 }) {
    if (!userId) throw new UnauthorizedError(Message.USER_IS_INVALID);

    const data = await DeepfakeVideo.findAndCountAll({
      where: { userId, status: type },
      include: [
        {
          model: User,
          as: 'user',
          attributes: ['id', 'username', 'email', 'avatar']
        }
      ],
      distinct: true,
      order: [['id', 'DESC']],
      offset,
      limit
    });

    return data;
  }

  // Xóa thông tin
  static async deleteDeepfakeVideo(userId, id) {
    if (!userId) throw new UnauthorizedError(Message.USER_IS_INVALID);

    const deepfakeVideo = await DeepfakeVideo.findByPk(id);

    if (deepfakeVideo) {
      await deepfakeVideo.destroy();
    }

    deleteFile(deepfakeVideo.url);
  }
}
