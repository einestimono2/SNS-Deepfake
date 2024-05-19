import { UnauthorizedError } from '../core/error.response.js';
import { User } from '../user/user.model.js';

import { DeepfakeVideo } from './deepfale_video.model.js';
import { Media } from './media.model.js';

import { Message } from '#constants';

export class DeepfakeVideoService {
  // Tạo danh sách các đầu vào
  static async createDeepfakeVideo(userId, body) {
    if (!userId) throw new UnauthorizedError(Message.USER_IS_INVALID);
    const { videoUrl, size, fileName } = { ...body };
    let deepfakeVideo = await DeepfakeVideo.create({
      size,
      videoUrl,
      fileName,
      userId
    });
    deepfakeVideo = deepfakeVideo.toJSON();
    return deepfakeVideo;
  }

  // Lấy danh sách các media liên quan tới người dùng
  static async getListDeepfakeVideo(userId, body) {
    const { index, count } = { ...body };
    if (!userId) throw new UnauthorizedError(Message.USER_IS_INVALID);
    const deepfakeVideos = await DeepfakeVideo.findAll({
      where: { userId },
      include: [
        {
          model: User,
          as: 'user'
        }
      ],
      order: [['id', 'DESC']],
      offset: index,
      limit: count
    });
    const newDeepfakeVideos = [];
    for (const e of deepfakeVideos) {
      const deepfakeVideo = e.toJSON();
      newDeepfakeVideos.push(deepfakeVideo);
    }
    console.log(newDeepfakeVideos);
    return {
      deepfakevideos: newDeepfakeVideos.map((deepfakeVideo) => ({
        deepfakeVideo
      }))
    };
  }

  static async getDeepfakeVideoById(req) {
    const { id } = req.params;
    // Danh sách các thành viên
    let deepfakeVideo = await DeepfakeVideo.findOne({
      where: { id },
      include: [
        // Thông tin người gửi
        {
          model: User,
          as: 'user'
        }
      ]
    });
    console.log(deepfakeVideo.toJSON);
    deepfakeVideo = deepfakeVideo.toJSON;
    return {
      deepfakeVideo
    };
  }

  // Xóa thông tin
  static async deleteDeepfakeVideo(userId, deepfakevideoId) {
    if (!userId) throw new UnauthorizedError(Message.USER_IS_INVALID);
    const deepfakeVideo = await Media.findOne({
      where: {
        userId,
        id: deepfakevideoId
      }
    });
    if (deepfakeVideo) {
      await deepfakeVideo.destroy();
    }
    return {};
  }
}
